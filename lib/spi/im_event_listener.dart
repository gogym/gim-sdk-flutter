import '../core/connection_state.dart';
import '../protocol/ImProto.pb.dart' as proto;

/// IM 事件监听器（对标服务端 ImEventListener）
///
/// 使用方继承此类来接收 IM 各类事件通知
/// 所有方法提供默认空实现，使用方可按需覆盖
///
/// 注意：使用普通 class 而非 abstract class，
/// 使用方只需覆盖关心的方法，无需实现全部方法
class ImEventListener {
  /// 收到新消息（单聊/群聊）
  void onMessageReceived(proto.Packet packet) {}

  /// 消息发送成功（收到 ServerAck 且 code=0）
  void onMessageSent(proto.Packet packet) {}

  /// 消息送达（对方已收到，DeliveryAck）
  void onMessageDelivered(proto.Packet packet) {}

  /// 消息已读（ReadReceipt）
  void onMessageRead(proto.Packet packet) {}

  /// 消息被撤回
  void onMessageRecalled(proto.Packet packet) {}

  /// 用户上线
  void onUserOnline(proto.Packet packet) {}

  /// 用户下线
  void onUserOffline(proto.Packet packet) {}

  /// 好友申请通知
  void onFriendRequest(proto.Packet packet) {}

  /// 好友状态变更
  void onFriendStatusChanged(proto.Packet packet) {}

  /// 群成员变更
  void onGroupMemberChanged(proto.Packet packet) {}

  /// 群信息/事件通知
  void onGroupNotify(proto.Packet packet) {}

  /// 入群申请
  void onGroupJoinRequest(proto.Packet packet) {}

  /// WebRTC 信令
  void onRtcSignal(proto.Packet packet) {}

  /// WebRTC 群通话信令（cmd=51 RTC_GROUP，生命周期 + 媒体开关）
  void onRtcGroup(proto.Packet packet) {}

  /// 被踢下线
  void onKicked(int code, String message) {}

  /// 连接状态变更
  void onConnectionStateChanged(ImConnectionState state) {}

  /// 绑定失败
  void onBindFailed(int code, String message) {}
}
