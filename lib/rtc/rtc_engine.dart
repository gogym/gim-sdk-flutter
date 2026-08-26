import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import '../protocol/ImProto.pb.dart' as proto;
import '../protocol/cmd.dart';
import '../protocol/packet_codec.dart';
import 'rtc_types.dart';

/// RTC 引擎回调接口
///
/// 项目层实现此接口以响应引擎事件：
/// - [onSendSignal] — 引擎需要发送信令时触发，项目层负责通过 IM 通道发出
/// - [onCallStateChanged] — 通话状态变更通知
/// - [onCallEnded] — 通话结束通知（含结束原因）
/// - [onRemoteStreamReceived] — 远端媒体流到达
/// - [onCallDurationTick] — 每秒通话计时
/// - [onIncomingCall] — 收到来电（被叫方，需展示来电 UI）
class RtcEngineCallback {
  /// 引擎需要发送信令包（项目层通过 IM 通道发送 [packet]）
  final void Function(proto.Packet packet) onSendSignal;

  /// 通话状态变更
  final void Function(RtcCallState state) onCallStateChanged;

  /// 通话结束（含结束原因）
  final void Function(RtcCallEndReason reason) onCallEnded;

  /// 远端媒体流到达
  final void Function(webrtc.MediaStream stream) onRemoteStreamReceived;

  /// 每秒通话计时（[seconds] 为已通话秒数）
  final void Function(int seconds) onCallDurationTick;

  /// 收到来电（[senderId] 来电方，[callId] 通话ID）
  final void Function(String senderId, String callId) onIncomingCall;

  RtcEngineCallback({
    required this.onSendSignal,
    required this.onCallStateChanged,
    required this.onCallEnded,
    required this.onRemoteStreamReceived,
    required this.onCallDurationTick,
    required this.onIncomingCall,
  });
}

/// RTC 引擎 — WebRTC 通话核心能力
///
/// 封装完整的 WebRTC 信令流程（标准 offer/answer 模型）：
/// 1. 主叫 → callRequest → 服务端 → callRequest(+callId) → 被叫
/// 2. 被叫 → callAccept(+callId) → 服务端 → callAccept(+callId) → 主叫
/// 3. 主叫创建 PeerConnection → createOffer → offer → 被叫
/// 4. 被叫创建 PeerConnection → setRemoteDescription(offer) → createAnswer → answer → 主叫
/// 5. 主叫 setRemoteDescription(answer) → 连接建立
/// 6. 双方交换 ICE candidate
///
/// 使用方通过 [RtcEngineCallback] 接收事件，负责：
/// - 信令发送（通过 IM 通道）
/// - UI 导航（来电页面、通话页面）
/// - 权限管理（麦克风、摄像头）
/// - 通话记录等业务逻辑
class RtcEngine {
  /// 获取当前用户 ID 的回调（动态获取，避免初始化时 userId 尚未就绪）
  final String Function() localUserId;

  /// 事件回调
  final RtcEngineCallback callback;

  // ====================== 内部状态 ======================

  /// WebRTC 对等连接
  webrtc.RTCPeerConnection? _peerConnection;

  /// 本地媒体流
  webrtc.MediaStream? _localStream;

  /// 通话状态
  RtcCallState _state = RtcCallState.idle;

  /// 通话结束原因
  RtcCallEndReason _endReason = RtcCallEndReason.none;

  /// 远端用户 ID
  String _remoteUserId = '';

  /// 通话 ID（服务端生成）
  String _callId = '';

  /// 是否为发起方
  bool _isInitiator = false;

  /// 通话类型
  RtcCallType _callType = RtcCallType.video;

  /// ICE 候选缓冲（在远端描述设置前暂存）
  final List<webrtc.RTCIceCandidate> _pendingCandidates = [];

  /// 远端描述是否已设置
  bool _remoteDescSet = false;

  /// 媒体是否已就绪
  bool _mediaReady = false;

  /// 服务端下发的 TURN 凭证信息
  Map<String, dynamic>? _serverTurnInfo;

