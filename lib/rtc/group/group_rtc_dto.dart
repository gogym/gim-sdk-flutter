import 'group_rtc_types.dart';

/// 群通话信令 payload DTO
///
/// 与服务端 gim-im-webrtc 的 dto 包字段一一对应（JSON 序列化），
/// 客户端负责解析 roomState/participantNotify/invite 等 payload，
/// 并构建 groupCallRequest/mediaState 等 payload。

// ====================== TURN/STUN 凭据（对应 TurnCredentialsDto） ======================

/// TURN/STUN 临时凭据（RESTTURN 协议，HMAC-SHA1）
///
/// Mesh 模式下随 roomState(27) 下发，用于构建 ICE Server。
class TurnCredentials {
  final String stunUrl;
  final String turnUrl;
  final String username;
  final String credential;

  const TurnCredentials({
    required this.stunUrl,
    required this.turnUrl,
    required this.username,
    required this.credential,
  });

  factory TurnCredentials.fromJson(Map<String, dynamic> json) {
    return TurnCredentials(
      stunUrl: json['stunUrl'] as String? ?? '',
      turnUrl: json['turnUrl'] as String? ?? '',
      username: json['username'] as String? ?? '',
      credential: json['credential'] as String? ?? '',
    );
  }

  /// 转为 flutter_webrtc iceServers 配置
  List<Map<String, dynamic>> toIceServers() {
    final servers = <Map<String, dynamic>>[];
    if (stunUrl.isNotEmpty) {
      servers.add({'urls': stunUrl});
    }
    if (turnUrl.isNotEmpty) {
      servers.add({
        'urls': turnUrl,
        'username': username,
        'credential': credential,
      });
    }
    return servers;
  }
}

// ====================== 成员快照（对应 GroupMemberInfoDto） ======================

/// 群通话成员快照信息
class GroupMemberInfo {
  final String userId;

  /// 成员状态：invited / joined / left / rejected
  final GroupMemberStatus status;

  /// 摄像头开关（null 表示未上报，沿用上次状态）
  final bool? camera;

  /// 麦克风开关（null 表示未上报，沿用上次状态）
  final bool? mic;

  const GroupMemberInfo({
    required this.userId,
    required this.status,
    this.camera,
    this.mic,
  });

  factory GroupMemberInfo.fromJson(Map<String, dynamic> json) {
    return GroupMemberInfo(
      userId: json['userId'] as String? ?? '',
      status: GroupMemberStatus.fromName(json['status'] as String?),
      camera: json['camera'] as bool?,
      mic: json['mic'] as bool?,
    );
  }
}

// ====================== 房间状态快照（对应 GroupRoomStateDto） ======================

/// 房间状态快照（signalType=27 roomState，服务端 → 发起人/加入者）
///
/// 加入者据此初始化房间视图：Mesh 模式对已 joined 成员逐一建连，
/// SFU 模式用 sfuToken/sfuUrl 连接 LiveKit。
class GroupRoomState {
  final String roomId;
  final String callId;
  final String groupId;

  /// 媒体模式：mesh / sfu
  final GroupCallMode mode;

  /// 通话类型：audio / video
  final String callType;

  /// 发起人 userId
  final String initiatorId;

  /// 房间状态：ringing / talking
  final String status;

  /// 成员快照（含状态与媒体开关）
  final List<GroupMemberInfo> members;

  /// SFU 接入 token（仅 SFU 模式）
  final String sfuToken;

  /// SFU 连接地址（仅 SFU 模式）
  final String sfuUrl;

  /// TURN/STUN 凭据（仅 Mesh 模式）
  final TurnCredentials? turnInfo;

  const GroupRoomState({
    required this.roomId,
    required this.callId,
    required this.groupId,
    required this.mode,
    required this.callType,
    required this.initiatorId,
    required this.status,
    required this.members,
    this.sfuToken = '',
    this.sfuUrl = '',
    this.turnInfo,
  });

