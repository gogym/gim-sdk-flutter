import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import '../../protocol/ImProto.pb.dart' as proto;
import '../rtc_types.dart';
import 'group_media_transport.dart';
import 'group_rtc_dto.dart';
import 'group_rtc_types.dart';

/// Mesh 群通话媒体传输层（成员间 P2P 直连，服务端只扇出信令）
///
/// 职责：
/// - 收到 roomState 后对每个已 joined 成员建连（offer 由 userId 字典序较小方发起，
///   见 [isMeshOfferer]，两端决策一致，避免同时 Offer 冲突）
/// - offer/answer/ICE 经 cmd=50 RtcSignal 点对点收发（与 1:1 信令类型一致）
/// - 成员离开/结束时关闭对应 PeerConnection
class MeshGroupTransport implements GroupMediaTransport {
  /// 当前用户 ID（动态获取）
  final String Function() localUserId;

  /// 传输层事件回调
  final GroupMediaTransportCallback callback;

  /// 本地媒体流（由引擎获取并持有，传输层只引用不释放）
  final webrtc.MediaStream? localStream;

  // ====================== 内部状态 ======================

  /// 对端连接表（key=对端 userId）
  final Map<String, _MeshPeer> _peers = {};

  List<Map<String, dynamic>> _iceServers = const [];

  /// 当前通话 callId（媒体信令携带，供对端过滤串线）
  String _callId = '';

  bool _disposed = false;

  MeshGroupTransport({
    required this.localUserId,
    required this.callback,
    this.localStream,
  });

  // ====================== GroupMediaTransport ======================

  @override
  Future<void> start(GroupRoomState roomState) async {
    _iceServers = buildGroupIceServers(roomState.turnInfo);
    _callId = roomState.callId;

    final me = localUserId();
    final joinedPeers = roomState.members
        .where((m) => m.userId != me && m.status == GroupMemberStatus.joined)
        .map((m) => m.userId)
        .toList();

    debugPrint('[MeshTransport] start: peers=$joinedPeers, callId=$_callId');
    for (final peerId in joinedPeers) {
      await _connectPeer(peerId, makeOffer: isMeshOfferer(me, peerId));
    }
  }

  @override
  void handleMediaSignal(proto.RtcSignal signal) {
    if (_disposed) return;
    switch (signal.signalType) {
      case RtcSignalType.offer:
        _onOffer(signal);
        break;
      case RtcSignalType.answer:
        _onAnswer(signal);
        break;
      case RtcSignalType.iceCandidate:
        _onRemoteCandidate(signal);
        break;
      default:
        break;
    }
  }