  /// 通话计时器
  Timer? _callTimer;

  /// 通话时长（秒）
  int _callDuration = 0;

  // ====================== Getters ======================

  RtcCallState get state => _state;
  RtcCallEndReason get endReason => _endReason;
  String get remoteUserId => _remoteUserId;
  String get callId => _callId;
  bool get isInitiator => _isInitiator;
  RtcCallType get callType => _callType;
  int get callDuration => _callDuration;
  webrtc.MediaStream? get localStream => _localStream;

  // ====================== 构造与销毁 ======================

  RtcEngine({
    required this.localUserId,
    required this.callback,
  });

  /// 释放所有资源
  Future<void> dispose() async {
    _callTimer?.cancel();
    await _cleanup();
  }

  // ====================== 公开 API ======================

  /// 发起通话（主叫方入口）
  ///
  /// [targetUserId] 目标用户 ID
  /// [type] 通话类型（音频/视频）
  Future<void> startCall(String targetUserId, RtcCallType type) async {
    _remoteUserId = targetUserId;
    _callType = type;
    _isInitiator = true;
    _endReason = RtcCallEndReason.none;
    _callId = ''; // callId 由服务端生成，通过 callAccept 回传

    _updateState(RtcCallState.calling);

    // 获取本地媒体流
    await _acquireLocalMedia(type);

    // 发送呼叫请求信令（callId 留空，服务端会填充）
    _sendSignal(RtcSignalType.callRequest, targetUserId, {
      'callType': type == RtcCallType.video ? 'video' : 'audio',
    }, callId: '');
  }

  /// 接听通话（被叫方入口）
  ///
  /// 发送 callAccept 信令，并提前获取本地媒体流。
  Future<void> acceptCall() async {
    _sendSignal(RtcSignalType.callAccept, _remoteUserId, {}, callId: _callId);
    _updateState(RtcCallState.connecting);

    // 提前获取本地媒体流
    if (!_mediaReady) {
      await _acquireLocalMedia(_callType);
    }
  }

  /// 拒绝通话（被叫方）
  void rejectCall() {
    _endReason = RtcCallEndReason.rejected;
    _sendSignal(RtcSignalType.callReject, _remoteUserId, {'reason': 'reject'}, callId: _callId);
    _endCall();
  }

  /// 取消呼叫（主叫方）
  void cancelCall() {
    _endReason = RtcCallEndReason.cancelled;
    _sendSignal(RtcSignalType.callCancel, _remoteUserId, {'reason': 'cancel'}, callId: _callId);
    _endCall();
  }

  /// 挂断通话
  void hangup() {
    _endReason = RtcCallEndReason.normal;
    _sendSignal(RtcSignalType.callHangup, _remoteUserId, {'reason': 'normal'}, callId: _callId);
    _endCall();
  }

  /// 切换摄像头开关（通话中实时生效）
  void toggleCamera() {
    final stream = _localStream;
    if (stream == null) return;
    final videoTracks = stream.getVideoTracks();
    if (videoTracks.isEmpty) return;
    for (final track in videoTracks) {
      track.enabled = !track.enabled;
    }
  }

  /// 切换麦克风开关（通话中实时生效）
  void toggleMicrophone() {
    final stream = _localStream;
    if (stream == null) return;
    final audioTracks = stream.getAudioTracks();
    if (audioTracks.isEmpty) return;
    for (final track in audioTracks) {
      track.enabled = !track.enabled;
    }
  }

  /// 切换前后摄像头
  Future<void> switchCamera() async {
    try {
      final videoTracks = _localStream?.getVideoTracks();
      if (videoTracks == null || videoTracks.isEmpty) return;
      await webrtc.Helper.switchCamera(videoTracks.first);
    } catch (e) {
      debugPrint('[RtcEngine] switchCamera failed: $e');
    }
  }

  /// 查询摄像头是否启用
  bool get cameraEnabled {
    final tracks = _localStream?.getVideoTracks();
    if (tracks == null || tracks.isEmpty) return false;
    return tracks.first.enabled;
  }

