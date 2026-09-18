import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:uuid/uuid.dart';

import '../../protocol/cmd.dart';
import '../../protocol/ImProto.pb.dart' as proto;
import '../../protocol/packet_codec.dart';
import '../rtc_types.dart';
import 'group_media_transport.dart';
import 'group_rtc_dto.dart';
import 'group_rtc_types.dart';
import 'mesh_group_transport.dart';
import 'sfu_group_transport.dart';

/// 群通话引擎回调
///
/// 使用方实现此回调以响应引擎事件：
/// - [onSendGroupSignal] — 引擎需要发送群通话信令（cmd=51 Packet），项目层负责发出
/// - [onSendMediaSignal] — Mesh 模式点对点媒体信令（cmd=50 Packet），项目层负责发出
/// - [onIncomingGroupCall] — 收到群通话邀请（被邀方，需展示来电 UI）
/// - [onRoomStateChanged] — 房间快照到达（发起人/加入者都会收到）
/// - [onLocalStreamReady] / [onLocalVideoTrack] — 本地媒体就绪（Mesh/SFU 分别回调）
/// - [onRemoteMemberMedia] / [onRemoteMemberRemoved] — 远端成员媒体变化
/// - [onMemberMediaStateChanged] — 成员摄像头/麦克风开关变化
/// - [onMembersUpdated] — 成员列表变化（UI 重建）
/// - [onCallEnded] / [onCallDurationTick] — 通话结束与计时
/// - [onError] — 非致命错误上报
class GroupRtcEngineCallback {
  final void Function(proto.Packet packet) onSendGroupSignal;
  final void Function(proto.Packet packet) onSendMediaSignal;
  final void Function(GroupCallState state) onCallStateChanged;
  final void Function(GroupCallInvite invite, String roomId) onIncomingGroupCall;
  final void Function(GroupRoomState roomState) onRoomStateChanged;
  final void Function(webrtc.MediaStream stream) onLocalStreamReady;
  final void Function(lk.VideoTrack? track) onLocalVideoTrack;
  final void Function(GroupRemoteMemberMedia media) onRemoteMemberMedia;
  final void Function(String userId) onRemoteMemberRemoved;
  final void Function(String userId, bool? camera, bool? mic)
      onMemberMediaStateChanged;
  final void Function() onMembersUpdated;
  final void Function(GroupCallEndReason reason) onCallEnded;
  final void Function(int seconds) onCallDurationTick;
  final void Function(String message) onError;

  const GroupRtcEngineCallback({
    required this.onSendGroupSignal,
    required this.onSendMediaSignal,
    required this.onCallStateChanged,
    required this.onIncomingGroupCall,
    required this.onRoomStateChanged,
    required this.onLocalStreamReady,
    required this.onLocalVideoTrack,
    required this.onRemoteMemberMedia,
    required this.onRemoteMemberRemoved,
    required this.onMemberMediaStateChanged,
    required this.onMembersUpdated,
    required this.onCallEnded,
    required this.onCallDurationTick,
    required this.onError,
  });
}

/// 群通话引擎 — 生命周期信令（cmd=51）+ 媒体传输层（Mesh/SFU 策略选择）
///
/// 信令时序（与服务端 GroupCallService 对应）：
/// 1. 发起人 groupCallRequest(20) → 服务端建房 → 发起人收 roomState(27)、成员收 invite(21)
/// 2. 被邀方 groupCallJoin(22) → 收 roomState(27)，在房成员收 participantNotify(26, join)
/// 3. Mesh：成员间按快照建连，offer/answer/ICE 走 cmd=50 点对点
///    SFU：客户端用 roomState.sfuToken 连接 LiveKit 收发媒体
/// 4. mediaState(100) 上报开关 → 服务端广播 participantNotify(26, media)
/// 5. leave(24)/end(25) → 广播成员变更/通话结束
class GroupRtcEngine {
  /// 当前用户 ID（动态获取，避免初始化时未就绪）
  final String Function() localUserId;

  /// 事件回调
  final GroupRtcEngineCallback callback;

