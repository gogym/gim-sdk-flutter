// This is a generated file - do not edit.
//
// Generated from ImProto.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use packetDescriptor instead')
const Packet$json = {
  '1': 'Packet',
  '2': [
    {'1': 'cmd', '3': 1, '4': 1, '5': 5, '10': 'cmd'},
    {'1': 'sequence', '3': 2, '4': 1, '5': 3, '10': 'sequence'},
    {'1': 'requestId', '3': 3, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'body', '3': 5, '4': 1, '5': 12, '10': 'body'},
  ],
};

/// Descriptor for `Packet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetDescriptor = $convert.base64Decode(
    'CgZQYWNrZXQSEAoDY21kGAEgASgFUgNjbWQSGgoIc2VxdWVuY2UYAiABKANSCHNlcXVlbmNlEh'
    'wKCXJlcXVlc3RJZBgDIAEoCVIJcmVxdWVzdElkEhwKCXRpbWVzdGFtcBgEIAEoA1IJdGltZXN0'
    'YW1wEhIKBGJvZHkYBSABKAxSBGJvZHk=');

@$core.Deprecated('Use bindRequestDescriptor instead')
const BindRequest$json = {
  '1': 'BindRequest',
  '2': [
    {'1': 'userId', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'device', '3': 3, '4': 1, '5': 9, '10': 'device'},
  ],
};

/// Descriptor for `BindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindRequestDescriptor = $convert.base64Decode(
    'CgtCaW5kUmVxdWVzdBIWCgZ1c2VySWQYASABKAlSBnVzZXJJZBIUCgV0b2tlbhgCIAEoCVIFdG'
    '9rZW4SFgoGZGV2aWNlGAMgASgJUgZkZXZpY2U=');

@$core.Deprecated('Use bindResponseDescriptor instead')
const BindResponse$json = {
  '1': 'BindResponse',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'serverId', '3': 3, '4': 1, '5': 9, '10': 'serverId'},
  ],
};

/// Descriptor for `BindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindResponseDescriptor = $convert.base64Decode(
    'CgxCaW5kUmVzcG9uc2USEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZX'
    'NzYWdlEhoKCHNlcnZlcklkGAMgASgJUghzZXJ2ZXJJZA==');

@$core.Deprecated('Use heartbeatDescriptor instead')
const Heartbeat$json = {
  '1': 'Heartbeat',
  '2': [
    {'1': 'clientTime', '3': 1, '4': 1, '5': 3, '10': 'clientTime'},
  ],
};

/// Descriptor for `Heartbeat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatDescriptor = $convert.base64Decode(
    'CglIZWFydGJlYXQSHgoKY2xpZW50VGltZRgBIAEoA1IKY2xpZW50VGltZQ==');

@$core.Deprecated('Use heartbeatResponseDescriptor instead')
const HeartbeatResponse$json = {
  '1': 'HeartbeatResponse',
  '2': [
    {'1': 'serverTime', '3': 1, '4': 1, '5': 3, '10': 'serverTime'},
  ],
};

/// Descriptor for `HeartbeatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatResponseDescriptor = $convert.base64Decode(
    'ChFIZWFydGJlYXRSZXNwb25zZRIeCgpzZXJ2ZXJUaW1lGAEgASgDUgpzZXJ2ZXJUaW1l');