  /// 查询麦克风是否启用
  bool get microphoneEnabled {
    final tracks = _localStream?.getAudioTracks();
    if (tracks == null || tracks.isEmpty) return false;
    return tracks.first.enabled;
  }

  /// 格式化通话时长
  static String formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ====================== 信令分发入口 ======================

  /// 处理收到的 RTC 信令（由项目层从 IM 事件中转调）
  void handleSignal(proto.RtcSignal signal) {
    debugPrint('[RtcEngine] signal type=${signal.signalType} from=${signal.senderId} callId=${signal.callId}');

    switch (signal.signalType) {
      case RtcSignalType.callRequest:
        _onCallRequest(signal);
        break;
      case RtcSignalType.callAccept:
        _onCallAccept(signal);
        break;
      case RtcSignalType.callReject:
        _onCallReject(signal);
        break;
      case RtcSignalType.callCancel:
        _onCallCancel();
        break;
      case RtcSignalType.callHangup:
        _onCallHangup();
        break;
      case RtcSignalType.offer:
        _onOffer(signal);
        break;
      case RtcSignalType.answer:
        _onAnswer(signal);
        break;
      case RtcSignalType.iceCandidate:
        _onIceCandidate(signal);
        break;
    }
  }

  // ====================== 信令事件处理 ======================

  /// 收到呼叫请求（被叫方）
  void _onCallRequest(proto.RtcSignal signal) {
    _remoteUserId = signal.senderId;
    _callId = signal.callId;
    _callType = RtcCallType.video;
    _isInitiator = false;
    _endReason = RtcCallEndReason.none;

    // 解析服务端下发的 TURN 凭证
    if (signal.payload.isNotEmpty) {
      _parseTurnFromPayload(jsonDecode(signal.payload) as Map<String, dynamic>);
    }

    _updateState(RtcCallState.ringing);

    // 通知项目层展示来电 UI
    callback.onIncomingCall(signal.senderId, signal.callId);
  }

  /// 收到接听（主叫方）→ 创建 PeerConnection 并发送 Offer
  void _onCallAccept(proto.RtcSignal signal) {
    if (signal.callId.isNotEmpty) {
      _callId = signal.callId;
    }

    // 解析服务端下发的 TURN 凭证（在创建 PeerConnection 之前）
    if (signal.payload.isNotEmpty) {
      _parseTurnFromPayload(jsonDecode(signal.payload) as Map<String, dynamic>);
    }

    _updateState(RtcCallState.connecting);
    _createAndSendOffer();
  }

  /// 收到拒绝
  void _onCallReject(proto.RtcSignal signal) {
    final payload = signal.payload.isNotEmpty ? jsonDecode(signal.payload) : {};
    final reason = payload['reason'] as String?;
    _endReason = (reason == 'busy') ? RtcCallEndReason.busy : RtcCallEndReason.rejected;
    _endCall();
  }

  /// 收到取消
  void _onCallCancel() {
    _endReason = RtcCallEndReason.cancelled;
    _endCall();
  }

  /// 收到挂断
  void _onCallHangup() {
    _endReason = RtcCallEndReason.normal;
    _endCall();
  }

  // ====================== WebRTC 核心流程 ======================

  /// 主叫方：创建 Offer 并发送
  Future<void> _createAndSendOffer() async {
    await _initPeerConnection();

    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    _sendSignal(RtcSignalType.offer, _remoteUserId, {
      'sdp': offer.sdp,
    }, callId: _callId);

    debugPrint('[RtcEngine] Offer sent to $_remoteUserId');
  }

  /// 被叫方：收到 Offer，创建 Answer
  Future<void> _onOffer(proto.RtcSignal signal) async {
    await _initPeerConnection();

    final payload = jsonDecode(signal.payload);
    final desc = webrtc.RTCSessionDescription(payload['sdp'] as String, 'offer');
    await _peerConnection!.setRemoteDescription(desc);
    debugPrint('[RtcEngine] Remote description set (offer)');

    await _flushPendingCandidates();

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    _sendSignal(RtcSignalType.answer, signal.senderId, {
      'sdp': answer.sdp,
    }, callId: _callId);

    debugPrint('[RtcEngine] Answer sent to ${signal.senderId}');
  }

