import 'package:flutter/foundation.dart';

import '../core/connection_state.dart';
import '../core/im_client.dart';
import '../model/im_config.dart';
import '../protocol/ImProto.pb.dart' as proto;
import '../protocol/cmd.dart';
import '../protocol/packet_codec.dart';
import '../spi/im_event_listener.dart';

/// GIM IM SDK 核心服务
///
/// 提供 IM 连接管理、消息发送、事件监听等核心能力
/// SDK 只负责通信层，不包含业务逻辑（DB、会话管理、UUID生成等）
///
/// 使用示例：
/// ```dart
/// final service = GimImService();
///
/// // 注册事件监听
/// service.addEventListener(MyImEventListener());
///
/// // 连接
/// await service.connect(ImConfig(
///   host: '192.168.1.100',
///   port: 3333,
///   userId: 'user_001',
///   token: 'jwt_token',
///   device: 'mobile',
/// ));
///
/// // 发送 Packet（由使用方自行构建）
/// final packet = PacketCodec.buildChatMsg(...);
/// service.send(packet);
///
/// // 断开连接
/// await service.disconnect();
/// ```
class GimImService {
  /// 连接状态（使用 ValueNotifier，不依赖 GetX）
  final connectionState = ValueNotifier<ImConnectionState>(
    ImConnectionState.disconnected,
  );

  /// 已注册的事件监听器列表
  final List<ImEventListener> _listeners = [];

  /// 内部 ImClient 实例
  ImClient? _client;

  /// 当前配置
  ImConfig? _config;

  /// 添加事件监听器
  void addEventListener(ImEventListener listener) {
    _listeners.add(listener);
  }

  /// 移除事件监听器
  void removeEventListener(ImEventListener listener) {
    _listeners.remove(listener);
  }

  /// 连接并绑定
  Future<void> connect(ImConfig config) async {
    _config = config;

    // 清理旧连接
    await _client?.disconnect();

    // 创建 ImClient
    _client = ImClient(
      host: config.host,
      port: config.port,
      maxReconnectAttempts: config.maxReconnectAttempts,
      reconnectBaseDelay: config.reconnectBaseDelay,
      reconnectMaxDelay: config.reconnectMaxDelay,
      onStateChanged: _onStateChanged,
      onPacket: _onPacket,
      onBindFailed: _onBindFailed,
      onKicked: _onKicked,
    );

    // 连接并绑定
    await _client!.connect(
      userId: config.userId,
      token: config.token,
      device: config.device,
      deviceId: config.deviceId,
    );
  }

  /// 断开连接
  Future<void> disconnect() async {
    await _client?.disconnect();
  }

  /// 前台恢复时检查连接
  Future<void> reconnectIfNeeded() async {
    await _client?.reconnectIfNeeded();
  }

  /// 进入后台时暂停重连
  void pauseForBackground() {
    _client?.pauseForBackground();
  }

  /// 发送 Packet
  ///
  /// SDK 只暴露此方法用于发送数据，
  /// 使用方通过 PacketCodec 构建 Packet 后调用此方法发送
  void send(proto.Packet packet) {
    _client?.send(packet);
  }

  /// 是否已连接并认证
  bool get isAuthenticated => _client?.isAuthenticated ?? false;

  /// 当前用户 ID
  String? get userId => _config?.userId;

  /// 服务端节点 ID
  String? get serverId => _client?.serverId;

  /// 释放资源
  void dispose() {
    _client?.dispose();
    _client = null;
    _listeners.clear();
    connectionState.dispose();
  }

  // ====================== 内部事件分发 ======================

  /// 连接状态变更 → 更新 ValueNotifier + 分发给 Listener
  void _onStateChanged(ImConnectionState state) {
    connectionState.value = state;
    for (final listener in _listeners) {
      listener.onConnectionStateChanged(state);
    }
  }

  /// 收到 Packet → 内部处理 + 分发给 Listener
  void _onPacket(proto.Packet packet) {
    // 先做内部处理（如 ServerAck 的特殊逻辑）
    _handleInternalPacket(packet);

    // 分发给所有 Listener
    for (final listener in _listeners) {
      _dispatchToListener(listener, packet);
    }
  }

  /// 内部 Packet 处理（如 ServerAck 通知 onMessageSent）
  void _handleInternalPacket(proto.Packet packet) {
    // ServerAck 需要特殊处理：通知 onMessageSent
    // 其他 Packet 直接分发即可
  }

  /// 根据 Packet 的 cmd 类型，调用 Listener 对应的回调方法
  void _dispatchToListener(ImEventListener listener, proto.Packet packet) {
    switch (packet.cmd) {
      // 聊天消息
      case Cmd.singleChatMsg:
      case Cmd.groupChatMsg:
        listener.onMessageReceived(packet);
        break;

      // 服务端 ACK
      case Cmd.serverAck:
        listener.onMessageSent(packet);
        break;

      // 送达 ACK
      case Cmd.deliveryAck:
        listener.onMessageDelivered(packet);
        break;

      // 已读回执
      case Cmd.readReceipt:
        listener.onMessageRead(packet);
        break;

      // 消息撤回通知
      case Cmd.msgRecallNotify:
        listener.onMessageRecalled(packet);
        break;

      // 在线状态（status: 1=在线, 0=离线）
      case Cmd.onlineStatusNotify:
        final notify = PacketCodec.parseOnlineStatusNotify(packet);
        if (notify.status == 1) {
          listener.onUserOnline(packet);
        } else {
          listener.onUserOffline(packet);
        }
        break;

      // 好友通知
      case Cmd.friendRequestNotify:
        listener.onFriendRequest(packet);
        break;
      case Cmd.friendStatusNotify:
        listener.onFriendStatusChanged(packet);
        break;

      // 群组通知
      case Cmd.groupMemberNotify:
        listener.onGroupMemberChanged(packet);
        break;
      case Cmd.groupNotify:
        listener.onGroupNotify(packet);
        break;
      case Cmd.groupJoinRequestNotify:
        listener.onGroupJoinRequest(packet);
        break;

      // WebRTC 信令
      case Cmd.rtcSignal:
        listener.onRtcSignal(packet);
        break;

      // WebRTC 群通话信令
      case Cmd.rtcGroup:
        listener.onRtcGroup(packet);
        break;
    }
  }

  /// 被踢下线回调
  void _onKicked(int code, String message) {
    for (final listener in _listeners) {
      listener.onKicked(code, message);
    }
  }

  /// 绑定失败回调
  void _onBindFailed(int code, String message) {
    for (final listener in _listeners) {
      listener.onBindFailed(code, message);
    }
  }
}
