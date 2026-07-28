import 'dart:async';

import 'package:flutter/foundation.dart';

import '../protocol/ImProto.pb.dart' as proto;
import '../protocol/packet_codec.dart';

/// 心跳管理器
/// 负责定时发送心跳 + 超时检测
class HeartbeatManager {
  /// 心跳间隔（默认 30 秒）
  final Duration interval;

  /// 超时时间（默认 10 秒，超过此时间未收到心跳响应则判定超时）
  final Duration timeout;

  /// 发送回调
  final void Function(proto.Packet packet) onSend;

  /// 超时回调
  final VoidCallback onTimeout;

  Timer? _heartbeatTimer;
  Timer? _timeoutTimer;
  bool _disposed = false;

  HeartbeatManager({
    this.interval = const Duration(seconds: 30),
    this.timeout = const Duration(seconds: 10),
    required this.onSend,
    required this.onTimeout,
  });

  /// 启动心跳
  void start() {
    stop();
    _disposed = false;
    _scheduleNext();
    debugPrint('[HeartbeatManager] started, interval=${interval.inSeconds}s');
  }

  /// 停止心跳
  void stop() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  /// 释放资源
  void dispose() {
    _disposed = true;
    stop();
  }

  /// 收到心跳响应（重置超时计时器）
  void onHeartbeatResponse() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    _scheduleNext();
  }

  void _scheduleNext() {
    if (_disposed) return;

    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer(interval, _sendHeartbeat);
  }

  void _sendHeartbeat() {
    if (_disposed) return;

    final packet = PacketCodec.buildHeartbeatReq();
    onSend(packet);
    debugPrint('[HeartbeatManager] sent heartbeat');

    // 启动超时检测
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(timeout, () {
      if (!_disposed) {
        debugPrint('[HeartbeatManager] timeout!');
        onTimeout();
      }
    });

    // 安排下一次心跳
    _scheduleNext();
  }
}
