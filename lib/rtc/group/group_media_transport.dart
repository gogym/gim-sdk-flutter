import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../protocol/ImProto.pb.dart' as proto;
import 'group_rtc_dto.dart';

/// 远端成员媒体载体（屏蔽 Mesh / SFU 差异）
///
/// - Mesh 模式：[meshStream] 为 flutter_webrtc 的 MediaStream，
///   UI 层用 RTCVideoRenderer.srcObject 绑定渲染；
/// - SFU 模式：[sfuVideoTrack] 为 LiveKit 的 VideoTrack，
///   UI 层用 livekit 的 VideoTrackRenderer 渲染（音频轨道自动播放）。
class GroupRemoteMemberMedia {
  /// 成员 userId（Mesh 为信令 userId；SFU 为 LiveKit participant.identity，与服务端 userId 一致）
  final String userId;

  /// Mesh 模式远端媒体流
  final webrtc.MediaStream? meshStream;

  /// SFU 模式远端视频轨（可空，纯音频成员无视频轨）
  final lk.VideoTrack? sfuVideoTrack;

  /// 是否包含视频轨
  final bool hasVideo;

  const GroupRemoteMemberMedia({
    required this.userId,
    this.meshStream,
    this.sfuVideoTrack,
    this.hasVideo = true,
  });

  /// 是否为 SFU 载体（UI 层据此选择渲染组件）
  bool get isSfu => sfuVideoTrack != null;
}

/// 群通话媒体传输层回调
///
/// 传输层只负责媒体（建连/发布/订阅/开关），生命周期信令由引擎统一收发。
class GroupMediaTransportCallback {
  /// Mesh 模式：发送点对点媒体信令（cmd=50 RtcSignal，offer/answer/ICE）
  final void Function(proto.RtcSignal signal)? onSendMediaSignal;

  /// 远端成员媒体新增/更新（去重由引擎按 userId 覆盖）
  final void Function(GroupRemoteMemberMedia media)? onRemoteMemberMedia;

  /// 远端成员媒体移除（成员离开/断连）
  final void Function(String userId)? onRemoteMemberRemoved;

  /// SFU 模式：本地视频轨就绪（UI 用 VideoTrackRenderer 预览）
  final void Function(lk.VideoTrack? track)? onLocalVideoTrack;

  /// 媒体连接就绪（Mesh：首个对端连通；SFU：房间连接成功）→ 引擎启动计时
  final void Function()? onMediaConnected;

  /// 传输层错误（不中断通话，仅上报供 UI 提示/日志）
  final void Function(String message)? onError;

  const GroupMediaTransportCallback({
    this.onSendMediaSignal,
    this.onRemoteMemberMedia,
    this.onRemoteMemberRemoved,
    this.onLocalVideoTrack,
    this.onMediaConnected,
    this.onError,
  });
}

/// 群通话媒体传输层抽象
///
/// 统一 Mesh（P2P 多路）与 SFU（LiveKit）两套实现的契约，
/// 引擎依据 roomState.mode 通过工厂选择实现（见 GroupRtcEngine）。
abstract class GroupMediaTransport {
  /// 启动传输层（收到 roomState 快照后调用）
  ///
  /// Mesh：对快照中已 joined 的成员逐一建连（含 Offer 发起决策）；
  /// SFU：用 sfuUrl + sfuToken 连接 LiveKit 房间并发布本地媒体。
  Future<void> start(GroupRoomState roomState);

  /// 处理点对点媒体信令（Mesh 专用：offer/answer/ICE，引擎从 cmd=50 转发）
  ///
  /// SFU 实现为空操作（媒体由 LiveKit 通道承载）。
  void handleMediaSignal(proto.RtcSignal signal);

  /// 按服务端最新成员快照校准远端连接（关闭已离开成员的连接/订阅）
  ///
  /// [joinedUserIds] 当前仍在通话中的成员 userId 集合。
  void syncRemoteMembers(Set<String> joinedUserIds);

  /// 开关摄像头（成功后状态以 [cameraEnabled] 为准）
  Future<void> setCameraEnabled(bool enabled);

  /// 开关麦克风
  Future<void> setMicrophoneEnabled(bool enabled);

  /// 切换前后摄像头
  Future<void> switchCamera();

  /// 当前摄像头开关状态
  bool get cameraEnabled;

  /// 当前麦克风开关状态
  bool get microphoneEnabled;

  /// 释放传输层资源（不释放引擎持有的本地媒体流）
  Future<void> dispose();
}

/// 传输层通用工具：ICE Server 配置
///
/// 优先使用服务端 roomState 下发的 TURN/STUN 凭据，
/// 缺失时回退 Google 公共 STUN（与 1:1 RtcEngine 行为一致）。
List<Map<String, dynamic>> buildGroupIceServers(TurnCredentials? turnInfo) {
  final servers = turnInfo?.toIceServers() ?? const [];
  if (servers.isNotEmpty) {
    debugPrint('[GroupMediaTransport] ICE servers: from roomState turnInfo');
    return List<Map<String, dynamic>>.from(servers);
  }
  debugPrint('[GroupMediaTransport] ICE servers: fallback to Google STUN');
  return [
    {'urls': fallbackStunUrl},
  ];
}

/// Google 公共 STUN 兜底地址
const String fallbackStunUrl = 'stun:stun.l.google.com:19302';

/// 判断 Mesh 模式下由谁发起 Offer（确定性规则，避免双方同时 Offer 冲突）
///
/// userId 字典序较小的一方发起，两端计算结果一致。
bool isMeshOfferer(String localUserId, String peerUserId) {
  return localUserId.compareTo(peerUserId) < 0;
}
