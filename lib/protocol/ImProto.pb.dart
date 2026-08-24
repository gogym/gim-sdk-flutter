//
//  Generated code. Do not modify.
//  source: ImProto.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Packet extends $pb.GeneratedMessage {
  factory Packet() => create();
  Packet._() : super();
  factory Packet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Packet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Packet', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'cmd', $pb.PbFieldType.O3)
    ..aInt64(2, _omitFieldNames ? '' : 'sequence')
    ..aOS(3, _omitFieldNames ? '' : 'requestId', protoName: 'requestId')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'body', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Packet clone() => Packet()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Packet copyWith(void Function(Packet) updates) => super.copyWith((message) => updates(message as Packet)) as Packet;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Packet create() => Packet._();
  Packet createEmptyInstance() => create();
  static $pb.PbList<Packet> createRepeated() => $pb.PbList<Packet>();
  @$core.pragma('dart2js:noInline')
  static Packet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Packet>(create);
  static Packet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get cmd => $_getIZ(0);
  @$pb.TagNumber(1)
  set cmd($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCmd() => $_has(0);
  @$pb.TagNumber(1)
  void clearCmd() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sequence => $_getI64(1);
  @$pb.TagNumber(2)
  set sequence($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearSequence() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get body => $_getN(4);
  @$pb.TagNumber(5)
  set body($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBody() => $_has(4);
  @$pb.TagNumber(5)
  void clearBody() => clearField(5);
}

class BindRequest extends $pb.GeneratedMessage {
  factory BindRequest() => create();
  BindRequest._() : super();
  factory BindRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BindRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BindRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOS(3, _omitFieldNames ? '' : 'device')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BindRequest clone() => BindRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BindRequest copyWith(void Function(BindRequest) updates) => super.copyWith((message) => updates(message as BindRequest)) as BindRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BindRequest create() => BindRequest._();
  BindRequest createEmptyInstance() => create();
  static $pb.PbList<BindRequest> createRepeated() => $pb.PbList<BindRequest>();
  @$core.pragma('dart2js:noInline')
  static BindRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BindRequest>(create);
  static BindRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get device => $_getSZ(2);
  @$pb.TagNumber(3)
  set device($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDevice() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevice() => clearField(3);
}

class BindResponse extends $pb.GeneratedMessage {
  factory BindResponse() => create();
  BindResponse._() : super();
  factory BindResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BindResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BindResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'serverId', protoName: 'serverId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BindResponse clone() => BindResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BindResponse copyWith(void Function(BindResponse) updates) => super.copyWith((message) => updates(message as BindResponse)) as BindResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BindResponse create() => BindResponse._();
  BindResponse createEmptyInstance() => create();
  static $pb.PbList<BindResponse> createRepeated() => $pb.PbList<BindResponse>();
  @$core.pragma('dart2js:noInline')
  static BindResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BindResponse>(create);
  static BindResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get serverId => $_getSZ(2);
  @$pb.TagNumber(3)
  set serverId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasServerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerId() => clearField(3);
}

class Heartbeat extends $pb.GeneratedMessage {
  factory Heartbeat() => create();
  Heartbeat._() : super();
  factory Heartbeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Heartbeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Heartbeat', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'clientTime', protoName: 'clientTime')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Heartbeat clone() => Heartbeat()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Heartbeat copyWith(void Function(Heartbeat) updates) => super.copyWith((message) => updates(message as Heartbeat)) as Heartbeat;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Heartbeat create() => Heartbeat._();
  Heartbeat createEmptyInstance() => create();
  static $pb.PbList<Heartbeat> createRepeated() => $pb.PbList<Heartbeat>();
  @$core.pragma('dart2js:noInline')
  static Heartbeat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Heartbeat>(create);
  static Heartbeat? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clientTime => $_getI64(0);
  @$pb.TagNumber(1)
  set clientTime($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientTime() => clearField(1);
}

class HeartbeatResponse extends $pb.GeneratedMessage {
  factory HeartbeatResponse() => create();
  HeartbeatResponse._() : super();
  factory HeartbeatResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HeartbeatResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HeartbeatResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'serverTime', protoName: 'serverTime')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HeartbeatResponse clone() => HeartbeatResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HeartbeatResponse copyWith(void Function(HeartbeatResponse) updates) => super.copyWith((message) => updates(message as HeartbeatResponse)) as HeartbeatResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartbeatResponse create() => HeartbeatResponse._();
  HeartbeatResponse createEmptyInstance() => create();
  static $pb.PbList<HeartbeatResponse> createRepeated() => $pb.PbList<HeartbeatResponse>();
  @$core.pragma('dart2js:noInline')
  static HeartbeatResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HeartbeatResponse>(create);
  static HeartbeatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get serverTime => $_getI64(0);
  @$pb.TagNumber(1)
  set serverTime($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServerTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerTime() => clearField(1);
}

class KickNotify extends $pb.GeneratedMessage {
  factory KickNotify() => create();
  KickNotify._() : super();
  factory KickNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KickNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'KickNotify', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KickNotify clone() => KickNotify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KickNotify copyWith(void Function(KickNotify) updates) => super.copyWith((message) => updates(message as KickNotify)) as KickNotify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickNotify create() => KickNotify._();
  KickNotify createEmptyInstance() => create();
  static $pb.PbList<KickNotify> createRepeated() => $pb.PbList<KickNotify>();
  @$core.pragma('dart2js:noInline')
  static KickNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KickNotify>(create);
  static KickNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage() => create();
  ChatMessage._() : super();
  factory ChatMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'chatType', $pb.PbFieldType.O3, protoName: 'chatType')
    ..aOS(3, _omitFieldNames ? '' : 'senderId', protoName: 'senderId')
    ..aOS(4, _omitFieldNames ? '' : 'receiverId', protoName: 'receiverId')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'contentType', $pb.PbFieldType.O3, protoName: 'contentType')
    ..aOS(6, _omitFieldNames ? '' : 'content')
    ..aOS(7, _omitFieldNames ? '' : 'conversationId', protoName: 'conversationId')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'ext', entryClassName: 'ChatMessage.ExtEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('gim.im'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatMessage clone() => ChatMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage)) as ChatMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  ChatMessage createEmptyInstance() => create();
  static $pb.PbList<ChatMessage> createRepeated() => $pb.PbList<ChatMessage>();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get chatType => $_getIZ(1);
  @$pb.TagNumber(2)
  set chatType($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChatType() => $_has(1);
  @$pb.TagNumber(2)
  void clearChatType() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get senderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set senderId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSenderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get receiverId => $_getSZ(3);
  @$pb.TagNumber(4)
  set receiverId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasReceiverId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceiverId() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get contentType => $_getIZ(4);
  @$pb.TagNumber(5)
  set contentType($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasContentType() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentType() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get conversationId => $_getSZ(6);
  @$pb.TagNumber(7)
  set conversationId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasConversationId() => $_has(6);
  @$pb.TagNumber(7)
  void clearConversationId() => clearField(7);

  @$pb.TagNumber(8)
  $core.Map<$core.String, $core.String> get ext => $_getMap(7);
}

class ServerAck extends $pb.GeneratedMessage {
  factory ServerAck() => create();
  ServerAck._() : super();
  factory ServerAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerAck', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientRequestId', protoName: 'clientRequestId')
    ..aOS(2, _omitFieldNames ? '' : 'serverMsgId', protoName: 'serverMsgId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aInt64(4, _omitFieldNames ? '' : 'serverTime', protoName: 'serverTime')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerAck clone() => ServerAck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerAck copyWith(void Function(ServerAck) updates) => super.copyWith((message) => updates(message as ServerAck)) as ServerAck;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerAck create() => ServerAck._();
  ServerAck createEmptyInstance() => create();
  static $pb.PbList<ServerAck> createRepeated() => $pb.PbList<ServerAck>();
  @$core.pragma('dart2js:noInline')
  static ServerAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerAck>(create);
  static ServerAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientRequestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientRequestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientRequestId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverMsgId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverMsgId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServerMsgId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerMsgId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get code => $_getIZ(2);
  @$pb.TagNumber(3)
  set code($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get serverTime => $_getI64(3);
  @$pb.TagNumber(4)
  set serverTime($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasServerTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearServerTime() => clearField(4);
}

class DeliveryAck extends $pb.GeneratedMessage {
  factory DeliveryAck() => create();
  DeliveryAck._() : super();
  factory DeliveryAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeliveryAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeliveryAck', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..aOS(2, _omitFieldNames ? '' : 'fromUserId', protoName: 'fromUserId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeliveryAck clone() => DeliveryAck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeliveryAck copyWith(void Function(DeliveryAck) updates) => super.copyWith((message) => updates(message as DeliveryAck)) as DeliveryAck;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeliveryAck create() => DeliveryAck._();
  DeliveryAck createEmptyInstance() => create();
  static $pb.PbList<DeliveryAck> createRepeated() => $pb.PbList<DeliveryAck>();
  @$core.pragma('dart2js:noInline')
  static DeliveryAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeliveryAck>(create);
  static DeliveryAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromUserId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromUserId() => clearField(2);
}

class ReadReceipt extends $pb.GeneratedMessage {
  factory ReadReceipt() => create();
  ReadReceipt._() : super();
  factory ReadReceipt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReadReceipt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReadReceipt', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId', protoName: 'conversationId')
    ..aOS(2, _omitFieldNames ? '' : 'lastReadMsgId', protoName: 'lastReadMsgId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReadReceipt clone() => ReadReceipt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReadReceipt copyWith(void Function(ReadReceipt) updates) => super.copyWith((message) => updates(message as ReadReceipt)) as ReadReceipt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadReceipt create() => ReadReceipt._();
  ReadReceipt createEmptyInstance() => create();
  static $pb.PbList<ReadReceipt> createRepeated() => $pb.PbList<ReadReceipt>();
  @$core.pragma('dart2js:noInline')
  static ReadReceipt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReadReceipt>(create);
  static ReadReceipt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastReadMsgId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastReadMsgId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLastReadMsgId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastReadMsgId() => clearField(2);
}

class MsgRecallRequest extends $pb.GeneratedMessage {
  factory MsgRecallRequest() => create();
  MsgRecallRequest._() : super();
  factory MsgRecallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgRecallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MsgRecallRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..aOS(2, _omitFieldNames ? '' : 'conversationId', protoName: 'conversationId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'chatType', $pb.PbFieldType.O3, protoName: 'chatType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgRecallRequest clone() => MsgRecallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgRecallRequest copyWith(void Function(MsgRecallRequest) updates) => super.copyWith((message) => updates(message as MsgRecallRequest)) as MsgRecallRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MsgRecallRequest create() => MsgRecallRequest._();
  MsgRecallRequest createEmptyInstance() => create();
  static $pb.PbList<MsgRecallRequest> createRepeated() => $pb.PbList<MsgRecallRequest>();
  @$core.pragma('dart2js:noInline')
  static MsgRecallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgRecallRequest>(create);
  static MsgRecallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasConversationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get chatType => $_getIZ(2);
  @$pb.TagNumber(3)
  set chatType($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChatType() => $_has(2);
  @$pb.TagNumber(3)
  void clearChatType() => clearField(3);
}

class MsgRecallNotify extends $pb.GeneratedMessage {
  factory MsgRecallNotify() => create();
  MsgRecallNotify._() : super();
  factory MsgRecallNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgRecallNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MsgRecallNotify', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..aOS(2, _omitFieldNames ? '' : 'conversationId', protoName: 'conversationId')
    ..aOS(3, _omitFieldNames ? '' : 'operatorId', protoName: 'operatorId')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'chatType', $pb.PbFieldType.O3, protoName: 'chatType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgRecallNotify clone() => MsgRecallNotify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgRecallNotify copyWith(void Function(MsgRecallNotify) updates) => super.copyWith((message) => updates(message as MsgRecallNotify)) as MsgRecallNotify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MsgRecallNotify create() => MsgRecallNotify._();
  MsgRecallNotify createEmptyInstance() => create();
  static $pb.PbList<MsgRecallNotify> createRepeated() => $pb.PbList<MsgRecallNotify>();
  @$core.pragma('dart2js:noInline')
  static MsgRecallNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgRecallNotify>(create);
  static MsgRecallNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasConversationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get operatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set operatorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOperatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperatorId() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get chatType => $_getIZ(3);
  @$pb.TagNumber(4)
  set chatType($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasChatType() => $_has(3);
  @$pb.TagNumber(4)
  void clearChatType() => clearField(4);
}

class OnlineStatusNotify extends $pb.GeneratedMessage {
  factory OnlineStatusNotify() => create();
  OnlineStatusNotify._() : super();
  factory OnlineStatusNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OnlineStatusNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OnlineStatusNotify', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'device')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OnlineStatusNotify clone() => OnlineStatusNotify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OnlineStatusNotify copyWith(void Function(OnlineStatusNotify) updates) => super.copyWith((message) => updates(message as OnlineStatusNotify)) as OnlineStatusNotify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OnlineStatusNotify create() => OnlineStatusNotify._();
  OnlineStatusNotify createEmptyInstance() => create();
  static $pb.PbList<OnlineStatusNotify> createRepeated() => $pb.PbList<OnlineStatusNotify>();
  @$core.pragma('dart2js:noInline')
  static OnlineStatusNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OnlineStatusNotify>(create);
  static OnlineStatusNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(2)
  set status($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get device => $_getSZ(2);
  @$pb.TagNumber(3)
  set device($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDevice() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevice() => clearField(3);
}

class FriendRequestNotify extends $pb.GeneratedMessage {
  factory FriendRequestNotify() => create();
  FriendRequestNotify._() : super();
  factory FriendRequestNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FriendRequestNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FriendRequestNotify', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromUserId', protoName: 'fromUserId')
    ..aOS(2, _omitFieldNames ? '' : 'toUserId', protoName: 'toUserId')
    ..aOS(3, _omitFieldNames ? '' : 'nickname')
    ..aOS(4, _omitFieldNames ? '' : 'avatar')
    ..aOS(5, _omitFieldNames ? '' : 'message')
    ..aOS(6, _omitFieldNames ? '' : 'requestId', protoName: 'requestId')
    ..aOS(7, _omitFieldNames ? '' : 'logId', protoName: 'logId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FriendRequestNotify clone() => FriendRequestNotify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FriendRequestNotify copyWith(void Function(FriendRequestNotify) updates) => super.copyWith((message) => updates(message as FriendRequestNotify)) as FriendRequestNotify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendRequestNotify create() => FriendRequestNotify._();
  FriendRequestNotify createEmptyInstance() => create();
  static $pb.PbList<FriendRequestNotify> createRepeated() => $pb.PbList<FriendRequestNotify>();
  @$core.pragma('dart2js:noInline')
  static FriendRequestNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FriendRequestNotify>(create);
  static FriendRequestNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromUserId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFromUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get toUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toUserId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get nickname => $_getSZ(2);
  @$pb.TagNumber(3)
  set nickname($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNickname() => $_has(2);
  @$pb.TagNumber(3)
  void clearNickname() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get avatar => $_getSZ(3);
  @$pb.TagNumber(4)
  set avatar($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAvatar() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatar() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get requestId => $_getSZ(5);
  @$pb.TagNumber(6)
  set requestId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRequestId() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestId() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get logId => $_getSZ(6);
  @$pb.TagNumber(7)
  set logId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLogId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLogId() => clearField(7);
}

class FriendStatusNotify extends $pb.GeneratedMessage {
  factory FriendStatusNotify() => create();
  FriendStatusNotify._() : super();
  factory FriendStatusNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FriendStatusNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FriendStatusNotify', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'toUserId', protoName: 'toUserId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FriendStatusNotify clone() => FriendStatusNotify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FriendStatusNotify copyWith(void Function(FriendStatusNotify) updates) => super.copyWith((message) => updates(message as FriendStatusNotify)) as FriendStatusNotify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendStatusNotify create() => FriendStatusNotify._();
  FriendStatusNotify createEmptyInstance() => create();
  static $pb.PbList<FriendStatusNotify> createRepeated() => $pb.PbList<FriendStatusNotify>();
  @$core.pragma('dart2js:noInline')
  static FriendStatusNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FriendStatusNotify>(create);
  static FriendStatusNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get toUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toUserId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get status => $_getIZ(2);
  @$pb.TagNumber(3)
  set status($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class GroupMemberNotify extends $pb.GeneratedMessage {
  factory GroupMemberNotify() => create();
  GroupMemberNotify._() : super();
  factory GroupMemberNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupMemberNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GroupMemberNotify', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'action', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'operatorId', protoName: 'operatorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupMemberNotify clone() => GroupMemberNotify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupMemberNotify copyWith(void Function(GroupMemberNotify) updates) => super.copyWith((message) => updates(message as GroupMemberNotify)) as GroupMemberNotify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMemberNotify create() => GroupMemberNotify._();
  GroupMemberNotify createEmptyInstance() => create();
  static $pb.PbList<GroupMemberNotify> createRepeated() => $pb.PbList<GroupMemberNotify>();
  @$core.pragma('dart2js:noInline')
  static GroupMemberNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupMemberNotify>(create);
  static GroupMemberNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get action => $_getIZ(1);
  @$pb.TagNumber(2)
  set action($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get operatorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set operatorId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOperatorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOperatorId() => clearField(4);
}

class GroupNotify extends $pb.GeneratedMessage {
  factory GroupNotify() => create();
  GroupNotify._() : super();
  factory GroupNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GroupNotify', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'action', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'operatorId', protoName: 'operatorId')
    ..aOS(4, _omitFieldNames ? '' : 'targetUserId', protoName: 'targetUserId')
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupNotify clone() => GroupNotify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupNotify copyWith(void Function(GroupNotify) updates) => super.copyWith((message) => updates(message as GroupNotify)) as GroupNotify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupNotify create() => GroupNotify._();
  GroupNotify createEmptyInstance() => create();
  static $pb.PbList<GroupNotify> createRepeated() => $pb.PbList<GroupNotify>();
  @$core.pragma('dart2js:noInline')
  static GroupNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupNotify>(create);
  static GroupNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get action => $_getIZ(1);
  @$pb.TagNumber(2)
  set action($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get operatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set operatorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOperatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperatorId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetUserId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTargetUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetUserId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => clearField(5);
}

class GroupJoinRequestNotify extends $pb.GeneratedMessage {
  factory GroupJoinRequestNotify() => create();
  GroupJoinRequestNotify._() : super();
  factory GroupJoinRequestNotify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupJoinRequestNotify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GroupJoinRequestNotify', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..aOS(2, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'operatorId', protoName: 'operatorId')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupJoinRequestNotify clone() => GroupJoinRequestNotify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupJoinRequestNotify copyWith(void Function(GroupJoinRequestNotify) updates) => super.copyWith((message) => updates(message as GroupJoinRequestNotify)) as GroupJoinRequestNotify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupJoinRequestNotify create() => GroupJoinRequestNotify._();
  GroupJoinRequestNotify createEmptyInstance() => create();
  static $pb.PbList<GroupJoinRequestNotify> createRepeated() => $pb.PbList<GroupJoinRequestNotify>();
  @$core.pragma('dart2js:noInline')
  static GroupJoinRequestNotify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupJoinRequestNotify>(create);
  static GroupJoinRequestNotify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get operatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set operatorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOperatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperatorId() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get status => $_getIZ(3);
  @$pb.TagNumber(4)
  set status($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => clearField(5);
}

class RtcSignal extends $pb.GeneratedMessage {
  factory RtcSignal() => create();
  RtcSignal._() : super();
  factory RtcSignal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RtcSignal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RtcSignal', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'signalType', $pb.PbFieldType.O3, protoName: 'signalType')
    ..aOS(2, _omitFieldNames ? '' : 'fromUserId', protoName: 'fromUserId')
    ..aOS(3, _omitFieldNames ? '' : 'toUserId', protoName: 'toUserId')
    ..aOS(4, _omitFieldNames ? '' : 'payload')
    ..aOS(5, _omitFieldNames ? '' : 'callId', protoName: 'callId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RtcSignal clone() => RtcSignal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RtcSignal copyWith(void Function(RtcSignal) updates) => super.copyWith((message) => updates(message as RtcSignal)) as RtcSignal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtcSignal create() => RtcSignal._();
  RtcSignal createEmptyInstance() => create();
  static $pb.PbList<RtcSignal> createRepeated() => $pb.PbList<RtcSignal>();
  @$core.pragma('dart2js:noInline')
  static RtcSignal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RtcSignal>(create);
  static RtcSignal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get signalType => $_getIZ(0);
  @$pb.TagNumber(1)
  set signalType($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignalType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromUserId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get toUserId => $_getSZ(2);
  @$pb.TagNumber(3)
  set toUserId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToUserId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get payload => $_getSZ(3);
  @$pb.TagNumber(4)
  set payload($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPayload() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayload() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get callId => $_getSZ(4);
  @$pb.TagNumber(5)
  set callId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCallId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCallId() => clearField(5);
}

class RtcGroup extends $pb.GeneratedMessage {
  factory RtcGroup() => create();
  RtcGroup._() : super();
  factory RtcGroup.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RtcGroup.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RtcGroup', package: const $pb.PackageName(_omitMessageNames ? '' : 'gim.im'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'signalType', $pb.PbFieldType.O3, protoName: 'signalType')
    ..aOS(2, _omitFieldNames ? '' : 'fromUserId', protoName: 'fromUserId')
    ..aOS(3, _omitFieldNames ? '' : 'groupId', protoName: 'groupId')
    ..aOS(4, _omitFieldNames ? '' : 'payload')
    ..aOS(5, _omitFieldNames ? '' : 'callId', protoName: 'callId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RtcGroup clone() => RtcGroup()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RtcGroup copyWith(void Function(RtcGroup) updates) => super.copyWith((message) => updates(message as RtcGroup)) as RtcGroup;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtcGroup create() => RtcGroup._();
  RtcGroup createEmptyInstance() => create();
  static $pb.PbList<RtcGroup> createRepeated() => $pb.PbList<RtcGroup>();
  @$core.pragma('dart2js:noInline')
  static RtcGroup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RtcGroup>(create);
  static RtcGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get signalType => $_getIZ(0);
  @$pb.TagNumber(1)
  set signalType($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignalType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromUserId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get groupId => $_getSZ(2);
  @$pb.TagNumber(3)
  set groupId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGroupId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get payload => $_getSZ(3);
  @$pb.TagNumber(4)
  set payload($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPayload() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayload() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get callId => $_getSZ(4);
  @$pb.TagNumber(5)
  set callId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCallId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCallId() => clearField(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