@$core.Deprecated('Use kickNotifyDescriptor instead')
const KickNotify$json = {
  '1': 'KickNotify',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `KickNotify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickNotifyDescriptor = $convert.base64Decode(
    'CgpLaWNrTm90aWZ5EhIKBGNvZGUYASABKAVSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2'
    'FnZQ==');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'msgId', '3': 1, '4': 1, '5': 9, '10': 'msgId'},
    {'1': 'chatType', '3': 2, '4': 1, '5': 5, '10': 'chatType'},
    {'1': 'senderId', '3': 3, '4': 1, '5': 9, '10': 'senderId'},
    {'1': 'receiverId', '3': 4, '4': 1, '5': 9, '10': 'receiverId'},
    {'1': 'contentType', '3': 5, '4': 1, '5': 5, '10': 'contentType'},
    {'1': 'content', '3': 6, '4': 1, '5': 9, '10': 'content'},
    {'1': 'conversationId', '3': 7, '4': 1, '5': 9, '10': 'conversationId'},
    {
      '1': 'ext',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.gim.im.ChatMessage.ExtEntry',
      '10': 'ext'
    },
  ],
  '3': [ChatMessage_ExtEntry$json],
};

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage_ExtEntry$json = {
  '1': 'ExtEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIUCgVtc2dJZBgBIAEoCVIFbXNnSWQSGgoIY2hhdFR5cGUYAiABKAVSCG'
    'NoYXRUeXBlEhoKCHNlbmRlcklkGAMgASgJUghzZW5kZXJJZBIeCgpyZWNlaXZlcklkGAQgASgJ'
    'UgpyZWNlaXZlcklkEiAKC2NvbnRlbnRUeXBlGAUgASgFUgtjb250ZW50VHlwZRIYCgdjb250ZW'
    '50GAYgASgJUgdjb250ZW50EiYKDmNvbnZlcnNhdGlvbklkGAcgASgJUg5jb252ZXJzYXRpb25J'
    'ZBIuCgNleHQYCCADKAsyHC5naW0uaW0uQ2hhdE1lc3NhZ2UuRXh0RW50cnlSA2V4dBo2CghFeH'
    'RFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use serverAckDescriptor instead')
const ServerAck$json = {
  '1': 'ServerAck',
  '2': [
    {'1': 'clientRequestId', '3': 1, '4': 1, '5': 9, '10': 'clientRequestId'},
    {'1': 'serverMsgId', '3': 2, '4': 1, '5': 9, '10': 'serverMsgId'},
    {'1': 'code', '3': 3, '4': 1, '5': 5, '10': 'code'},
    {'1': 'serverTime', '3': 4, '4': 1, '5': 3, '10': 'serverTime'},
  ],
};

/// Descriptor for `ServerAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverAckDescriptor = $convert.base64Decode(
    'CglTZXJ2ZXJBY2sSKAoPY2xpZW50UmVxdWVzdElkGAEgASgJUg9jbGllbnRSZXF1ZXN0SWQSIA'
    'oLc2VydmVyTXNnSWQYAiABKAlSC3NlcnZlck1zZ0lkEhIKBGNvZGUYAyABKAVSBGNvZGUSHgoK'
    'c2VydmVyVGltZRgEIAEoA1IKc2VydmVyVGltZQ==');

@$core.Deprecated('Use deliveryAckDescriptor instead')
const DeliveryAck$json = {
  '1': 'DeliveryAck',
  '2': [
    {'1': 'msgId', '3': 1, '4': 1, '5': 9, '10': 'msgId'},
    {'1': 'fromUserId', '3': 2, '4': 1, '5': 9, '10': 'fromUserId'},
  ],
};

/// Descriptor for `DeliveryAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deliveryAckDescriptor = $convert.base64Decode(
    'CgtEZWxpdmVyeUFjaxIUCgVtc2dJZBgBIAEoCVIFbXNnSWQSHgoKZnJvbVVzZXJJZBgCIAEoCV'
    'IKZnJvbVVzZXJJZA==');

@$core.Deprecated('Use readReceiptDescriptor instead')
const ReadReceipt$json = {
  '1': 'ReadReceipt',
  '2': [
    {'1': 'conversationId', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'lastReadMsgId', '3': 2, '4': 1, '5': 9, '10': 'lastReadMsgId'},
  ],
};

/// Descriptor for `ReadReceipt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readReceiptDescriptor = $convert.base64Decode(
    'CgtSZWFkUmVjZWlwdBImCg5jb252ZXJzYXRpb25JZBgBIAEoCVIOY29udmVyc2F0aW9uSWQSJA'
    'oNbGFzdFJlYWRNc2dJZBgCIAEoCVINbGFzdFJlYWRNc2dJZA==');

@$core.Deprecated('Use msgRecallRequestDescriptor instead')
const MsgRecallRequest$json = {
  '1': 'MsgRecallRequest',
  '2': [
    {'1': 'msgId', '3': 1, '4': 1, '5': 9, '10': 'msgId'},
    {'1': 'conversationId', '3': 2, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'chatType', '3': 3, '4': 1, '5': 5, '10': 'chatType'},
  ],
};

/// Descriptor for `MsgRecallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgRecallRequestDescriptor = $convert.base64Decode(
    'ChBNc2dSZWNhbGxSZXF1ZXN0EhQKBW1zZ0lkGAEgASgJUgVtc2dJZBImCg5jb252ZXJzYXRpb2'
    '5JZBgCIAEoCVIOY29udmVyc2F0aW9uSWQSGgoIY2hhdFR5cGUYAyABKAVSCGNoYXRUeXBl');

@$core.Deprecated('Use msgRecallNotifyDescriptor instead')
const MsgRecallNotify$json = {
  '1': 'MsgRecallNotify',
  '2': [
    {'1': 'msgId', '3': 1, '4': 1, '5': 9, '10': 'msgId'},
    {'1': 'conversationId', '3': 2, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'operatorId', '3': 3, '4': 1, '5': 9, '10': 'operatorId'},
    {'1': 'chatType', '3': 4, '4': 1, '5': 5, '10': 'chatType'},
  ],
};