  /// 主叫方：收到 Answer，设置远端描述
  Future<void> _onAnswer(proto.RtcSignal signal) async {
    final payload = jsonDecode(signal.payload);
    final desc = webrtc.RTCSessionDescription(payload['sdp'] as String, 'answer');
    await _peerConnection!.setRemoteDescription(desc);
    debugPrint('[RtcEngine] Remote description set (answer)');

    await _flushPendingCandidates();
  }

  /// 处理远端 ICE Candidate
  Future<void> _onIceCandidate(proto.RtcSignal signal) async {
    final payload = jsonDecode(signal.payload);
    final candidate = webrtc.RTCIceCandidate(
      payload['candidate'] as String,
      payload['sdpMid'] as String?,
      payload['sdpMLineIndex'] as int?,
    );

    if (_remoteDescSet && _peerConnection != null) {
      await _peerConnection!.addCandidate(candidate);
      debugPrint('[RtcEngine] Remote ICE candidate added immediately');
    } else {
      _pendingCandidates.add(candidate);
      debugPrint('[RtcEngine] Remote ICE candidate buffered (pending: ${_pendingCandidates.length})');
    }
  }

  // ====================== PeerConnection 管理 ======================

  /// 初始化 PeerConnection
  ///
  /// 防重复：如果 PeerConnection 已存在且媒体就绪则复用
  Future<void> _initPeerConnection() async {
    if (_peerConnection != null && _mediaReady) {
      debugPrint('[RtcEngine] PeerConnection already exists, reusing');
      return;
    }

    final config = {
      'iceServers': _buildIceServers(),
    };
    _peerConnection = await webrtc.createPeerConnection(config);
    debugPrint('[RtcEngine] PeerConnection created');

    _remoteDescSet = false;
    _pendingCandidates.clear();

    _peerConnection!.onIceCandidate = (candidate) {
      debugPrint('[RtcEngine] Local ICE candidate generated');
      _sendSignal(RtcSignalType.iceCandidate, _remoteUserId, {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      }, callId: _callId);
    };

    _peerConnection!.onTrack = (event) {
      debugPrint('[RtcEngine] onTrack: kind=${event.track.kind}, streams=${event.streams.length}');
      if (event.streams.isNotEmpty) {
        callback.onRemoteStreamReceived(event.streams[0]);
      }
    };

    _peerConnection!.onConnectionState = (state) {
      debugPrint('[RtcEngine] PeerConnection state: $state');
      if (state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        _onPeerConnected();
      } else if (state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
                 state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        _endCall();
      }
    };

    // 备用：ICE 连接状态（某些平台 onConnectionState 不可靠）
    _peerConnection!.onIceConnectionState = (state) {
      debugPrint('[RtcEngine] ICE connection state: $state');
      if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateConnected ||
          state == webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted) {
        _onPeerConnected();
      }
    };

    // 获取本地媒体流（如果尚未获取）
    if (!_mediaReady) {
      await _acquireLocalMedia(_callType);
    }