  // ====================== 内部状态 ======================

  GroupCallState _state = GroupCallState.idle;
  GroupCallEndReason _endReason = GroupCallEndReason.none;

  String _callId = '';
  String _roomId = '';
  String _groupId = '';
  RtcCallType _callType = RtcCallType.video;
  GroupCallMode _mode = GroupCallMode.mesh;
  bool _isInitiator = false;

  /// 成员快照（key=userId，含邀请/加入/离开/拒绝状态与媒体开关）
  final Map<String, GroupMemberInfo> _members = {};

  /// 媒体传输层（Mesh/SFU，roomState 到达后创建）
  GroupMediaTransport? _transport;

  /// 本地媒体流（仅 Mesh 模式由引擎获取；SFU 由 LiveKit 管理）
  webrtc.MediaStream? _localStream;

  bool _cameraEnabled = true;
  bool _micEnabled = true;

  Timer? _callTimer;
  int _callDuration = 0;

  // ====================== Getters ======================

  GroupCallState get state => _state;
  GroupCallEndReason get endReason => _endReason;
  String get callId => _callId;
  String get roomId => _roomId;
  String get groupId => _groupId;
  GroupCallMode get mode => _mode;
  RtcCallType get callType => _callType;
  bool get isInitiator => _isInitiator;
  int get callDuration => _callDuration;
  bool get cameraEnabled => _transport?.cameraEnabled ?? _cameraEnabled;
  bool get microphoneEnabled => _transport?.microphoneEnabled ?? _micEnabled;
  webrtc.MediaStream? get localStream => _localStream;

  /// 当前成员快照（按 userId 排序，UI 直接展示）
  List<GroupMemberInfo> get members {
    final list = _members.values.toList()
      ..sort((a, b) => a.userId.compareTo(b.userId));
    return list;
  }

  /// 查询单个成员
  GroupMemberInfo? getMember(String userId) => _members[userId];

  /// 仍在通话中的成员 ID 集合
  Set<String> get joinedMemberIds => _members.entries
      .where((e) => e.value.status == GroupMemberStatus.joined)
      .map((e) => e.key)
      .toSet();

  // ====================== 构造与销毁 ======================

  GroupRtcEngine({required this.localUserId, required this.callback});

  /// 释放所有资源
  Future<void> dispose() async {
    _callTimer?.cancel();
    await _cleanup();
  }

  // ====================== 公开 API（UI 层调用） ======================

  /// 发起群通话（主叫方入口）
  ///
  /// [groupId] 目标群组；[callType] 音频/视频；
  /// [inviteeIds] 受邀成员（空则服务端邀请群内全部活跃成员）。
  Future<void> startGroupCall({
    required String groupId,
    required RtcCallType callType,
    List<String>? inviteeIds,
  }) async {
    _resetSession();
    _groupId = groupId;
    _callType = callType;
    _isInitiator = true;
    _callId = const Uuid().v4(); // 客户端生成，服务端沿用（见 GroupCallExample）

    _updateState(GroupCallState.calling);

    _sendGroupSignal(GroupSignalType.groupCallRequest,
        payload: jsonEncode(GroupCallRequestPayload(
          callType: callType == RtcCallType.video ? 'video' : 'audio',
          inviteeIds: inviteeIds,
        )));
    debugPrint(
        '[GroupRtcEngine] group call requested: group=$groupId, callId=$_callId');
  }

  /// 接受群通话邀请（被邀方入口）
  Future<void> acceptGroupCall() async {
    if (_roomId.isEmpty) {
      callback.onError.call('无待接受的群通话邀请');
      return;
    }
    _updateState(GroupCallState.connecting);
    _sendGroupSignal(GroupSignalType.groupCallJoin);
    debugPrint('[GroupRtcEngine] group call joined: room=$_roomId');
  }

  /// 拒绝群通话邀请
  void rejectGroupCall() {
    _endReason = GroupCallEndReason.rejected;
    _sendGroupSignal(GroupSignalType.groupCallReject,
        payload: jsonEncode(const GroupReasonPayload('reject')));
    _endLocalCall();
  }

