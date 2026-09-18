import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gim_sdk_flutter/gim_im_sdk.dart';

/// 群通话模块单元测试
///
/// 覆盖：
/// - cmd=51 RtcGroup 信令编解码往返（含 roomId/mode 字段，proto 手动同步的回归验证）
/// - 信令 payload DTO 与服务端字段的 JSON 兼容性
/// - Mesh Offer 发起决策与 ICE Server 构建
void main() {
  group('RtcGroup 信令编解码（cmd=51）', () {
    test('buildRtcGroup → encode → decode → parseRtcGroup 字段往返一致', () {
      final packet = PacketCodec.buildRtcGroup(
        signalType: GroupSignalType.groupCallRequest,
        senderId: 'userA',
        groupId: 'group001',
        payload: '{"callType":"video"}',
        callId: 'call-uuid-1',
        roomId: 'room-1',
      );

      expect(packet.cmd, Cmd.rtcGroup);

      // 模拟网络传输：编码后再解码
      final decoded = PacketCodec.decode(PacketCodec.encode(packet));
      final signal = PacketCodec.parseRtcGroup(decoded);

      expect(signal.signalType, GroupSignalType.groupCallRequest);
      expect(signal.senderId, 'userA');
      expect(signal.groupId, 'group001');
      expect(signal.payload, '{"callType":"video"}');
      expect(signal.callId, 'call-uuid-1');
      expect(signal.roomId, 'room-1');
      expect(signal.mode, 0); // 默认 Mesh
    });

    test('mode=1（SFU）字段往返一致', () {
      final packet = PacketCodec.buildRtcGroup(
        signalType: GroupSignalType.roomState,
        senderId: 'server',
        groupId: 'g',
        callId: 'c',
        roomId: 'r',
        mode: 1,
      );

      final signal =
          PacketCodec.parseRtcGroup(PacketCodec.decode(PacketCodec.encode(packet)));
      expect(signal.mode, 1);
    });

    test('parseBody 对 cmd=51 分发到 RtcGroup', () {
      final packet = PacketCodec.buildRtcGroup(
        signalType: GroupSignalType.mediaState,
        senderId: 'u1',
        groupId: 'g1',
        payload: '{"mic":false}',
        callId: 'c1',
      );
      final body = PacketCodec.parseBody(packet);
      expect(body, isA<RtcGroup>());
      expect((body as RtcGroup).payload, '{"mic":false}');
    });
  });

  group('GroupCallMode 解析', () {
    test('intValue 优先：1=SFU，0=Mesh', () {
      expect(GroupCallMode.from(intValue: 1), GroupCallMode.sfu);
      expect(GroupCallMode.from(intValue: 0), GroupCallMode.mesh);
    });

    test('stringValue 回退：sfu/mesh/未知', () {
      expect(
          GroupCallMode.from(stringValue: 'sfu'), GroupCallMode.sfu);
      expect(
          GroupCallMode.from(stringValue: 'mesh'), GroupCallMode.mesh);
      expect(GroupCallMode.from(stringValue: 'unknown'), GroupCallMode.mesh);
    });
  });

  group('GroupMemberStatus 解析', () {
    test('服务端状态字符串解析，未知值回退 invited', () {
      expect(GroupMemberStatus.fromName('joined'),
          GroupMemberStatus.joined);
      expect(GroupMemberStatus.fromName('left'), GroupMemberStatus.left);
      expect(GroupMemberStatus.fromName('rejected'),
          GroupMemberStatus.rejected);
      expect(GroupMemberStatus.fromName('invited'),
          GroupMemberStatus.invited);
      expect(GroupMemberStatus.fromName(null), GroupMemberStatus.invited);
      expect(GroupMemberStatus.fromName('???'), GroupMemberStatus.invited);
    });
  });

  group('payload DTO 与服务端字段兼容', () {
    test('GroupRoomState.fromJson 解析服务端 roomState(27) 完整字段', () {
      final roomState = GroupRoomState.fromJson({
        'roomId': 'room-1',
        'callId': 'call-1',
        'groupId': 'group-1',
        'mode': 'mesh',
        'callType': 'video',
        'initiatorId': 'userA',
        'status': 'ringing',
        'members': [
          {'userId': 'userA', 'status': 'joined', 'camera': true, 'mic': true},
          {'userId': 'userB', 'status': 'invited'},
        ],
        'turnInfo': {
          'stunUrl': 'stun:stun.example.com',
          'turnUrl': 'turn:turn.example.com',
          'username': 'u',
          'credential': 'c',
        },
      });

      expect(roomState.roomId, 'room-1');
      expect(roomState.callId, 'call-1');
      expect(roomState.groupId, 'group-1');
      expect(roomState.mode, GroupCallMode.mesh);
      expect(roomState.isVideoCall, isTrue);
      expect(roomState.initiatorId, 'userA');
      expect(roomState.status, 'ringing');
      expect(roomState.members.length, 2);
      expect(roomState.members[0].camera, isTrue);
      expect(roomState.members[1].status, GroupMemberStatus.invited);
      expect(roomState.turnInfo?.turnUrl, 'turn:turn.example.com');
    });

    test('GroupCallInvite.fromJson 解析服务端 invite(21) 字段', () {
      final invite = GroupCallInvite.fromJson({
        'callType': 'audio',
        'groupId': 'group-1',
        'initiatorId': 'userA',
        'mode': 'sfu',
      });

      expect(invite.isVideoCall, isFalse);
      expect(invite.groupId, 'group-1');
      expect(invite.initiatorId, 'userA');
      expect(invite.mode, GroupCallMode.sfu);
    });

    test('GroupCallRequestPayload.toJson：inviteeIds 为空时不携带字段', () {
      expect(
          const GroupCallRequestPayload(callType: 'video').toJson(),
          {'callType': 'video'});
      expect(
          const GroupCallRequestPayload(callType: 'video', inviteeIds: [])
              .toJson(),
          {'callType': 'video'});
      expect(
          const GroupCallRequestPayload(
                  callType: 'video', inviteeIds: ['u1', 'u2'])
              .toJson(),
          {'callType': 'video', 'inviteeIds': ['u1', 'u2']});
    });

    test('GroupMediaStatePayload.toJson 只携带变化项', () {
      expect(const GroupMediaStatePayload(camera: true).toJson(),
          {'camera': true});
      expect(const GroupMediaStatePayload(mic: false).toJson(), {'mic': false});
      expect(const GroupMediaStatePayload().toJson(), isEmpty);
    });
  });

  group('Mesh 建连工具', () {
    test('isMeshOfferer：userId 字典序较小方发起，两端决策一致', () {
      expect(isMeshOfferer('userA', 'userB'), isTrue);
      expect(isMeshOfferer('userB', 'userA'), isFalse);
      // 双方各自视角决策互斥：A 发起则 B 不发起
      expect(
          isMeshOfferer('userA', 'userB'),
          isNot(isMeshOfferer('userB', 'userA')));
    });

    test('buildGroupIceServers：无 turnInfo 时回退 Google STUN', () {
      final servers = buildGroupIceServers(null);
      expect(servers, [
        {'urls': fallbackStunUrl},
      ]);
    });

    test('buildGroupIceServers：有 turnInfo 时使用服务端凭据', () {
      final servers = buildGroupIceServers(const TurnCredentials(
        stunUrl: 'stun:stun.example.com',
        turnUrl: 'turn:turn.example.com',
        username: 'user',
        credential: 'cred',
      ));
      expect(servers.length, 2);
      expect(servers[0], {'urls': 'stun:stun.example.com'});
      expect(servers[1], {
        'urls': 'turn:turn.example.com',
        'username': 'user',
        'credential': 'cred',
      });
    });
  });

  group('GroupRtcEngine 连接失败收口', () {
    GroupRtcEngine buildEngine(List<RtcGroup> sent) {
      return GroupRtcEngine(
        localUserId: () => 'userB',
        callback: GroupRtcEngineCallback(
          onSendGroupSignal: (packet) =>
              sent.add(PacketCodec.parseRtcGroup(packet)),
          onSendMediaSignal: (_) {},
          onCallStateChanged: (_) {},
          onIncomingGroupCall: (_, __) {},
          onRoomStateChanged: (_) {},
          onLocalStreamReady: (_) {},
          onLocalVideoTrack: (_) {},
          onRemoteMemberMedia: (_) {},
          onRemoteMemberRemoved: (_) {},
          onMemberMediaStateChanged: (_, __, ___) {},
          onMembersUpdated: () {},
          onCallEnded: (_) {},
          onCallDurationTick: (_) {},
          onError: (_) {},
        ),
      );
    }

    test('connecting 超时自动 leave(reason=failed) 并本地收口', () {
      fakeAsync((async) {
        GroupRtcEngine.connectTimeout = const Duration(milliseconds: 100);
        final sent = <RtcGroup>[];
        final engine = buildEngine(sent);

        // 来电置为 ringing（写入 roomId，使 acceptGroupCall 可用）
        final invite = PacketCodec.buildRtcGroup(
          signalType: GroupSignalType.groupCallInvite,
          senderId: 'userA',
          groupId: 'group-1',
          callId: 'call-1',
          roomId: 'room-1',
          payload: jsonEncode({
            'callType': 'video',
            'groupId': 'group-1',
            'initiatorId': 'userA',
            'mode': 'mesh',
          }),
        );
        engine.handleGroupSignal(PacketCodec.parseRtcGroup(invite));
        expect(engine.state, GroupCallState.ringing);

        unawaited(engine.acceptGroupCall());
        async.elapse(const Duration(milliseconds: 10));
        expect(engine.state, GroupCallState.connecting);

        // 未收到任何媒体连接就绪事件，超时触发主动 leave
        async.elapse(const Duration(milliseconds: 200));
        expect(engine.state, GroupCallState.ended);
        expect(engine.endReason, GroupCallEndReason.failed);
        final leaves = sent
            .where((s) => s.signalType == GroupSignalType.groupCallLeave)
            .toList();
        expect(leaves.length, 1);
        expect(leaves.first.callId, 'call-1');
        expect(leaves.first.roomId, 'room-1');
        expect(leaves.first.payload, '{"reason":"failed"}');
      });
    });

    test('SFU 接入信息缺失时上报 transport broken 主动 leave 收口', () async {
      final sent = <RtcGroup>[];
      final engine = buildEngine(sent);

      // SFU 房间但 sfuUrl/sfuToken 为空 → 传输层立即上报 broken
      final roomState = PacketCodec.buildRtcGroup(
        signalType: GroupSignalType.roomState,
        senderId: 'server',
        groupId: 'group-1',
        callId: 'call-1',
        roomId: 'room-1',
        payload: jsonEncode({
          'roomId': 'room-1',
          'callId': 'call-1',
          'groupId': 'group-1',
          'mode': 'sfu',
          'callType': 'video',
          'initiatorId': 'userA',
          'members': [
            {'userId': 'userA', 'status': 'joined'},
          ],
        }),
      );
      engine.handleGroupSignal(PacketCodec.parseRtcGroup(roomState));

      // 等待 roomState 异步链路（建 transport → broken → leave）完成
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(engine.state, GroupCallState.ended);
      expect(engine.endReason, GroupCallEndReason.failed);
      final leaves = sent
          .where((s) => s.signalType == GroupSignalType.groupCallLeave)
          .toList();
      expect(leaves.length, 1);
      expect(leaves.first.payload, '{"reason":"failed"}');
      await engine.dispose();
    });
  });
}
