import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../protocol/ImProto.pb.dart' as proto;
import '../protocol/cmd.dart';
import '../protocol/packet_codec.dart';
import 'connection_state.dart';
import 'frame_codec.dart';
import 'heartbeat_manager.dart';

/// 消息回调
typedef PacketHandler = void Function(proto.Packet packet);

/// IM 客户端 TCP 连接管理
///
/// 负责：
/// - TCP Socket 连接/断开/重连
/// - 帧编解码（Varint32）
/// - 心跳调度
/// - 消息收发
class ImClient {
  /// 服务器地址
  final String host;

  /// 服务器端口
  final int port;

  /// 最大重连次数（null=无限重连）
  final int? maxReconnectAttempts;

  /// 重连基础间隔
  final Duration reconnectBaseDelay;

  /// 最大重连间隔
  final Duration reconnectMaxDelay;

  /// 连接状态变更回调
  final void Function(ImConnectionState state)? onStateChanged;

  /// 消息分发回调
  final void Function(proto.Packet packet)? onPacket;

  /// 绑定失败回调
  final void Function(int code, String message)? onBindFailed;

  /// 被踢下线回调（收到 KickNotify 时触发）
  final void Function(int code, String message)? onKicked;

  Socket? _socket;
  ImConnectionState _state = ImConnectionState.disconnected;
  final BytesBuilder _readBuffer = BytesBuilder();
  HeartbeatManager? _heartbeatManager;
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;
  bool _disposed = false;
  /// 是否被踢下线（被踢后停止一切重连）
  bool _kicked = false;
  /// App 是否处于后台（后台时暂停重连，避免无效重试）
  bool _backgrounded = false;
  /// 连接代次计数器（每次 connect() 递增，防止旧 disconnect 覆盖新 connect）
  int _connectGeneration = 0;
  String? _userId;
  String? _token;
  String? _device;
  String? _deviceId;
  String? _serverId;

  ImClient({
    required this.host,
    required this.port,
    this.maxReconnectAttempts,
    this.reconnectBaseDelay = const Duration(seconds: 2),
    this.reconnectMaxDelay = const Duration(seconds: 60),
    this.onStateChanged,
    this.onPacket,
    this.onBindFailed,
    this.onKicked,
  });

  /// 当前连接状态
  ImConnectionState get state => _state;

  /// 服务端节点 ID
  String? get serverId => _serverId;

  /// 是否已认证
  bool get isAuthenticated => _state == ImConnectionState.authenticated;

  // ====================== 连接管理 ======================

  /// 连接并绑定（首包认证）
  ///
  /// [deviceId] 设备唯一标识（客户端持久化UUID），用于区分同设备重连与异设备顶号
  Future<void> connect({
    required String userId,
    required String token,
    required String device,
    String? deviceId,
  }) async {
    _userId = userId;
    _token = token;
    _device = device;
    _deviceId = deviceId;
    _reconnectAttempts = 0;
    _disposed = false;
    _kicked = false;
    _connectGeneration++;

    await _doConnect();
  }

  /// 主动断开连接
  ///
  /// 使用代次计数器防止旧的 disconnect 覆盖新的 connect 状态。
  /// 如果在 disconnect 执行期间有新的 connect 调用，旧 disconnect 会被跳过。
  Future<void> disconnect() async {
    final gen = _connectGeneration;
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _heartbeatManager?.dispose();
    _heartbeatManager = null;
    PacketCodec.resetSequence();

    try {
      await _socket?.close();
    } catch (_) {}

    // 如果在 await 期间有任何新的 connect() 调用，跳过状态清理
    if (gen != _connectGeneration) {
      debugPrint('[ImClient] disconnect skipped (generation mismatch: $gen != $_connectGeneration)');
      return;
    }

    _socket = null;
    _setState(ImConnectionState.disconnected);
    debugPrint('[ImClient] disconnected');
  }

  /// 释放资源
  void dispose() {
    _disposed = true;
    disconnect();
  }

  /// 前台恢复时检查连接状态，若已断开则立即重连
  ///
  /// App 从后台回到前台时调用：
  /// - 如果连接仍然正常，不做任何操作
  /// - 如果连接已断开（或正在重连但卡住），重置重连计数并立即重连
  Future<void> reconnectIfNeeded() async {
    if (_disposed) return;
    if (_kicked) return; // 被踢后不重连

    // 标记回到前台
    _backgrounded = false;

    // 连接正常，无需重连
    if (_state == ImConnectionState.authenticated || _state == ImConnectionState.connected) {
      debugPrint('[ImClient] reconnectIfNeeded: connection is alive, skip');
      return;
    }

    debugPrint('[ImClient] reconnectIfNeeded: state=$_state, forcing reconnect');

    // 取消已有的重连定时器
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    // 重置重连计数，立即重连
    _reconnectAttempts = 0;
    PacketCodec.resetSequence();

    // 清理旧 socket
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;

    await _doConnect();
  }

  /// App 进入后台时调用，暂停重连尝试
  ///
  /// 不主动断开现有连接、不停止心跳——某些操作系统允许后台保持网络，
  /// 如果连接仍然存活就继续用；如果连接断了则不再重试，等回到前台再恢复。
  void pauseForBackground() {
    _backgrounded = true;
    // 只取消待执行的重连定时器，不干预现有连接和心跳
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    debugPrint('[ImClient] paused for background, reconnect suspended');
  }

  // ====================== 发送 ======================

  /// 发送 Packet
  void send(proto.Packet packet) {
    if (_socket == null) {
      debugPrint('[ImClient] send failed: not connected, cmd=${Cmd.nameOf(packet.cmd)}');
      return;
    }

    final payload = PacketCodec.encode(packet);
    final frame = FrameCodec.encode(payload);
    _socket!.add(frame);
    debugPrint('[ImClient] sent cmd=${Cmd.nameOf(packet.cmd)}, seq=${packet.sequence}');
  }