  @override
  void syncRemoteMembers(Set<String> joinedUserIds) {
    final stale = _peers.keys
        .where((userId) => !joinedUserIds.contains(userId))
        .toList();
    for (final userId in stale) {
      debugPrint('[MeshTransport] peer left: $userId');
      _closePeer(userId);
      callback.onRemoteMemberRemoved?.call(userId);
    }
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async {
    _setTrackEnabled(localStream?.getVideoTracks(), enabled);
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    _setTrackEnabled(localStream?.getAudioTracks(), enabled);
  }

  @override
  Future<void> switchCamera() async {
    try {
      final videoTracks = localStream?.getVideoTracks();
      if (videoTracks == null || videoTracks.isEmpty) return;
      await webrtc.Helper.switchCamera(videoTracks.first);
    } catch (e) {
      debugPrint('[MeshTransport] switchCamera failed: $e');
    }
  }

  @override
  bool get cameraEnabled => _trackEnabled(localStream?.getVideoTracks());

  @override
  bool get microphoneEnabled => _trackEnabled(localStream?.getAudioTracks());

  @override
  Future<void> dispose() async {
    _disposed = true;
    for (final userId in List<String>.from(_peers.keys)) {
      _closePeer(userId);
    }
    _peers.clear();
    debugPrint('[MeshTransport] disposed');
  }

  // ====================== 对端连接管理 ======================

  /// 建立与对端的 PeerConnection（已存在则跳过）
  Future<void> _connectPeer(String peerId, {required bool makeOffer}) async {
    if (_disposed) return;
    if (_peers.containsKey(peerId)) {
      debugPrint('[MeshTransport] peer exists, skip: $peerId');
      return;
    }

    final config = {'iceServers': _iceServers};
    final pc = await webrtc.createPeerConnection(config);
    final peer = _MeshPeer(pc);
    _peers[peerId] = peer;
    debugPrint('[MeshTransport] peer created: $peerId (offerer=$makeOffer)');

    pc.onIceCandidate = (candidate) {
      _sendMediaSignal(RtcSignalType.iceCandidate, peerId, {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    pc.onTrack = (event) {
      if (event.streams.isEmpty) return;
      final stream = event.streams[0];
      debugPrint('[MeshTransport] remote track: peer=$peerId, ${stream.id}');
      callback.onRemoteMemberMedia?.call(GroupRemoteMemberMedia(
        userId: peerId,
        meshStream: stream,
        hasVideo: stream.getVideoTracks().isNotEmpty,
      ));
    };

    pc.onConnectionState = (state) {
      debugPrint('[MeshTransport] peer $peerId connection: $state');
      if (state ==
          webrtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        callback.onMediaConnected?.call();
      }
    };

    // 加入本地媒体轨
    final stream = localStream;
    if (stream != null) {
      for (final track in stream.getTracks()) {
        await pc.addTrack(track, stream);
      }
    }

    if (makeOffer) {
      await _createOffer(peerId);
    }
  }

  /// 发起 Offer（字典序较小方调用）
  Future<void> _createOffer(String peerId) async {
    final peer = _peers[peerId];
    if (peer == null) return;
    final offer = await peer.pc.createOffer();
    await peer.pc.setLocalDescription(offer);
    _sendMediaSignal(RtcSignalType.offer, peerId, {'sdp': offer.sdp});
    debugPrint('[MeshTransport] offer sent to $peerId');
  }

  /// 收到 Offer（Answer 方：不存在则先建连，再应答）
  Future<void> _onOffer(proto.RtcSignal signal) async {
    final senderId = signal.senderId;
    var peer = _peers[senderId];
    if (peer == null) {
      await _connectPeer(senderId, makeOffer: false);
      peer = _peers[senderId];
      if (peer == null) return;
    }

    final payload = _parsePayload(signal.payload);
    final desc =
        webrtc.RTCSessionDescription(payload['sdp'] as String?, 'offer');
    await peer.pc.setRemoteDescription(desc);
    peer.remoteDescSet = true;
    await _flushPendingCandidates(peer);

    final answer = await peer.pc.createAnswer();
    await peer.pc.setLocalDescription(answer);
    _sendMediaSignal(RtcSignalType.answer, senderId, {'sdp': answer.sdp});
    debugPrint('[MeshTransport] answer sent to $senderId');
  }

  /// 收到 Answer（Offer 方：设置远端描述）
  Future<void> _onAnswer(proto.RtcSignal signal) async {
    final peer = _peers[signal.senderId];
    if (peer == null) {
      debugPrint('[MeshTransport] answer from unknown peer: ${signal.senderId}');
      return;
    }
    final payload = _parsePayload(signal.payload);
    final desc =
        webrtc.RTCSessionDescription(payload['sdp'] as String?, 'answer');
    await peer.pc.setRemoteDescription(desc);
    peer.remoteDescSet = true;
    await _flushPendingCandidates(peer);
    debugPrint('[MeshTransport] answer applied: ${signal.senderId}');
  }

  /// 收到远端 ICE Candidate（远端描述未就绪前缓冲）
  Future<void> _onRemoteCandidate(proto.RtcSignal signal) async {
    final peer = _peers[signal.senderId];
    if (peer == null) return;
    final payload = _parsePayload(signal.payload);
    final candidate = webrtc.RTCIceCandidate(
      payload['candidate'] as String?,
      payload['sdpMid'] as String?,
      payload['sdpMLineIndex'] as int?,
    );
    if (peer.remoteDescSet) {
      await peer.pc.addCandidate(candidate);
    } else {
      peer.pendingCandidates.add(candidate);
    }
  }

  /// 关闭并移除对端连接
  void _closePeer(String userId) {
    final peer = _peers.remove(userId);
    if (peer == null) return;
    try {
      peer.pc.close();
    } catch (e) {
      debugPrint('[MeshTransport] close peer error: $e');
    }
  }

  // ====================== 信令与工具 ======================

  /// 发送点对点媒体信令（cmd=50 RtcSignal，由引擎包装为 Packet 发出）
  void _sendMediaSignal(
      int signalType, String receiverId, Map<String, dynamic> payload) {
    final body = proto.RtcSignal()
      ..signalType = signalType
      ..senderId = localUserId()
      ..receiverId = receiverId
      ..payload = jsonEncode(payload)
      ..callId = _callId;
    callback.onSendMediaSignal?.call(body);
  }

  /// 将缓冲的 ICE Candidate 应用到对端连接
  Future<void> _flushPendingCandidates(_MeshPeer peer) async {
    if (peer.pendingCandidates.isEmpty) return;
    final count = peer.pendingCandidates.length;
    for (final candidate in peer.pendingCandidates) {
      await peer.pc.addCandidate(candidate);
    }
    peer.pendingCandidates.clear();
    debugPrint('[MeshTransport] flushed $count candidates');
  }

  /// 解析信令 payload JSON（异常时返回空 Map）
  Map<String, dynamic> _parsePayload(String payload) {
    try {
      final value = jsonDecode(payload);
      return value is Map<String, dynamic> ? value : const {};
    } catch (_) {
      return const {};
    }
  }

  /// 设置轨道开关
  void _setTrackEnabled(List<webrtc.MediaStreamTrack>? tracks, bool enabled) {
    if (tracks == null) return;
    for (final track in tracks) {
      track.enabled = enabled;
    }
  }

  /// 查询轨道开关（无轨道视为关闭）
  bool _trackEnabled(List<webrtc.MediaStreamTrack>? tracks) {
    if (tracks == null || tracks.isEmpty) return false;
    return tracks.first.enabled;
  }
}

/// Mesh 对端连接条目
class _MeshPeer {
  final webrtc.RTCPeerConnection pc;

  /// 远端描述就绪前缓冲的 ICE 候选
  final List<webrtc.RTCIceCandidate> pendingCandidates = [];

  bool remoteDescSet = false;

  _MeshPeer(this.pc);
}
