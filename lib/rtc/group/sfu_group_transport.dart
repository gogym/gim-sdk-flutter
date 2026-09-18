import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../protocol/ImProto.pb.dart' as proto;
import 'group_media_transport.dart';
import 'group_rtc_dto.dart';

/// SFU 群通话媒体传输层（LiveKit 承载媒体，适合大群）
///
/// 职责：
/// - 用 roomState 下发的 sfuUrl + sfuToken 连接 LiveKit 房间
/// - 发布本地摄像头/麦克风（由 LiveKit 统一采集管理）
/// - 订阅远端成员轨道并通过 [GroupMediaTransportCallback] 上报
/// - 生命周期信令仍由引擎经 cmd=51 收发，媒体不经信令通道
class SfuGroupTransport implements GroupMediaTransport {
  /// 当前用户 ID（动态获取）
  final String Function() localUserId;

  /// 传输层事件回调
  final GroupMediaTransportCallback callback;

  // ====================== 内部状态 ======================

  lk.Room? _room;
  lk.EventsListener<lk.RoomEvent>? _listener;

  bool _cameraEnabled = false;
  bool _micEnabled = false;
  bool _disposed = false;

  SfuGroupTransport({
    required this.localUserId,
    required this.callback,
  });

  // ====================== GroupMediaTransport ======================

  @override
  Future<void> start(GroupRoomState roomState) async {
    if (roomState.sfuUrl.isEmpty || roomState.sfuToken.isEmpty) {
      callback.onTransportBroken?.call('SFU 接入信息缺失（sfuUrl/sfuToken 为空）');
      return;
    }
    if (_disposed) return;

    final room = lk.Room(
      roomOptions: const lk.RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      ),
    );
    _room = room;
    _listener = room.createListener();

    // 媒体事件：成员进出与轨道订阅变化（与服务端 participantNotify 双向校准）
    _listener!
      ..on<lk.RoomConnectedEvent>((event) {
        debugPrint('[SfuTransport] room connected: ${room.name}');
        callback.onMediaConnected?.call();
      })
      ..on<lk.ParticipantConnectedEvent>((event) {
        debugPrint('[SfuTransport] participant connected: ${event.participant.identity}');
        _publishRemoteMedia(event.participant);
      })
      ..on<lk.ParticipantDisconnectedEvent>((event) {
        final identity = event.participant.identity;
        debugPrint('[SfuTransport] participant disconnected: $identity');
        callback.onRemoteMemberRemoved?.call(identity);
      })
      ..on<lk.TrackSubscribedEvent>((event) {
        _publishRemoteMedia(event.participant);
      })
      ..on<lk.TrackUnsubscribedEvent>((event) {
        _publishRemoteMedia(event.participant);
      })
      ..on<lk.RoomDisconnectedEvent>((event) {
        debugPrint('[SfuTransport] room disconnected: ${event.reason}');
        callback.onError?.call('SFU 房间已断开: ${event.reason}');
        // 媒体通道不可用，通知引擎以 failed 主动 leave 收口
        callback.onTransportBroken?.call('SFU 房间已断开: ${event.reason}');
      });

    try {
      await room.connect(roomState.sfuUrl, roomState.sfuToken);
    } catch (e) {
      callback.onError?.call('SFU 连接失败: $e');
      // 媒体通道不可用，通知引擎以 failed 主动 leave 收口
      callback.onTransportBroken?.call('SFU 连接失败: $e');
      return;
    }

    // 发布本地媒体（LiveKit 统一采集；音频通话不发布视频轨）
    try {
      final local = room.localParticipant;
      if (local != null) {
        await local.setMicrophoneEnabled(true);
        _micEnabled = true;
        if (roomState.isVideoCall) {
          await setCameraEnabled(true);
          // 本地视频轨就绪，供 UI 预览
          final cameraPub =
              local.getTrackPublicationBySource(lk.TrackSource.camera);
          callback.onLocalVideoTrack
              ?.call(cameraPub?.track as lk.LocalVideoTrack?);
        } else {
          callback.onLocalVideoTrack?.call(null);
        }
      }
    } catch (e) {
      callback.onError?.call('本地媒体发布失败: $e');
    }
  }

  @override
  void handleMediaSignal(proto.RtcSignal signal) {
    // SFU 模式媒体由 LiveKit 通道承载，cmd=50 点对点媒体信令不适用
  }

  @override
  void syncRemoteMembers(Set<String> joinedUserIds) {
    // LiveKit 的成员进出由房间事件驱动（source of truth），
    // 服务端快照仅用于引擎成员状态校准，此处无需处理
    debugPrint(
        '[SfuTransport] syncRemoteMembers(server): ${joinedUserIds.length}');
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async {
    final local = _room?.localParticipant;
    if (local == null) return;
    await local.setCameraEnabled(enabled);
    _cameraEnabled = enabled;
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    final local = _room?.localParticipant;
    if (local == null) return;
    await local.setMicrophoneEnabled(enabled);
    _micEnabled = enabled;
  }

  @override
  Future<void> switchCamera() async {
    try {
      final cameraPub = _room?.localParticipant
          ?.getTrackPublicationBySource(lk.TrackSource.camera);
      final mediaTrack =
          (cameraPub?.track as lk.LocalVideoTrack?)?.mediaStreamTrack;
      if (mediaTrack == null) return;
      await webrtc.Helper.switchCamera(mediaTrack);
    } catch (e) {
      debugPrint('[SfuTransport] switchCamera failed: $e');
    }
  }

  @override
  bool get cameraEnabled => _cameraEnabled;

  @override
  bool get microphoneEnabled => _micEnabled;

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    try {
      _listener?.dispose();
      _listener = null;
      await _room?.dispose();
      _room = null;
    } catch (e) {
      debugPrint('[SfuTransport] dispose error: $e');
    }
    debugPrint('[SfuTransport] disposed');
  }

  // ====================== 远端媒体上报 ======================

  /// 上报远端成员当前媒体状态（按订阅轨道有无视频刷新载体）
  void _publishRemoteMedia(lk.RemoteParticipant participant) {
    if (_disposed) return;
    lk.RemoteVideoTrack? videoTrack;
    for (final pub in participant.videoTrackPublications) {
      final track = pub.track;
      if (track is lk.RemoteVideoTrack && pub.subscribed) {
        videoTrack = track;
        break;
      }
    }
    callback.onRemoteMemberMedia?.call(GroupRemoteMemberMedia(
      userId: participant.identity,
      sfuVideoTrack: videoTrack,
      hasVideo: videoTrack != null,
    ));
  }
}
