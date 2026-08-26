// This is a generated file - do not edit.
//
// Generated from ImProto.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// ===================== 统一信封 =====================
/// 所有消息的外层包装，路由和协议层只关心 Packet
class Packet extends $pb.GeneratedMessage {
  factory Packet({
    $core.int? cmd,
    $fixnum.Int64? sequence,
    $core.String? requestId,
    $fixnum.Int64? timestamp,
    $core.List<$core.int>? body,
  }) {
    final result = create();
    if (cmd != null) result.cmd = cmd;
    if (sequence != null) result.sequence = sequence;
    if (requestId != null) result.requestId = requestId;
    if (timestamp != null) result.timestamp = timestamp;
    if (body != null) result.body = body;
    return result;
  }

  Packet._();

  factory Packet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Packet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Packet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'cmd')
    ..aInt64(2, _omitFieldNames ? '' : 'sequence')
    ..aOS(3, _omitFieldNames ? '' : 'requestId', protoName: 'requestId')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'body', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Packet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Packet copyWith(void Function(Packet) updates) =>
      super.copyWith((message) => updates(message as Packet)) as Packet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Packet create() => Packet._();
  @$core.override
  Packet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Packet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Packet>(create);
  static Packet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get cmd => $_getIZ(0);
  @$pb.TagNumber(1)
  set cmd($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCmd() => $_has(0);
  @$pb.TagNumber(1)
  void clearCmd() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sequence => $_getI64(1);
  @$pb.TagNumber(2)
  set sequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearSequence() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get body => $_getN(4);
  @$pb.TagNumber(5)
  set body($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBody() => $_has(4);
  @$pb.TagNumber(5)
  void clearBody() => $_clearField(5);
}

/// cmd = 1: 绑定请求（首包认证）
class BindRequest extends $pb.GeneratedMessage {
  factory BindRequest({
    $core.String? userId,
    $core.String? token,
    $core.String? device,
    $core.String? deviceId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (token != null) result.token = token;
    if (device != null) result.device = device;
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  BindRequest._();

  factory BindRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BindRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BindRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOS(3, _omitFieldNames ? '' : 'device')
    ..aOS(4, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindRequest copyWith(void Function(BindRequest) updates) =>
      super.copyWith((message) => updates(message as BindRequest))
          as BindRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BindRequest create() => BindRequest._();
  @$core.override
  BindRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BindRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BindRequest>(create);
  static BindRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get device => $_getSZ(2);
  @$pb.TagNumber(3)
  set device($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDevice() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deviceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set deviceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeviceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceId() => $_clearField(4);
}

/// cmd = 2: 绑定响应
class BindResponse extends $pb.GeneratedMessage {
  factory BindResponse({
    $core.int? code,
    $core.String? message,
    $core.String? serverId,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (serverId != null) result.serverId = serverId;
    return result;
  }

  BindResponse._();

  factory BindResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BindResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BindResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'serverId', protoName: 'serverId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindResponse copyWith(void Function(BindResponse) updates) =>
      super.copyWith((message) => updates(message as BindResponse))
          as BindResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BindResponse create() => BindResponse._();
  @$core.override
  BindResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BindResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BindResponse>(create);
  static BindResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get serverId => $_getSZ(2);
  @$pb.TagNumber(3)
  set serverId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerId() => $_clearField(3);
}

/// cmd = 3: 心跳请求
class Heartbeat extends $pb.GeneratedMessage {
  factory Heartbeat({
    $fixnum.Int64? clientTime,
  }) {
    final result = create();
    if (clientTime != null) result.clientTime = clientTime;
    return result;
  }

  Heartbeat._();

  factory Heartbeat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Heartbeat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Heartbeat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'clientTime', protoName: 'clientTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Heartbeat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Heartbeat copyWith(void Function(Heartbeat) updates) =>
      super.copyWith((message) => updates(message as Heartbeat)) as Heartbeat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Heartbeat create() => Heartbeat._();
  @$core.override
  Heartbeat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Heartbeat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Heartbeat>(create);
  static Heartbeat? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clientTime => $_getI64(0);
  @$pb.TagNumber(1)
  set clientTime($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientTime() => $_clearField(1);
}

/// cmd = 4: 心跳响应
class HeartbeatResponse extends $pb.GeneratedMessage {
  factory HeartbeatResponse({
    $fixnum.Int64? serverTime,
  }) {
    final result = create();
    if (serverTime != null) result.serverTime = serverTime;
    return result;
  }

  HeartbeatResponse._();

  factory HeartbeatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeartbeatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeartbeatResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'serverTime', protoName: 'serverTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatResponse copyWith(void Function(HeartbeatResponse) updates) =>
      super.copyWith((message) => updates(message as HeartbeatResponse))
          as HeartbeatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartbeatResponse create() => HeartbeatResponse._();
  @$core.override
  HeartbeatResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeartbeatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeartbeatResponse>(create);
  static HeartbeatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get serverTime => $_getI64(0);
  @$pb.TagNumber(1)
  set serverTime($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerTime() => $_clearField(1);
}

/// cmd = 5: 踢人通知（服务端 → 客户端，被踢下线时发送）
class KickNotify extends $pb.GeneratedMessage {
  factory KickNotify({
    $core.int? code,
    $core.String? message,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    return result;
  }

  KickNotify._();

  factory KickNotify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickNotify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickNotify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickNotify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickNotify copyWith(void Function(KickNotify) updates) =>
      super.copyWith((message) => updates(message as KickNotify)) as KickNotify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickNotify create() => KickNotify._();
  @$core.override
  KickNotify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickNotify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickNotify>(create);
  static KickNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

/// cmd = 10: 单聊消息（客户端 → 服务端）
/// cmd = 11: 群聊消息（客户端 → 服务端）
class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.String? msgId,
    $core.int? chatType,
    $core.String? senderId,
    $core.String? receiverId,
    $core.int? contentType,
    $core.String? content,
    $core.String? conversationId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? ext,
  }) {
    final result = create();
    if (msgId != null) result.msgId = msgId;
    if (chatType != null) result.chatType = chatType;
    if (senderId != null) result.senderId = senderId;
    if (receiverId != null) result.receiverId = receiverId;
    if (contentType != null) result.contentType = contentType;
    if (content != null) result.content = content;
    if (conversationId != null) result.conversationId = conversationId;
    if (ext != null) result.ext.addEntries(ext);
    return result;
  }

  ChatMessage._();

  factory ChatMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..aI(2, _omitFieldNames ? '' : 'chatType', protoName: 'chatType')
    ..aOS(3, _omitFieldNames ? '' : 'senderId', protoName: 'senderId')
    ..aOS(4, _omitFieldNames ? '' : 'receiverId', protoName: 'receiverId')
    ..aI(5, _omitFieldNames ? '' : 'contentType', protoName: 'contentType')
    ..aOS(6, _omitFieldNames ? '' : 'content')
    ..aOS(7, _omitFieldNames ? '' : 'conversationId',
        protoName: 'conversationId')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'ext',
        entryClassName: 'ChatMessage.ExtEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('gim.im'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage copyWith(void Function(ChatMessage) updates) =>
      super.copyWith((message) => updates(message as ChatMessage))
          as ChatMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  @$core.override
  ChatMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get chatType => $_getIZ(1);
  @$pb.TagNumber(2)
  set chatType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChatType() => $_has(1);
  @$pb.TagNumber(2)
  void clearChatType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get senderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set senderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSenderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get receiverId => $_getSZ(3);
  @$pb.TagNumber(4)
  set receiverId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReceiverId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceiverId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get contentType => $_getIZ(4);
  @$pb.TagNumber(5)
  set contentType($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContentType() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get conversationId => $_getSZ(6);
  @$pb.TagNumber(7)
  set conversationId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConversationId() => $_has(6);
  @$pb.TagNumber(7)
  void clearConversationId() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get ext => $_getMap(7);
}

/// cmd = 12: 服务端 ACK（服务器确认收到消息）
class ServerAck extends $pb.GeneratedMessage {
  factory ServerAck({
    $core.String? clientRequestId,
    $core.String? serverMsgId,
    $core.int? code,
    $fixnum.Int64? serverTime,
  }) {
    final result = create();
    if (clientRequestId != null) result.clientRequestId = clientRequestId;
    if (serverMsgId != null) result.serverMsgId = serverMsgId;
    if (code != null) result.code = code;
    if (serverTime != null) result.serverTime = serverTime;
    return result;
  }

  ServerAck._();

  factory ServerAck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerAck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerAck',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientRequestId',
        protoName: 'clientRequestId')
    ..aOS(2, _omitFieldNames ? '' : 'serverMsgId', protoName: 'serverMsgId')
    ..aI(3, _omitFieldNames ? '' : 'code')
    ..aInt64(4, _omitFieldNames ? '' : 'serverTime', protoName: 'serverTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerAck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerAck copyWith(void Function(ServerAck) updates) =>
      super.copyWith((message) => updates(message as ServerAck)) as ServerAck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerAck create() => ServerAck._();
  @$core.override
  ServerAck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerAck getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerAck>(create);
  static ServerAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientRequestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientRequestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverMsgId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverMsgId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerMsgId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerMsgId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get code => $_getIZ(2);
  @$pb.TagNumber(3)
  set code($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get serverTime => $_getI64(3);
  @$pb.TagNumber(4)
  set serverTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasServerTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearServerTime() => $_clearField(4);
}

/// cmd = 13: 送达 ACK（接收方客户端 → 服务端）
class DeliveryAck extends $pb.GeneratedMessage {
  factory DeliveryAck({
    $core.String? msgId,
    $core.String? senderId,
  }) {
    final result = create();
    if (msgId != null) result.msgId = msgId;
    if (senderId != null) result.senderId = senderId;
    return result;
  }

  DeliveryAck._();

  factory DeliveryAck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeliveryAck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeliveryAck',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..aOS(2, _omitFieldNames ? '' : 'senderId', protoName: 'senderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliveryAck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliveryAck copyWith(void Function(DeliveryAck) updates) =>
      super.copyWith((message) => updates(message as DeliveryAck))
          as DeliveryAck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeliveryAck create() => DeliveryAck._();
  @$core.override
  DeliveryAck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeliveryAck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeliveryAck>(create);
  static DeliveryAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get senderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set senderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSenderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderId() => $_clearField(2);
}

/// cmd = 14: 已读回执
class ReadReceipt extends $pb.GeneratedMessage {
  factory ReadReceipt({
    $core.String? conversationId,
    $core.String? lastReadMsgId,
  }) {
    final result = create();
    if (conversationId != null) result.conversationId = conversationId;
    if (lastReadMsgId != null) result.lastReadMsgId = lastReadMsgId;
    return result;
  }

  ReadReceipt._();

  factory ReadReceipt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadReceipt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadReceipt',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId',
        protoName: 'conversationId')
    ..aOS(2, _omitFieldNames ? '' : 'lastReadMsgId', protoName: 'lastReadMsgId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadReceipt clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadReceipt copyWith(void Function(ReadReceipt) updates) =>
      super.copyWith((message) => updates(message as ReadReceipt))
          as ReadReceipt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadReceipt create() => ReadReceipt._();
  @$core.override
  ReadReceipt createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadReceipt getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadReceipt>(create);
  static ReadReceipt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastReadMsgId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastReadMsgId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastReadMsgId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastReadMsgId() => $_clearField(2);
}

/// cmd = 15: 消息撤回请求（客户端 → 服务端）
class MsgRecallRequest extends $pb.GeneratedMessage {
  factory MsgRecallRequest({
    $core.String? msgId,
    $core.String? conversationId,
    $core.int? chatType,
  }) {
    final result = create();
    if (msgId != null) result.msgId = msgId;
    if (conversationId != null) result.conversationId = conversationId;
    if (chatType != null) result.chatType = chatType;
    return result;
  }

  MsgRecallRequest._();

  factory MsgRecallRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MsgRecallRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MsgRecallRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..aOS(2, _omitFieldNames ? '' : 'conversationId',
        protoName: 'conversationId')
    ..aI(3, _omitFieldNames ? '' : 'chatType', protoName: 'chatType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgRecallRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgRecallRequest copyWith(void Function(MsgRecallRequest) updates) =>
      super.copyWith((message) => updates(message as MsgRecallRequest))
          as MsgRecallRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MsgRecallRequest create() => MsgRecallRequest._();
  @$core.override
  MsgRecallRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MsgRecallRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MsgRecallRequest>(create);
  static MsgRecallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConversationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get chatType => $_getIZ(2);
  @$pb.TagNumber(3)
  set chatType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChatType() => $_has(2);
  @$pb.TagNumber(3)
  void clearChatType() => $_clearField(3);
}

/// cmd = 16: 消息撤回通知（服务端 → 客户端，推送给对方）
class MsgRecallNotify extends $pb.GeneratedMessage {
  factory MsgRecallNotify({
    $core.String? msgId,
    $core.String? conversationId,
    $core.String? operatorId,
    $core.int? chatType,
  }) {
    final result = create();
    if (msgId != null) result.msgId = msgId;
    if (conversationId != null) result.conversationId = conversationId;
    if (operatorId != null) result.operatorId = operatorId;
    if (chatType != null) result.chatType = chatType;
    return result;
  }

  MsgRecallNotify._();

  factory MsgRecallNotify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MsgRecallNotify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MsgRecallNotify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..aOS(2, _omitFieldNames ? '' : 'conversationId',
        protoName: 'conversationId')
    ..aOS(3, _omitFieldNames ? '' : 'operatorId', protoName: 'operatorId')
    ..aI(4, _omitFieldNames ? '' : 'chatType', protoName: 'chatType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgRecallNotify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgRecallNotify copyWith(void Function(MsgRecallNotify) updates) =>
      super.copyWith((message) => updates(message as MsgRecallNotify))
          as MsgRecallNotify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MsgRecallNotify create() => MsgRecallNotify._();
  @$core.override
  MsgRecallNotify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MsgRecallNotify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MsgRecallNotify>(create);
  static MsgRecallNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConversationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get operatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set operatorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperatorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get chatType => $_getIZ(3);
  @$pb.TagNumber(4)
  set chatType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChatType() => $_has(3);
  @$pb.TagNumber(4)
  void clearChatType() => $_clearField(4);
}

/// cmd = 20: 在线状态变更通知（服务端推送给关注方）
class OnlineStatusNotify extends $pb.GeneratedMessage {
  factory OnlineStatusNotify({
    $core.String? userId,
    $core.int? status,
    $core.String? device,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (status != null) result.status = status;
    if (device != null) result.device = device;
    return result;
  }

  OnlineStatusNotify._();

  factory OnlineStatusNotify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OnlineStatusNotify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OnlineStatusNotify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aI(2, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'device')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnlineStatusNotify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnlineStatusNotify copyWith(void Function(OnlineStatusNotify) updates) =>
      super.copyWith((message) => updates(message as OnlineStatusNotify))
          as OnlineStatusNotify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OnlineStatusNotify create() => OnlineStatusNotify._();
  @$core.override
  OnlineStatusNotify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OnlineStatusNotify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OnlineStatusNotify>(create);
  static OnlineStatusNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(2)
  set status($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get device => $_getSZ(2);
  @$pb.TagNumber(3)
  set device($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDevice() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevice() => $_clearField(3);
}

/// cmd = 30: 好友申请通知（服务端推送）
class FriendRequestNotify extends $pb.GeneratedMessage {
  factory FriendRequestNotify({
    $core.String? senderId,
    $core.String? receiverId,
    $core.String? nickname,
    $core.String? avatar,
    $core.String? message,
    $core.String? requestId,
    $core.String? logId,
  }) {
    final result = create();
    if (senderId != null) result.senderId = senderId;
    if (receiverId != null) result.receiverId = receiverId;
    if (nickname != null) result.nickname = nickname;
    if (avatar != null) result.avatar = avatar;
    if (message != null) result.message = message;
    if (requestId != null) result.requestId = requestId;
    if (logId != null) result.logId = logId;
    return result;
  }

  FriendRequestNotify._();

  factory FriendRequestNotify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendRequestNotify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendRequestNotify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'senderId', protoName: 'senderId')
    ..aOS(2, _omitFieldNames ? '' : 'receiverId', protoName: 'receiverId')
    ..aOS(3, _omitFieldNames ? '' : 'nickname')
    ..aOS(4, _omitFieldNames ? '' : 'avatar')
    ..aOS(5, _omitFieldNames ? '' : 'message')
    ..aOS(6, _omitFieldNames ? '' : 'requestId', protoName: 'requestId')
    ..aOS(7, _omitFieldNames ? '' : 'logId', protoName: 'logId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendRequestNotify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendRequestNotify copyWith(void Function(FriendRequestNotify) updates) =>
      super.copyWith((message) => updates(message as FriendRequestNotify))
          as FriendRequestNotify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendRequestNotify create() => FriendRequestNotify._();
  @$core.override
  FriendRequestNotify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendRequestNotify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendRequestNotify>(create);
  static FriendRequestNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get senderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set senderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSenderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSenderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get receiverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set receiverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceiverId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiverId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nickname => $_getSZ(2);
  @$pb.TagNumber(3)
  set nickname($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNickname() => $_has(2);
  @$pb.TagNumber(3)
  void clearNickname() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get avatar => $_getSZ(3);
  @$pb.TagNumber(4)
  set avatar($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvatar() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatar() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get requestId => $_getSZ(5);
  @$pb.TagNumber(6)
  set requestId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestId() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get logId => $_getSZ(6);
  @$pb.TagNumber(7)
  set logId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLogId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLogId() => $_clearField(7);
}

/// cmd = 31: 好友状态变更通知
class FriendStatusNotify extends $pb.GeneratedMessage {
  factory FriendStatusNotify({
    $core.String? userId,
    $core.String? receiverId,
    $core.int? status,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (receiverId != null) result.receiverId = receiverId;
    if (status != null) result.status = status;
    return result;
  }

  FriendStatusNotify._();

  factory FriendStatusNotify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendStatusNotify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendStatusNotify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'receiverId', protoName: 'receiverId')
    ..aI(3, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendStatusNotify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendStatusNotify copyWith(void Function(FriendStatusNotify) updates) =>
      super.copyWith((message) => updates(message as FriendStatusNotify))
          as FriendStatusNotify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendStatusNotify create() => FriendStatusNotify._();
  @$core.override
  FriendStatusNotify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendStatusNotify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendStatusNotify>(create);
  static FriendStatusNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get receiverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set receiverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceiverId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiverId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get status => $_getIZ(2);
  @$pb.TagNumber(3)
  set status($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);
}

/// cmd = 40: 群成员变更通知
class GroupMemberNotify extends $pb.GeneratedMessage {
  factory GroupMemberNotify({
    $core.String? groupId,
    $core.int? action,
    $core.String? userId,
    $core.String? operatorId,
  }) {
    final result = create();
    if (groupId != null) result.groupId = groupId;
    if (action != null) result.action = action;
    if (userId != null) result.userId = userId;
    if (operatorId != null) result.operatorId = operatorId;
    return result;
  }

  GroupMemberNotify._();

  factory GroupMemberNotify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupMemberNotify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupMemberNotify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..aI(2, _omitFieldNames ? '' : 'action')
    ..aOS(3, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'operatorId', protoName: 'operatorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberNotify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberNotify copyWith(void Function(GroupMemberNotify) updates) =>
      super.copyWith((message) => updates(message as GroupMemberNotify))
          as GroupMemberNotify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMemberNotify create() => GroupMemberNotify._();
  @$core.override
  GroupMemberNotify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupMemberNotify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupMemberNotify>(create);
  static GroupMemberNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get action => $_getIZ(1);
  @$pb.TagNumber(2)
  set action($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get operatorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set operatorId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOperatorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOperatorId() => $_clearField(4);
}

/// cmd = 41: 群信息/事件通知（群信息变更、公告、禁言、角色变更等）
class GroupNotify extends $pb.GeneratedMessage {
  factory GroupNotify({
    $core.String? groupId,
    $core.int? action,
    $core.String? operatorId,
    $core.String? targetUserId,
    $core.String? content,
  }) {
    final result = create();
    if (groupId != null) result.groupId = groupId;
    if (action != null) result.action = action;
    if (operatorId != null) result.operatorId = operatorId;
    if (targetUserId != null) result.targetUserId = targetUserId;
    if (content != null) result.content = content;
    return result;
  }

  GroupNotify._();

  factory GroupNotify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupNotify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupNotify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..aI(2, _omitFieldNames ? '' : 'action')
    ..aOS(3, _omitFieldNames ? '' : 'operatorId', protoName: 'operatorId')
    ..aOS(4, _omitFieldNames ? '' : 'targetUserId', protoName: 'targetUserId')
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupNotify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupNotify copyWith(void Function(GroupNotify) updates) =>
      super.copyWith((message) => updates(message as GroupNotify))
          as GroupNotify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupNotify create() => GroupNotify._();
  @$core.override
  GroupNotify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupNotify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupNotify>(create);
  static GroupNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get action => $_getIZ(1);
  @$pb.TagNumber(2)
  set action($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get operatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set operatorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperatorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => $_clearField(5);
}

/// cmd = 42: 入群申请通知
class GroupJoinRequestNotify extends $pb.GeneratedMessage {
  factory GroupJoinRequestNotify({
    $core.String? groupId,
    $core.String? userId,
    $core.String? operatorId,
    $core.int? status,
    $core.String? message,
  }) {
    final result = create();
    if (groupId != null) result.groupId = groupId;
    if (userId != null) result.userId = userId;
    if (operatorId != null) result.operatorId = operatorId;
    if (status != null) result.status = status;
    if (message != null) result.message = message;
    return result;
  }

  GroupJoinRequestNotify._();

  factory GroupJoinRequestNotify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupJoinRequestNotify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupJoinRequestNotify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..aOS(2, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'operatorId', protoName: 'operatorId')
    ..aI(4, _omitFieldNames ? '' : 'status')
    ..aOS(5, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupJoinRequestNotify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupJoinRequestNotify copyWith(
          void Function(GroupJoinRequestNotify) updates) =>
      super.copyWith((message) => updates(message as GroupJoinRequestNotify))
          as GroupJoinRequestNotify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupJoinRequestNotify create() => GroupJoinRequestNotify._();
  @$core.override
  GroupJoinRequestNotify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupJoinRequestNotify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupJoinRequestNotify>(create);
  static GroupJoinRequestNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get operatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set operatorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperatorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get status => $_getIZ(3);
  @$pb.TagNumber(4)
  set status($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => $_clearField(5);
}

/// cmd = 50: WebRTC 信令消息
class RtcSignal extends $pb.GeneratedMessage {
  factory RtcSignal({
    $core.int? signalType,
    $core.String? senderId,
    $core.String? receiverId,
    $core.String? payload,
    $core.String? callId,
  }) {
    final result = create();
    if (signalType != null) result.signalType = signalType;
    if (senderId != null) result.senderId = senderId;
    if (receiverId != null) result.receiverId = receiverId;
    if (payload != null) result.payload = payload;
    if (callId != null) result.callId = callId;
    return result;
  }

  RtcSignal._();

  factory RtcSignal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtcSignal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtcSignal',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'signalType', protoName: 'signalType')
    ..aOS(2, _omitFieldNames ? '' : 'senderId', protoName: 'senderId')
    ..aOS(3, _omitFieldNames ? '' : 'receiverId', protoName: 'receiverId')
    ..aOS(4, _omitFieldNames ? '' : 'payload')
    ..aOS(5, _omitFieldNames ? '' : 'callId', protoName: 'callId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtcSignal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtcSignal copyWith(void Function(RtcSignal) updates) =>
      super.copyWith((message) => updates(message as RtcSignal)) as RtcSignal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtcSignal create() => RtcSignal._();
  @$core.override
  RtcSignal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtcSignal getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RtcSignal>(create);
  static RtcSignal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get signalType => $_getIZ(0);
  @$pb.TagNumber(1)
  set signalType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSignalType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get senderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set senderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSenderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get receiverId => $_getSZ(2);
  @$pb.TagNumber(3)
  set receiverId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReceiverId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiverId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get payload => $_getSZ(3);
  @$pb.TagNumber(4)
  set payload($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPayload() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayload() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get callId => $_getSZ(4);
  @$pb.TagNumber(5)
  set callId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCallId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCallId() => $_clearField(5);
}

/// cmd = 51: WebRTC 群聊信令消息
class RtcGroup extends $pb.GeneratedMessage {
  factory RtcGroup({
    $core.int? signalType,
    $core.String? senderId,
    $core.String? groupId,
    $core.String? payload,
    $core.String? callId,
  }) {
    final result = create();
    if (signalType != null) result.signalType = signalType;
    if (senderId != null) result.senderId = senderId;
    if (groupId != null) result.groupId = groupId;
    if (payload != null) result.payload = payload;
    if (callId != null) result.callId = callId;
    return result;
  }

  RtcGroup._();

  factory RtcGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtcGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtcGroup',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'signalType', protoName: 'signalType')
    ..aOS(2, _omitFieldNames ? '' : 'senderId', protoName: 'senderId')
    ..aOS(3, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..aOS(4, _omitFieldNames ? '' : 'payload')
    ..aOS(5, _omitFieldNames ? '' : 'callId', protoName: 'callId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtcGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtcGroup copyWith(void Function(RtcGroup) updates) =>
      super.copyWith((message) => updates(message as RtcGroup)) as RtcGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtcGroup create() => RtcGroup._();
  @$core.override
  RtcGroup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtcGroup getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RtcGroup>(create);
  static RtcGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get signalType => $_getIZ(0);
  @$pb.TagNumber(1)
  set signalType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSignalType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get senderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set senderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSenderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get groupId => $_getSZ(2);
  @$pb.TagNumber(3)
  set groupId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGroupId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get payload => $_getSZ(3);
  @$pb.TagNumber(4)
  set payload($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPayload() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayload() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get callId => $_getSZ(4);
  @$pb.TagNumber(5)
  set callId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCallId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCallId() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
