import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import 'ImProto.pb.dart' as proto;
import 'cmd.dart';


/// Packet 编解码工具类（客户端）
/// 所有 protobuf 消息的创建和解析统一通过此类
class PacketCodec {
  PacketCodec._();

  /// 自增序列号（客户端发出的请求）
  static Int64 _sequence = Int64.ZERO;

  /// 获取下一个序列号
  static Int64 nextSequence() {
    _sequence = _sequence + Int64.ONE;
    return _sequence;
  }

  /// 重置序列号
  static void resetSequence() {
    _sequence = Int64.ZERO;
  }

  // ====================== Packet 创建 ======================

  /// 创建 Packet（带 body）
  ///
  /// [chatType] 聊天类型值（由服务端配置），仅当 body 为 ChatMessage 时生效
  static proto.Packet create(int cmd,
      {Int64? sequence, String? requestId, GeneratedMessage? body, int? chatType}) {
    final packet = proto.Packet()
      ..cmd = cmd
      ..sequence = sequence ?? nextSequence()
      ..timestamp = Int64(DateTime.now().millisecondsSinceEpoch);

    if (requestId != null) {
      packet.requestId = requestId;
    }
    if (body != null) {
      if (chatType != null && body is proto.ChatMessage) {
        body.chatType = chatType;
      }
      packet.body = body.writeToBuffer();
    }
    return packet;
  }

  /// 创建无 body 的 Packet（如心跳）
  static proto.Packet createEmpty(int cmd) {
    return proto.Packet()
      ..cmd = cmd
      ..sequence = nextSequence()
      ..timestamp = Int64(DateTime.now().millisecondsSinceEpoch);
  }

  // ====================== 业务消息构建 ======================

  /// 构建绑定请求 Packet
  ///
  /// [deviceId] 设备唯一标识（客户端持久化UUID），用于区分同设备重连与异设备顶号
  static proto.Packet buildBindReq(String userId, String token, String device,
      {String? deviceId}) {
    final body = proto.BindRequest()
      ..userId = userId
      ..token = token
      ..device = device;
    if (deviceId != null && deviceId.isNotEmpty) {
      body.deviceId = deviceId;
    }
    return create(Cmd.bindReq, sequence: Int64.ZERO, body: body);
  }

  /// 构建心跳请求 Packet
  static proto.Packet buildHeartbeatReq() {
    final body = proto.Heartbeat()
      ..clientTime = Int64(DateTime.now().millisecondsSinceEpoch);
    return create(Cmd.heartbeatReq, body: body);
  }

  /// 构建单聊消息 Packet
  static proto.Packet buildSingleChatMsg({
    required String requestId,
    required String senderId,
    required String receiverId,
    required int contentType,
    required String content,
    String? conversationId,
    Map<String, String>? ext,
  }) {
    final body = proto.ChatMessage()
      ..senderId = senderId
      ..receiverId = receiverId
      ..contentType = contentType
      ..content = content;

    if (conversationId != null) {
      body.conversationId = conversationId;
    }
    if (ext != null && ext.isNotEmpty) {
      body.ext.addAll(ext);
    }
    return create(Cmd.singleChatMsg, requestId: requestId, body: body, chatType: 1);
  }

  /// 构建群聊消息 Packet
  static proto.Packet buildGroupChatMsg({
    required String requestId,
    required String senderId,
    required String receiverId,
    required int contentType,
    required String content,
    String? conversationId,
    Map<String, String>? ext,
  }) {
    final body = proto.ChatMessage()
      ..senderId = senderId
      ..receiverId = receiverId
      ..contentType = contentType
      ..content = content;

    if (conversationId != null) {
      body.conversationId = conversationId;
    }
    if (ext != null && ext.isNotEmpty) {
      body.ext.addAll(ext);
    }
    return create(Cmd.groupChatMsg, requestId: requestId, body: body,chatType: 2);
  }

  /// 构建送达 ACK Packet
  static proto.Packet buildDeliveryAck(String msgId, String fromUserId) {
    final body = proto.DeliveryAck()
      ..msgId = msgId
      ..fromUserId = fromUserId;
    return create(Cmd.deliveryAck, sequence: Int64.ZERO, body: body);
  }

  /// 构建已读回执 Packet
  static proto.Packet buildReadReceipt(String conversationId, String lastReadMsgId) {
    final body = proto.ReadReceipt()
      ..conversationId = conversationId
      ..lastReadMsgId = lastReadMsgId;
    return create(Cmd.readReceipt, sequence: Int64.ZERO, body: body);
  }

  /// 构建消息撤回请求 Packet
  static proto.Packet buildMsgRecallReq(String msgId, String conversationId, int chatType, {String? requestId}) {
    final body = proto.MsgRecallRequest()
      ..msgId = msgId
      ..conversationId = conversationId
      ..chatType = chatType;
    return create(Cmd.msgRecallReq, sequence: Int64.ZERO, requestId: requestId, body: body);
  }