  /// 退出群通话（非发起人）
  void leaveGroupCall() {
    _endReason = GroupCallEndReason.normal;
    _sendGroupSignal(GroupSignalType.groupCallLeave,
        payload: jsonEncode(const GroupReasonPayload('hangup')));
    _endLocalCall();
  }

  /// 结束全员群通话（仅发起人，服务端校验）
  void endGroupCall() {
    if (!_isInitiator) {
      // 非发起人降级为退出
      leaveGroupCall();
      return;
    }
    _endReason = GroupCallEndReason.ended;
    _sendGroupSignal(GroupSignalType.groupCallEnd);
    _endLocalCall();
  }

  /// 切换摄像头开关（切换后经 cmd=51 mediaState 上报，服务端广播给其他成员）
  Future<void> toggleCamera() async {
    final next = !cameraEnabled;
    await _applyCameraEnabled(next);
    _sendMediaState(camera: next);
  }

  /// 切换麦克风开关
  Future<void> toggleMicrophone() async {
    final next = !microphoneEnabled;
    await _applyMicrophoneEnabled(next);
    _sendMediaState(mic: next);
  }

  /// 切换前后摄像头
  Future<void> switchCamera() async {
    await _transport?.switchCamera();
  }

  // ====================== 信令分发入口 ======================

  /// 处理群通话信令（cmd=51，由项目层从 IM 事件中转调）
  void handleGroupSignal(proto.RtcGroup signal) {
    debugPrint(
        '[GroupRtcEngine] group signal type=${signal.signalType} '
        'from=${signal.senderId} room=${signal.roomId}');
    switch (signal.signalType) {
      case GroupSignalType.groupCallInvite:
        _onInvite(signal);
        break;
      case GroupSignalType.roomState:
        _onRoomState(signal);
        break;
      case GroupSignalType.participantNotify:
        _onParticipantNotify(signal);
        break;
      case GroupSignalType.mediaState:
        // 兜底：mediaState 若以 cmd=51 直发（正常情况服务端聚合为 participantNotify）
        _onDirectMediaState(signal);
        break;
      default:
        debugPrint(
            '[GroupRtcEngine] ignore group signal: ${signal.signalType}');
        break;
    }
  }

  /// 处理点对点媒体信令（cmd=50，Mesh 模式专用）
  ///
  /// 项目层按 callId 路由：与群通话匹配的才转调此方法（见 [canHandleMediaCallId]），
  /// 避免 1:1 通话与群通话信令串线。
  void handleMediaSignal(proto.RtcSignal signal) {
    _transport?.handleMediaSignal(signal);
  }

  /// 当前群通话是否可处理该 callId 的点对点媒体信令
  bool canHandleMediaCallId(String callId) {
    return _state != GroupCallState.idle &&
        _state != GroupCallState.ended &&
        _callId.isNotEmpty &&
        _callId == callId;
  }

  // ====================== 信令事件处理 ======================

  /// 收到群通话邀请（被邀方）
  void _onInvite(proto.RtcGroup signal) {
    if (_state != GroupCallState.idle) {
      debugPrint('[GroupRtcEngine] busy, ignore invite from ${signal.senderId}');
      return;
    }
    if (signal.payload.isEmpty) {
      debugPrint('[GroupRtcEngine] invite payload is empty, ignore');
      return;
    }
    final invite =
        GroupCallInvite.fromJson(jsonDecode(signal.payload) as Map<String, dynamic>);

    _resetSession();
    _groupId = invite.groupId.isNotEmpty ? invite.groupId : signal.groupId;
    _callId = signal.callId;
    _roomId = signal.roomId;
    _callType = invite.isVideoCall ? RtcCallType.video : RtcCallType.audio;
    _mode = invite.mode;
    _isInitiator = false;
    // 发起人默认已在房
    if (invite.initiatorId.isNotEmpty) {
      _members[invite.initiatorId] = GroupMemberInfo(
        userId: invite.initiatorId,
        status: GroupMemberStatus.joined,
      );
    }

    _updateState(GroupCallState.ringing);
    callback.onIncomingGroupCall.call(invite, signal.roomId);
  }