    // 将本地媒体轨道添加到 PeerConnection
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });
      debugPrint('[RtcEngine] Local tracks added to PeerConnection');
    }
  }

  /// 连接成功回调（去重）
  void _onPeerConnected() {
    if (_state == RtcCallState.connected) return;
    _updateState(RtcCallState.connected);
    _startTimer();
    debugPrint('[RtcEngine] Call connected, timer started');
  }

  /// 将缓冲的 ICE 候选添加到 PeerConnection
  Future<void> _flushPendingCandidates() async {
    _remoteDescSet = true;
    if (_pendingCandidates.isEmpty) return;
    debugPrint('[RtcEngine] Flushing ${_pendingCandidates.length} pending ICE candidates');
    for (final candidate in _pendingCandidates) {
      await _peerConnection!.addCandidate(candidate);
    }
    _pendingCandidates.clear();
  }

  // ====================== 媒体管理 ======================

  /// 获取本地媒体流
  ///
  /// 直接调用 getUserMedia，权限由项目层在调用 startCall/acceptCall 前确保。
  Future<void> _acquireLocalMedia(RtcCallType type) async {
    if (_mediaReady) return;

    final constraints = {
      'audio': true,
      'video': type == RtcCallType.video,
    };
    _localStream = await webrtc.navigator.mediaDevices.getUserMedia(constraints);
    _mediaReady = true;
    debugPrint('[RtcEngine] Local media acquired: '
        'audio=${_localStream!.getAudioTracks().length}, '
        'video=${_localStream!.getVideoTracks().length}');
  }

  // ====================== 内部工具 ======================

  /// 发送信令
  void _sendSignal(int signalType, String receiverId, Map<String, dynamic> payload, {String? callId}) {
    final body = proto.RtcSignal()
      ..signalType = signalType
      ..senderId = localUserId()
      ..receiverId = receiverId
      ..payload = jsonEncode(payload)
      ..callId = callId ?? _callId;

    final packet = PacketCodec.create(Cmd.rtcSignal, body: body);
    callback.onSendSignal(packet);
  }

  /// 更新状态并通知
  void _updateState(RtcCallState newState) {
    _state = newState;
    callback.onCallStateChanged(newState);
  }

  /// 结束通话
  void _endCall() {
    _callTimer?.cancel();

    if (_endReason == RtcCallEndReason.none) {
      _endReason = RtcCallEndReason.failed;
    }

    _updateState(RtcCallState.ended);
    callback.onCallEnded(_endReason);
    _cleanup();

    // 延迟恢复空闲状态
    Future.delayed(const Duration(seconds: 1), () {
      if (_state == RtcCallState.ended) {
        _updateState(RtcCallState.idle);
      }
    });
  }

  /// 清理 WebRTC 资源
  Future<void> _cleanup() async {
    try {
      await _localStream?.dispose();
      _localStream = null;
      await _peerConnection?.close();
      _peerConnection = null;
      _mediaReady = false;
      _remoteDescSet = false;
      _pendingCandidates.clear();
      _serverTurnInfo = null;
      _callId = '';
    } catch (e) {
      debugPrint('[RtcEngine] cleanup error: $e');
    }
  }

  /// 启动通话计时
  void _startTimer() {
    _callDuration = 0;
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _callDuration += 1;
      callback.onCallDurationTick(_callDuration);
    });
  }

  // ====================== ICE / TURN 配置 ======================

  /// 构建 ICE 服务器配置
  ///
  /// 优先使用服务端在 callRequest/callAccept 中下发的 TURN 凭证，
  /// 若未收到则回退到 Google 公共 STUN。
  List<Map<String, dynamic>> _buildIceServers() {
    final servers = <Map<String, dynamic>>[];

    final turnInfo = _serverTurnInfo;
    if (turnInfo != null && turnInfo['turnUrl'] != null) {
      if (turnInfo['stunUrl'] != null) {
        servers.add({'urls': turnInfo['stunUrl']});
      }
      servers.add({
        'urls': turnInfo['turnUrl'],
        'username': turnInfo['username'] ?? '',
        'credential': turnInfo['credential'] ?? '',
      });
      debugPrint('[RtcEngine] ICE servers: STUN+TURN from server payload');
      return servers;
    }

    servers.add({'urls': 'stun:stun.l.google.com:19302'});
    debugPrint('[RtcEngine] ICE servers: fallback to Google STUN');
    return servers;
  }

  /// 从信令 payload 中解析服务端下发的 TURN 凭证
  void _parseTurnFromPayload(Map<String, dynamic> payload) {
    final turn = payload['turn'];
    if (turn is Map<String, dynamic>) {
      _serverTurnInfo = turn;
      debugPrint('[RtcEngine] TURN info parsed: turnUrl=${turn['turnUrl']}');
    }
  }
}