/// Descriptor for `MsgRecallNotify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgRecallNotifyDescriptor = $convert.base64Decode(
    'Cg9Nc2dSZWNhbGxOb3RpZnkSFAoFbXNnSWQYASABKAlSBW1zZ0lkEiYKDmNvbnZlcnNhdGlvbk'
    'lkGAIgASgJUg5jb252ZXJzYXRpb25JZBIeCgpvcGVyYXRvcklkGAMgASgJUgpvcGVyYXRvcklk'
    'EhoKCGNoYXRUeXBlGAQgASgFUghjaGF0VHlwZQ==');

@$core.Deprecated('Use onlineStatusNotifyDescriptor instead')
const OnlineStatusNotify$json = {
  '1': 'OnlineStatusNotify',
  '2': [
    {'1': 'userId', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'status', '3': 2, '4': 1, '5': 5, '10': 'status'},
    {'1': 'device', '3': 3, '4': 1, '5': 9, '10': 'device'},
  ],
};

/// Descriptor for `OnlineStatusNotify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onlineStatusNotifyDescriptor = $convert.base64Decode(
    'ChJPbmxpbmVTdGF0dXNOb3RpZnkSFgoGdXNlcklkGAEgASgJUgZ1c2VySWQSFgoGc3RhdHVzGA'
    'IgASgFUgZzdGF0dXMSFgoGZGV2aWNlGAMgASgJUgZkZXZpY2U=');

