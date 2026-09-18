/// 群通话相关类型定义
///
/// 与服务端 gim-im-webrtc 的 GroupSignalType / GroupCallMode /
/// GroupCallMemberStatus / GroupCallParticipantDto 保持一致。
/// 禁止使用魔法值，客户端一律引用此处的常量与枚举。

/// 群通话生命周期信令类型（signalType 字段值，cmd=51 RTC_GROUP）
///
/// 与 ImProto.proto 中 RtcGroup 注释保持一致：
/// 1~8 为媒体信令（offer/answer/ICE 等，Mesh 模式成员间复用，走 cmd=50 点对点）；
/// 20~27 为群通话生命周期信令；100=mediaState 媒体开关（跨场景共用）。
library;

class GroupSignalType {
  GroupSignalType._();

  static const int groupCallRequest = 20;   // 发起群通话（客户端 → 服务端）
  static const int groupCallInvite = 21;    // 群通话邀请（服务端下发）
  static const int groupCallJoin = 22;      // 加入群通话（客户端 → 服务端）
  static const int groupCallReject = 23;    // 拒绝邀请（客户端 → 服务端）
  static const int groupCallLeave = 24;     // 退出群通话（客户端 → 服务端）
  static const int groupCallEnd = 25;       // 结束全员通话（仅发起人）
  static const int participantNotify = 26;  // 成员变更通知（服务端下发）
  static const int roomState = 27;          // 房间状态快照（服务端下发）

  /// 媒体开关状态（与 1:1 RtcSignalType.mediaState 共用同一编号）
  ///
  /// payload 只携带发生变化的项：`{"camera": bool}` / `{"mic": bool}`。
  static const int mediaState = 100;
}

/// 群通话媒体架构模式（对应服务端 GroupCallMode，RtcGroup.mode 字段）
enum GroupCallMode {
  /// Mesh：成员间 P2P 直连，服务端只做信令扇出（小群，默认 ≤8 人）
  mesh,

  /// SFU：媒体流由外部 SFU（如 LiveKit）承载（大群，20+ 人）
  sfu;

  /// 按 RtcGroup.mode / payload mode 字符串解析
  ///
  /// [intValue] 为 RtcGroup.mode 字段（0-Mesh 1-SFU）；
  /// [stringValue] 为 payload 中的 mode 字符串（mesh / sfu），优先级低于 [intValue]。
  static GroupCallMode from({int? intValue, String? stringValue}) {
    if (intValue != null && intValue != 0) return GroupCallMode.sfu;
    if (intValue != null) return GroupCallMode.mesh;
    if (stringValue == 'sfu') return GroupCallMode.sfu;
    return GroupCallMode.mesh;
  }

  String get value => this == GroupCallMode.sfu ? 'sfu' : 'mesh';
}

/// 群通话成员状态（对应服务端 GroupCallMemberStatus）
enum GroupMemberStatus {
  invited,  // 已邀请未响应
  joined,   // 已加入通话
  left,     // 已退出
  rejected; // 已拒绝

  /// 按服务端下发的状态字符串解析（小写），未知值回退 invited
  static GroupMemberStatus fromName(String? name) {
    switch (name) {
      case 'joined':
        return GroupMemberStatus.joined;
      case 'left':
        return GroupMemberStatus.left;
      case 'rejected':
        return GroupMemberStatus.rejected;
      default:
        return GroupMemberStatus.invited;
    }
  }

  String get name => switch (this) {
        GroupMemberStatus.invited => 'invited',
        GroupMemberStatus.joined => 'joined',
        GroupMemberStatus.left => 'left',
        GroupMemberStatus.rejected => 'rejected',
      };
}

/// 成员变更通知动作（participantNotify payload action 字段）
enum GroupParticipantAction {
  join,   // 成员加入
  leave,  // 成员退出
  reject, // 成员拒绝
  ended,  // 通话结束
  media;  // 媒体开关变更

  /// 按 payload action 字符串解析，未知值返回 null（由调用方忽略）
  static GroupParticipantAction? fromName(String? name) {
    switch (name) {
      case 'join':
        return GroupParticipantAction.join;
      case 'leave':
        return GroupParticipantAction.leave;
      case 'reject':
        return GroupParticipantAction.reject;
      case 'ended':
        return GroupParticipantAction.ended;
      case 'media':
        return GroupParticipantAction.media;
      default:
        return null;
    }
  }
}

/// 群通话结束原因
enum GroupCallEndReason {
  none,     // 无（通话未结束）
  normal,   // 正常结束（发起人结束/主动离开）
  rejected, // 被拒绝
  timeout,  // 邀请超时
  ended,    // 发起人结束全员通话
  failed;   // 连接失败
}

/// 群通话状态（引擎内部状态机，与 1:1 RtcCallState 对应）
enum GroupCallState {
  idle,       // 空闲
  calling,    // 正在呼叫（发起方，等待成员加入）
  ringing,    // 来电响铃（被邀方）
  connecting, // 已接受/收到房间快照，媒体建连中
  connected,  // 通话中
  ended;      // 已结束
}