  // ====================== Body 解析 ======================

  /// 解析 Packet body 为 BindResponse
  static proto.BindResponse parseBindResponse(proto.Packet packet) {
    return proto.BindResponse.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 HeartbeatResponse
  static proto.HeartbeatResponse parseHeartbeatResponse(proto.Packet packet) {
    return proto.HeartbeatResponse.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 ChatMessage
  static proto.ChatMessage parseChatMessage(proto.Packet packet) {
    return proto.ChatMessage.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 ServerAck
  static proto.ServerAck parseServerAck(proto.Packet packet) {
    return proto.ServerAck.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 DeliveryAck
  static proto.DeliveryAck parseDeliveryAck(proto.Packet packet) {
    return proto.DeliveryAck.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 ReadReceipt
  static proto.ReadReceipt parseReadReceipt(proto.Packet packet) {
    return proto.ReadReceipt.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 MsgRecallNotify
  static proto.MsgRecallNotify parseMsgRecallNotify(proto.Packet packet) {
    return proto.MsgRecallNotify.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 OnlineStatusNotify
  static proto.OnlineStatusNotify parseOnlineStatusNotify(proto.Packet packet) {
    return proto.OnlineStatusNotify.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 FriendRequestNotify
  static proto.FriendRequestNotify parseFriendRequestNotify(proto.Packet packet) {
    return proto.FriendRequestNotify.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 FriendStatusNotify
  static proto.FriendStatusNotify parseFriendStatusNotify(proto.Packet packet) {
    return proto.FriendStatusNotify.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 GroupMemberNotify
  static proto.GroupMemberNotify parseGroupMemberNotify(proto.Packet packet) {
    return proto.GroupMemberNotify.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 GroupNotify
  static proto.GroupNotify parseGroupNotify(proto.Packet packet) {
    return proto.GroupNotify.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 GroupJoinRequestNotify
  static proto.GroupJoinRequestNotify parseGroupJoinRequestNotify(proto.Packet packet) {
    return proto.GroupJoinRequestNotify.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 RtcSignal
  static proto.RtcSignal parseRtcSignal(proto.Packet packet) {
    return proto.RtcSignal.fromBuffer(packet.body);
  }

  /// 解析 Packet body 为 KickNotify
  static proto.KickNotify parseKickNotify(proto.Packet packet) {
    return proto.KickNotify.fromBuffer(packet.body);
  }

  // ====================== 通用解析 ======================

  /// 根据 cmd 类型解析 body（动态分发）
  static GeneratedMessage? parseBody(proto.Packet packet) {
    if (packet.body.isEmpty) return null;

    return switch (packet.cmd) {
      Cmd.bindReq => proto.BindRequest.fromBuffer(packet.body),
      Cmd.bindResp => proto.BindResponse.fromBuffer(packet.body),
      Cmd.heartbeatReq => proto.Heartbeat.fromBuffer(packet.body),
      Cmd.heartbeatResp => proto.HeartbeatResponse.fromBuffer(packet.body),
      Cmd.singleChatMsg => proto.ChatMessage.fromBuffer(packet.body),
      Cmd.groupChatMsg => proto.ChatMessage.fromBuffer(packet.body),
      Cmd.serverAck => proto.ServerAck.fromBuffer(packet.body),
      Cmd.deliveryAck => proto.DeliveryAck.fromBuffer(packet.body),
      Cmd.readReceipt => proto.ReadReceipt.fromBuffer(packet.body),
      Cmd.msgRecallNotify => proto.MsgRecallNotify.fromBuffer(packet.body),
      Cmd.onlineStatusNotify =>
          proto.OnlineStatusNotify.fromBuffer(packet.body),
      Cmd.friendRequestNotify =>
          proto.FriendRequestNotify.fromBuffer(packet.body),
      Cmd.friendStatusNotify =>
          proto.FriendStatusNotify.fromBuffer(packet.body),
      Cmd.groupMemberNotify =>
          proto.GroupMemberNotify.fromBuffer(packet.body),
      Cmd.groupNotify => proto.GroupNotify.fromBuffer(packet.body),
      Cmd.groupJoinRequestNotify =>
          proto.GroupJoinRequestNotify.fromBuffer(packet.body),
      Cmd.rtcSignal => proto.RtcSignal.fromBuffer(packet.body),
      Cmd.kickNotify => proto.KickNotify.fromBuffer(packet.body),
      _ => null,
    };
  }

  // ====================== 序列化 ======================

  /// 将 Packet 序列化为字节数组（用于网络传输）
  static Uint8List encode(proto.Packet packet) {
    return Uint8List.fromList(packet.writeToBuffer());
  }

  /// 从字节数组反序列化为 Packet
  static proto.Packet decode(Uint8List data) {
    return proto.Packet.fromBuffer(data);
  }
}