@$core.Deprecated('Use friendRequestNotifyDescriptor instead')
const FriendRequestNotify$json = {
  '1': 'FriendRequestNotify',
  '2': [
    {'1': 'fromUserId', '3': 1, '4': 1, '5': 9, '10': 'fromUserId'},
    {'1': 'toUserId', '3': 2, '4': 1, '5': 9, '10': 'toUserId'},
    {'1': 'nickname', '3': 3, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'avatar', '3': 4, '4': 1, '5': 9, '10': 'avatar'},
    {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `FriendRequestNotify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendRequestNotifyDescriptor = $convert.base64Decode(
    'ChNGcmllbmRSZXF1ZXN0Tm90aWZ5Eh4KCmZyb21Vc2VySWQYASABKAlSCmZyb21Vc2VySWQSGg'
    'oIdG9Vc2VySWQYAiABKAlSCHRvVXNlcklkEhoKCG5pY2tuYW1lGAMgASgJUghuaWNrbmFtZRIW'
    'CgZhdmF0YXIYBCABKAlSBmF2YXRhchIYCgdtZXNzYWdlGAUgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use friendStatusNotifyDescriptor instead')
const FriendStatusNotify$json = {
  '1': 'FriendStatusNotify',
  '2': [
    {'1': 'userId', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'toUserId', '3': 2, '4': 1, '5': 9, '10': 'toUserId'},
    {'1': 'status', '3': 3, '4': 1, '5': 5, '10': 'status'},
  ],
};

/// Descriptor for `FriendStatusNotify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendStatusNotifyDescriptor = $convert.base64Decode(
    'ChJGcmllbmRTdGF0dXNOb3RpZnkSFgoGdXNlcklkGAEgASgJUgZ1c2VySWQSGgoIdG9Vc2VySW'
    'QYAiABKAlSCHRvVXNlcklkEhYKBnN0YXR1cxgDIAEoBVIGc3RhdHVz');

@$core.Deprecated('Use groupMemberNotifyDescriptor instead')
const GroupMemberNotify$json = {
  '1': 'GroupMemberNotify',
  '2': [
    {'1': 'groupId', '3': 1, '4': 1, '5': 9, '10': 'groupId'},
    {'1': 'action', '3': 2, '4': 1, '5': 5, '10': 'action'},
    {'1': 'userId', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'operatorId', '3': 4, '4': 1, '5': 9, '10': 'operatorId'},
  ],
};

/// Descriptor for `GroupMemberNotify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupMemberNotifyDescriptor = $convert.base64Decode(
    'ChFHcm91cE1lbWJlck5vdGlmeRIYCgdncm91cElkGAEgASgJUgdncm91cElkEhYKBmFjdGlvbh'
    'gCIAEoBVIGYWN0aW9uEhYKBnVzZXJJZBgDIAEoCVIGdXNlcklkEh4KCm9wZXJhdG9ySWQYBCAB'
    'KAlSCm9wZXJhdG9ySWQ=');

@$core.Deprecated('Use groupNotifyDescriptor instead')
const GroupNotify$json = {
  '1': 'GroupNotify',
  '2': [
    {'1': 'groupId', '3': 1, '4': 1, '5': 9, '10': 'groupId'},
    {'1': 'action', '3': 2, '4': 1, '5': 5, '10': 'action'},
    {'1': 'operatorId', '3': 3, '4': 1, '5': 9, '10': 'operatorId'},
    {'1': 'targetUserId', '3': 4, '4': 1, '5': 9, '10': 'targetUserId'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `GroupNotify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupNotifyDescriptor = $convert.base64Decode(
    'CgtHcm91cE5vdGlmeRIYCgdncm91cElkGAEgASgJUgdncm91cElkEhYKBmFjdGlvbhgCIAEoBV'
    'IGYWN0aW9uEh4KCm9wZXJhdG9ySWQYAyABKAlSCm9wZXJhdG9ySWQSIgoMdGFyZ2V0VXNlcklk'
    'GAQgASgJUgx0YXJnZXRVc2VySWQSGAoHY29udGVudBgFIAEoCVIHY29udGVudA==');

@$core.Deprecated('Use groupJoinRequestNotifyDescriptor instead')
const GroupJoinRequestNotify$json = {
  '1': 'GroupJoinRequestNotify',
  '2': [
    {'1': 'groupId', '3': 1, '4': 1, '5': 9, '10': 'groupId'},
    {'1': 'userId', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'operatorId', '3': 3, '4': 1, '5': 9, '10': 'operatorId'},
    {'1': 'status', '3': 4, '4': 1, '5': 5, '10': 'status'},
    {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `GroupJoinRequestNotify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupJoinRequestNotifyDescriptor = $convert.base64Decode(
    'ChZHcm91cEpvaW5SZXF1ZXN0Tm90aWZ5EhgKB2dyb3VwSWQYASABKAlSB2dyb3VwSWQSFgoGdX'
    'NlcklkGAIgASgJUgZ1c2VySWQSHgoKb3BlcmF0b3JJZBgDIAEoCVIKb3BlcmF0b3JJZBIWCgZz'
    'dGF0dXMYBCABKAVSBnN0YXR1cxIYCgdtZXNzYWdlGAUgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use rtcSignalDescriptor instead')
const RtcSignal$json = {
  '1': 'RtcSignal',
  '2': [
    {'1': 'signalType', '3': 1, '4': 1, '5': 5, '10': 'signalType'},
    {'1': 'fromUserId', '3': 2, '4': 1, '5': 9, '10': 'fromUserId'},
    {'1': 'toUserId', '3': 3, '4': 1, '5': 9, '10': 'toUserId'},
    {'1': 'payload', '3': 4, '4': 1, '5': 9, '10': 'payload'},
    {'1': 'callId', '3': 5, '4': 1, '5': 9, '10': 'callId'},
  ],
};

/// Descriptor for `RtcSignal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtcSignalDescriptor = $convert.base64Decode(
    'CglSdGNTaWduYWwSHgoKc2lnbmFsVHlwZRgBIAEoBVIKc2lnbmFsVHlwZRIeCgpmcm9tVXNlck'
    'lkGAIgASgJUgpmcm9tVXNlcklkEhoKCHRvVXNlcklkGAMgASgJUgh0b1VzZXJJZBIYCgdwYXls'
    'b2FkGAQgASgJUgdwYXlsb2FkEhYKBmNhbGxJZBgFIAEoCVIGY2FsbElk');

@$core.Deprecated('Use rtcGroupDescriptor instead')
const RtcGroup$json = {
  '1': 'RtcGroup',
  '2': [
    {'1': 'signalType', '3': 1, '4': 1, '5': 5, '10': 'signalType'},
    {'1': 'fromUserId', '3': 2, '4': 1, '5': 9, '10': 'fromUserId'},
    {'1': 'groupId', '3': 3, '4': 1, '5': 9, '10': 'groupId'},
    {'1': 'payload', '3': 4, '4': 1, '5': 9, '10': 'payload'},
    {'1': 'callId', '3': 5, '4': 1, '5': 9, '10': 'callId'},
  ],
};

/// Descriptor for `RtcGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtcGroupDescriptor = $convert.base64Decode(
    'CghSdGNHcm91cBIeCgpzaWduYWxUeXBlGAEgASgFUgpzaWduYWxUeXBlEh4KCmZyb21Vc2VySW'
    'QYAiABKAlSCmZyb21Vc2VySWQSGAoHZ3JvdXBJZBgDIAEoCVIHZ3JvdXBJZBIYCgdwYXlsb2Fk'
    'GAQgASgJUgdwYXlsb2FkEhYKBmNhbGxJZBgFIAEoCVIGY2FsbElk');
