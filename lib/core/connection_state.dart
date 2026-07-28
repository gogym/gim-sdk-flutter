/// 连接状态枚举
///
/// 表示 IM 客户端的 TCP 连接生命周期各阶段
enum ImConnectionState {
  /// 未连接
  disconnected,

  /// 连接中
  connecting,

  /// TCP 已连接
  connected,

  /// 绑定成功（认证通过）
  authenticated,

  /// 重连中
  reconnecting,
}