  /// 收到房间快照（发起人与加入者都会收到）
  Future<void> _onRoomState(proto.RtcGroup signal) async {
    if (signal.payload.isEmpty) return;
    final roomState =
        GroupRoomState.fromJson(jsonDecode(signal.payload) as Map<String, dynamic>);

    _roomId = roomState.roomId.isNotEmpty ? roomState.roomId : signal.roomId;
    _callId = roomState.callId;
    _groupId = roomState.groupId;
    _mode = roomState.mode;
    _callType = roomState.isVideoCall ? RtcCallType.video : RtcCallType.audio;
    _isInitiator = roomState.initiatorId == localUserId();

    // 重建成员快照（保留已有媒体开关）
    _mergeMembers(roomState.members);

    _updateState(GroupCallState.connecting);
    callback.onRoomStateChanged.call(roomState);
    callback.onMembersUpdated.call();

    await _startTransport(roomState);
  }

  /// 收到成员变更通知
  void _onParticipantNotify(proto.RtcGroup signal) {
    if (signal.payload.isEmpty) return;
    final participant = GroupParticipant.fromJson(
        jsonDecode(signal.payload) as Map<String, dynamic>);

    switch (participant.action) {
      case GroupParticipantAction.join:
      case GroupParticipantAction.reject:
      case GroupParticipantAction.leave:
        _applyMemberChange(participant);
        break;
      case GroupParticipantAction.media:
        _applyMediaSnapshot(participant);
        break;
      case GroupParticipantAction.ended:
        // 服务端广播通话结束（含邀请超时 reason=timeout）
        _endReason = participant.reason == 'timeout'
            ? GroupCallEndReason.timeout
            : GroupCallEndReason.ended;
        _endLocalCall();
        break;
    }
  }

  /// 加入/拒绝/离开：更新成员状态并校准媒体连接
  void _applyMemberChange(GroupParticipant participant) {
    final userId = participant.userId;
    final existing = _members[userId];
    final status = switch (participant.action) {
      GroupParticipantAction.join => GroupMemberStatus.joined,
      GroupParticipantAction.reject => GroupMemberStatus.rejected,
      _ => GroupMemberStatus.left,
    };

    // 从成员快照中取该成员的最新媒体开关
    GroupMemberInfo? snapshot;
    for (final m in participant.members) {
      if (m.userId == userId) snapshot = m;
    }

    _members[userId] = GroupMemberInfo(
      userId: userId,
      status: status,
      camera: snapshot?.camera ?? existing?.camera,
      mic: snapshot?.mic ?? existing?.mic,
    );

    // 校准媒体连接（Mesh 关闭/新建对应 PeerConnection；SFU 由房间事件驱动）
    _transport?.syncRemoteMembers(joinedMemberIds);
    if (participant.action == GroupParticipantAction.leave) {
      callback.onRemoteMemberRemoved.call(userId);
    }
    if (snapshot != null &&
        (snapshot.camera != null || snapshot.mic != null)) {
      callback.onMemberMediaStateChanged.call(
          userId, snapshot.camera, snapshot.mic);
    }
    callback.onMembersUpdated.call();
    debugPrint(
        '[GroupRtcEngine] member ${participant.action.name}: $userId, '
        'joined=${joinedMemberIds.length}');
  }

  /// 媒体开关广播：用成员快照刷新本地缓存
  void _applyMediaSnapshot(GroupParticipant participant) {
    for (final m in participant.members) {
      final existing = _members[m.userId];
      _members[m.userId] = GroupMemberInfo(
        userId: m.userId,
        status: existing?.status ?? GroupMemberStatus.fromName(m.status.name),
        camera: m.camera ?? existing?.camera,
        mic: m.mic ?? existing?.mic,
      );
      if (m.camera != null || m.mic != null) {
        callback.onMemberMediaStateChanged.call(m.userId, m.camera, m.mic);
      }
    }
    callback.onMembersUpdated.call();
  }

