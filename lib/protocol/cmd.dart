/// 命令类型常量定义
/// 与 Java 服务端 Cmd.java 保持一致
///
/// 命令编号分配规则：
/// - 1~9:    连接管理（绑定、心跳等）
/// - 10~19:  聊天消息（发送、ACK、已读等）
/// - 20~29:  在线状态
/// - 30~39:  好友通知
/// - 40~49:  群组通知
/// - 50~59:  WebRTC 信令
class Cmd {
  Cmd._();

  // ==================== 连接管理 (1-9) ====================

  /// 绑定请求（首包认证）
  static const int bindReq = 1;

  /// 绑定响应
  static const int bindResp = 2;

  /// 心跳请求
  static const int heartbeatReq = 3;

  /// 心跳响应
  static const int heartbeatResp = 4;

  /// 踢人通知（服务端 → 客户端，被踢时发送）
  static const int kickNotify = 5;

  // ==================== 聊天消息 (10-19) ====================

  /// 单聊消息（客户端 → 服务端）
  static const int singleChatMsg = 10;

  /// 群聊消息（客户端 → 服务端）
  static const int groupChatMsg = 11;

  /// 服务端 ACK（服务器确认收到）
  static const int serverAck = 12;

  /// 送达 ACK（接收方确认收到）
  static const int deliveryAck = 13;

  /// 已读回执
  static const int readReceipt = 14;

  /// 消息撤回请求
  static const int msgRecallReq = 15;

  /// 消息撤回通知
  static const int msgRecallNotify = 16;

  // ==================== 在线状态 (20-29) ====================

  /// 在线状态变更通知
  static const int onlineStatusNotify = 20;

  // ==================== 好友通知 (30-39) ====================

  /// 好友申请通知
  static const int friendRequestNotify = 30;

  /// 好友状态变更通知
  static const int friendStatusNotify = 31;

  // ==================== 群组通知 (40-49) ====================

  /// 群成员变更通知
  static const int groupMemberNotify = 40;

  /// 群信息/事件通知
  static const int groupNotify = 41;

  /// 入群申请通知
  static const int groupJoinRequestNotify = 42;

  // ==================== WebRTC 信令 (50-59) ====================

  /// WebRTC 信令消息
  static const int rtcSignal = 50;

  /// WebRTC 群通话信令消息（群通话生命周期 + 媒体开关）
  static const int rtcGroup = 51;

  /// 根据 cmd 返回可读名称（调试用）
  static String nameOf(int cmd) {
    return switch (cmd) {
      bindReq => 'BIND_REQ',
      bindResp => 'BIND_RESP',
      heartbeatReq => 'HEARTBEAT_REQ',
      heartbeatResp => 'HEARTBEAT_RESP',
      kickNotify => 'KICK_NOTIFY',
      singleChatMsg => 'SINGLE_CHAT_MSG',
      groupChatMsg => 'GROUP_CHAT_MSG',
      serverAck => 'SERVER_ACK',
      deliveryAck => 'DELIVERY_ACK',
      readReceipt => 'READ_RECEIPT',
      msgRecallReq => 'MSG_RECALL_REQ',
      msgRecallNotify => 'MSG_RECALL_NOTIFY',
      onlineStatusNotify => 'ONLINE_STATUS_NOTIFY',
      friendRequestNotify => 'FRIEND_REQUEST_NOTIFY',
      friendStatusNotify => 'FRIEND_STATUS_NOTIFY',
      groupMemberNotify => 'GROUP_MEMBER_NOTIFY',
      groupNotify => 'GROUP_NOTIFY',
      groupJoinRequestNotify => 'GROUP_JOIN_REQUEST_NOTIFY',
      rtcSignal => 'RTC_SIGNAL',
      rtcGroup => 'RTC_GROUP',
      _ => 'UNKNOWN($cmd)',
    };
  }
}