  factory GroupRoomState.fromJson(Map<String, dynamic> json) {
    return GroupRoomState(
      roomId: json['roomId'] as String? ?? '',
      callId: json['callId'] as String? ?? '',
      groupId: json['groupId'] as String? ?? '',
      mode: GroupCallMode.from(
        stringValue: json['mode'] as String?,
      ),
      callType: json['callType'] as String? ?? 'video',
      initiatorId: json['initiatorId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      members: (json['members'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(GroupMemberInfo.fromJson)
          .toList(),
      sfuToken: json['sfuToken'] as String? ?? '',
      sfuUrl: json['sfuUrl'] as String? ?? '',
      turnInfo: json['turnInfo'] is Map<String, dynamic>
          ? TurnCredentials.fromJson(json['turnInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isVideoCall => callType == 'video';
}

// ====================== 通话邀请（对应 GroupCallInviteDto） ======================

/// 群通话邀请（signalType=21 groupCallInvite，服务端 → 被邀成员）
class GroupCallInvite {
  final String callType;
  final String groupId;
  final String initiatorId;

  /// 媒体模式：mesh / sfu
  final GroupCallMode mode;

  const GroupCallInvite({
    required this.callType,
    required this.groupId,
    required this.initiatorId,
    required this.mode,
  });

  factory GroupCallInvite.fromJson(Map<String, dynamic> json) {
    return GroupCallInvite(
      callType: json['callType'] as String? ?? 'video',
      groupId: json['groupId'] as String? ?? '',
      initiatorId: json['initiatorId'] as String? ?? '',
      mode: GroupCallMode.from(stringValue: json['mode'] as String?),
    );
  }

  bool get isVideoCall => callType == 'video';
}

// ====================== 成员变更通知（对应 GroupCallParticipantDto） ======================

/// 成员变更通知（signalType=26 participantNotify，服务端 → 成员）
class GroupParticipant {
  /// 变更动作：join / leave / reject / ended / media
  final GroupParticipantAction action;

  /// 触发变更的成员 userId
  final String userId;

  /// 变更原因（leave/reject 时可携带，如 timeout、busy）
  final String reason;

  /// 当前仍在通话中的成员数
  final int memberCount;

  /// 仍在通话中的成员快照（携带最新媒体开关）
  final List<GroupMemberInfo> members;

  const GroupParticipant({
    required this.action,
    required this.userId,
    this.reason = '',
    this.memberCount = 0,
    this.members = const [],
  });

  factory GroupParticipant.fromJson(Map<String, dynamic> json) {
    return GroupParticipant(
      action: GroupParticipantAction.fromName(json['action'] as String?) ??
          GroupParticipantAction.media,
      userId: json['userId'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      memberCount: json['memberCount'] as int? ?? 0,
      members: (json['members'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(GroupMemberInfo.fromJson)
          .toList(),
    );
  }
}

// ====================== 客户端上行 payload ======================

/// 发起群通话请求 payload（对应 GroupCallRequestDto）
class GroupCallRequestPayload {
  /// 通话类型：audio / video
  final String callType;

  /// 受邀成员列表（可选，为空时服务端邀请群内全部活跃成员）
  final List<String>? inviteeIds;

  const GroupCallRequestPayload({
    required this.callType,
    this.inviteeIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'callType': callType};
    if (inviteeIds != null && inviteeIds!.isNotEmpty) {
      json['inviteeIds'] = inviteeIds;
    }
    return json;
  }
}

/// 媒体开关状态 payload（对应 GroupMediaStateDto，camera/mic 至少一项非 null）
class GroupMediaStatePayload {
  final bool? camera;
  final bool? mic;

  const GroupMediaStatePayload({this.camera, this.mic});

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (camera != null) json['camera'] = camera;
    if (mic != null) json['mic'] = mic;
    return json;
  }
}

/// 拒绝/退出原因 payload（对应 SingleCallRejectDto，仅携带 reason）
class GroupReasonPayload {
  final String reason;

  const GroupReasonPayload(this.reason);

  Map<String, dynamic> toJson() => {'reason': reason};
}