  /// cmd=51 直发 mediaState 兜底处理
  void _onDirectMediaState(proto.RtcGroup signal) {
    if (signal.payload.isEmpty) return;
    try {
      final payload =
          jsonDecode(signal.payload) as Map<String, dynamic>;
      final camera = payload['camera'] as bool?;
      final mic = payload['mic'] as bool?;
      if (camera == null && mic == null) return;
      final userId = signal.senderId;
      final existing = _members[userId];
      if (existing != null) {
        _members[userId] = GroupMemberInfo(
          userId: userId,
          status: existing.status,
          camera: camera ?? existing.camera,
          mic: mic ?? existing.mic,
        );
      }
      callback.onMemberMediaStateChanged.call(userId, camera, mic);
      callback.onMembersUpdated.call();
    } catch (e) {
      debugPrint('[GroupRtcEngine] parse mediaState error: $e');
    }
  }

  // ====================== 媒体与传输层 ======================

  /// 依据 roomState.mode 创建并启动传输层（工厂/策略模式）
  Future<void> _startTransport(GroupRoomState roomState) async {
    await _transport?.dispose();

    final transportCallback = GroupMediaTransportCallback(
      onSendMediaSignal: (signal) {
        // Mesh 点对点媒体信令包装为 cmd=50 Packet
        callback.onSendMediaSignal
            .call(PacketCodec.create(Cmd.rtcSignal, body: signal));
      },
      onRemoteMemberMedia: callback.onRemoteMemberMedia.call,
      onRemoteMemberRemoved: callback.onRemoteMemberRemoved.call,
      onLocalVideoTrack: callback.onLocalVideoTrack.call,
      onMediaConnected: _onMediaConnected,
      onError: callback.onError.call,
    );

    if (roomState.mode == GroupCallMode.sfu) {
      _transport = SfuGroupTransport(
        localUserId: localUserId,
        callback: transportCallback,
      );
      debugPrint('[GroupRtcEngine] transport: SFU (${roomState.sfuUrl})');
    } else {
      // Mesh：先获取本地媒体流（传输层建连时加入轨道）
      await _acquireLocalMedia();
      _transport = MeshGroupTransport(
        localUserId: localUserId,
        callback: transportCallback,
        localStream: _localStream,
      );
      debugPrint('[GroupRtcEngine] transport: Mesh');
    }

    await _transport!.start(roomState);
  }

  /// 媒体连接就绪（首个对端连通 / SFU 房间连接成功）→ 启动计时
  void _onMediaConnected() {
    if (_state == GroupCallState.connected) return;
    _updateState(GroupCallState.connected);
    _startTimer();
    debugPrint('[GroupRtcEngine] media connected, timer started');
  }

  /// 获取本地媒体流（Mesh 专用）
  Future<void> _acquireLocalMedia() async {
    if (_localStream != null) return;
    final constraints = {
      'audio': true,
      'video': _callType == RtcCallType.video,
    };
    _localStream =
        await webrtc.navigator.mediaDevices.getUserMedia(constraints);
    _cameraEnabled =
        _trackEnabled(_localStream?.getVideoTracks(), fallback: true);
    _micEnabled =
        _trackEnabled(_localStream?.getAudioTracks(), fallback: true);
    callback.onLocalStreamReady.call(_localStream!);
    debugPrint('[GroupRtcEngine] local media acquired: '
        'audio=${_localStream!.getAudioTracks().length}, '
        'video=${_localStream!.getVideoTracks().length}');
  }

  /// 应用摄像头开关（Mesh 切轨道 / SFU 切发布）
  Future<void> _applyCameraEnabled(bool enabled) async {
    if (_mode == GroupCallMode.mesh) {
      final tracks = _localStream?.getVideoTracks();
      if (tracks != null) {
        for (final track in tracks) {
          track.enabled = enabled;
        }
      }
      _cameraEnabled = enabled;
    } else {
      await _transport?.setCameraEnabled(enabled);
    }
  }