  // ====================== 内部连接逻辑 ======================

  Future<void> _doConnect() async {
    if (_disposed) return;

    _setState(ImConnectionState.connecting);
    _readBuffer.clear();

    try {
      _socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 10),
      );

      _setState(ImConnectionState.connected);
      _reconnectAttempts = 0;
      debugPrint('[ImClient] TCP connected to $host:$port');

      // 监听数据
      _socket!.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
      );

      // 发送绑定请求
      final bindReq = PacketCodec.buildBindReq(
        _userId!,
        _token!,
        _device!,
        deviceId: _deviceId,
      );
      send(bindReq);
      debugPrint('[ImClient] sent bind request, userId=$_userId');
    } catch (e) {
      debugPrint('[ImClient] connect failed: $e');
      _handleDisconnect();
    }
  }

  void _onData(Uint8List data) {
    _readBuffer.add(data);

    final buffer = _readBuffer.toBytes();
    int offset = 0;

    // 解码所有可用帧
    while (offset < buffer.length) {
      final result = FrameCodec.decode(buffer, offset);
      if (result == null) break;

      try {
        final packet = PacketCodec.decode(result.payload);
        _handlePacket(packet);
      } catch (e) {
        debugPrint('[ImClient] decode error: $e');
      }

      offset += result.bytesConsumed;
    }

    // 保留未消费的数据
    _readBuffer.clear();
    if (offset < buffer.length) {
      _readBuffer.add(buffer.sublist(offset));
    }
  }

  void _handlePacket(proto.Packet packet) {
    debugPrint('[ImClient] received cmd=${Cmd.nameOf(packet.cmd)}, seq=${packet.sequence}');

    switch (packet.cmd) {
      case Cmd.bindResp:
        _handleBindResponse(packet);
        break;

      case Cmd.kickNotify:
        _handleKickNotify(packet);
        break;

      case Cmd.heartbeatResp:
        _heartbeatManager?.onHeartbeatResponse();
        onPacket?.call(packet);
        break;

      default:
        onPacket?.call(packet);
        break;
    }
  }

  void _handleBindResponse(proto.Packet packet) {
    final resp = PacketCodec.parseBindResponse(packet);

    if (resp.code == 0) {
      _serverId = resp.serverId;
      _setState(ImConnectionState.authenticated);
      debugPrint('[ImClient] bind success, serverId=$_serverId');

      // 启动心跳
      _heartbeatManager?.dispose();
      _heartbeatManager = HeartbeatManager(
        onSend: send,
        onTimeout: _onHeartbeatTimeout,
      );
      _heartbeatManager!.start();
    } else {
      debugPrint('[ImClient] bind failed: code=${resp.code}, msg=${resp.message}');
      onBindFailed?.call(resp.code, resp.message);
      _setState(ImConnectionState.disconnected);
    }
  }

  /// 处理踢人通知（服务端发送后会立即关闭连接）
  void _handleKickNotify(proto.Packet packet) {
    final notify = PacketCodec.parseKickNotify(packet);
    debugPrint('[ImClient] kicked: code=${notify.code}, msg=${notify.message}');

    // 标记被踢，停止一切重连
    _kicked = true;
    _heartbeatManager?.stop();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    // 通知上层
    onKicked?.call(notify.code, notify.message);

    // 断开 socket（服务端会 close，这里提前清理）
    try {
      _socket?.destroy();
    } catch (_) {}
    _socket = null;
    _setState(ImConnectionState.disconnected);
  }

  void _onHeartbeatTimeout() {
    debugPrint('[ImClient] heartbeat timeout, reconnecting...');
    _heartbeatManager?.stop();

    try {
      _socket?.destroy();
    } catch (_) {}
    _socket = null;
    _handleDisconnect();
  }

  void _onError(Object error) {
    debugPrint('[ImClient] socket error: $error');
    _handleDisconnect();
  }

  void _onDone() {
    debugPrint('[ImClient] socket done');
    _handleDisconnect();
  }

  void _handleDisconnect() {
    if (_disposed) return;
    if (_kicked) return; // 被踢后不重连

    _heartbeatManager?.stop();
    _socket = null;

    if (_state == ImConnectionState.disconnected) return;

    // 尝试重连
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;

    if (maxReconnectAttempts != null && _reconnectAttempts >= maxReconnectAttempts!) {
      debugPrint('[ImClient] max reconnect attempts reached');
      _setState(ImConnectionState.disconnected);
      return;
    }

    _setState(ImConnectionState.reconnecting);

    // 后台时使用更长的固定间隔（5分钟），减少电池消耗但仍能自动恢复
    // 前台使用指数退避
    final Duration delay;
    if (_backgrounded) {
      delay = const Duration(minutes: 5);
      debugPrint('[ImClient] backgrounded, reconnecting in 5min (attempt ${_reconnectAttempts + 1})');
    } else {
      delay = Duration(
        milliseconds: (reconnectBaseDelay.inMilliseconds *
                _pow2(_reconnectAttempts))
            .clamp(0, reconnectMaxDelay.inMilliseconds),
      );
      debugPrint('[ImClient] reconnecting in ${delay.inSeconds}s (attempt ${_reconnectAttempts + 1})');
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      _reconnectAttempts++;
      PacketCodec.resetSequence();
      _doConnect();
    });
  }

  void _setState(ImConnectionState newState) {
    if (_state == newState) return;
    _state = newState;
    onStateChanged?.call(newState);
  }

  static int _pow2(int n) => 1 << n.clamp(0, 10);
}