  /// 应用麦克风开关
  Future<void> _applyMicrophoneEnabled(bool enabled) async {
    if (_mode == GroupCallMode.mesh) {
      final tracks = _localStream?.getAudioTracks();
      if (tracks != null) {
        for (final track in tracks) {
          track.enabled = enabled;
        }
      }
      _micEnabled = enabled;
    } else {
      await _transport?.setMicrophoneEnabled(enabled);
    }
  }

  // ====================== 信令发送 ======================

  /// 发送群通话生命周期信令（cmd=51）
  void _sendGroupSignal(int signalType, {String payload = ''}) {
    final packet = PacketCodec.buildRtcGroup(
      signalType: signalType,
      senderId: localUserId(),
      groupId: _groupId,
      payload: payload,
      callId: _callId,
      roomId: _roomId,
    );
    callback.onSendGroupSignal.call(packet);
  }

  /// 上报媒体开关状态（cmd=51 mediaState，payload 只带变化项）
  void _sendMediaState({bool? camera, bool? mic}) {
    if (camera == null && mic == null) return;
    final payload = GroupMediaStatePayload(camera: camera, mic: mic);
    if (payload.toJson().isEmpty) return;
    _sendGroupSignal(GroupSignalType.mediaState,
        payload: jsonEncode(payload.toJson()));
    debugPrint('[GroupRtcEngine] media state sent: camera=$camera, mic=$mic');
  }

  // ====================== 会话生命周期 ======================

  /// 本地结束通话（发出 leave/end 或收到 ended 后调用）
  ///
  /// 注意回调顺序：先通知 onCallEnded（项目层保存记录），再置状态为 ended。
  void _endLocalCall() {
    _callTimer?.cancel();

    if (_endReason == GroupCallEndReason.none) {
      _endReason = GroupCallEndReason.failed;
    }

    callback.onCallEnded.call(_endReason);
    _updateState(GroupCallState.ended);
    _cleanup();

    // 延迟恢复空闲，避免 ended 状态闪过
    Future.delayed(const Duration(seconds: 1), () {
      if (_state == GroupCallState.ended) {
        _updateState(GroupCallState.idle);
      }
    });
  }

  /// 清理会话资源
  Future<void> _cleanup() async {
    try {
      await _transport?.dispose();
      _transport = null;
      await _localStream?.dispose();
      _localStream = null;
      _members.clear();
      _roomId = '';
      _callId = '';
    } catch (e) {
      debugPrint('[GroupRtcEngine] cleanup error: $e');
    }
  }

  /// 重置会话字段（不清理媒体，媒体在 cleanup 中处理）
  void _resetSession() {
    _endReason = GroupCallEndReason.none;
    _callId = '';
    _roomId = '';
    _groupId = '';
    _isInitiator = false;
    _mode = GroupCallMode.mesh;
    _members.clear();
    _cameraEnabled = true;
    _micEnabled = true;
    _callDuration = 0;
  }

  /// 启动通话计时
  void _startTimer() {
    _callDuration = 0;
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _callDuration += 1;
      callback.onCallDurationTick.call(_callDuration);
    });
  }

  /// 合并成员快照（保留已有媒体开关）
  void _mergeMembers(List<GroupMemberInfo> incoming) {
    for (final m in incoming) {
      final existing = _members[m.userId];
      _members[m.userId] = GroupMemberInfo(
        userId: m.userId,
        status: m.status,
        camera: m.camera ?? existing?.camera,
        mic: m.mic ?? existing?.mic,
      );
    }
  }

  /// 更新状态并通知
  void _updateState(GroupCallState newState) {
    _state = newState;
    callback.onCallStateChanged.call(newState);
  }

  /// 查询轨道开关（无轨道时返回 fallback）
  bool _trackEnabled(List<webrtc.MediaStreamTrack>? tracks,
      {bool fallback = false}) {
    if (tracks == null || tracks.isEmpty) return fallback;
    return tracks.first.enabled;
  }
}
