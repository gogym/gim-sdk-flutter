// Copyright 2026 gogym
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// SDK 配置
///
/// 包含连接 IM 服务器所需的全部参数
class ImConfig {
  /// IM 服务器地址
  final String host;

  /// IM 服务器端口
  final int port;

  /// 当前用户 ID
  final String userId;

  /// 认证 Token
  final String token;

  /// 设备类型（mobile/desktop/web/pad）
  final String device;

  /// 设备唯一标识（客户端持久化UUID），用于区分同设备重连与异设备顶号
  final String? deviceId;

  /// 心跳间隔（默认 30 秒）
  final Duration heartbeatInterval;

  /// 心跳超时（默认 10 秒）
  final Duration heartbeatTimeout;

  /// 重连基础间隔（默认 2 秒）
  final Duration reconnectBaseDelay;

  /// 最大重连间隔（默认 60 秒）
  final Duration reconnectMaxDelay;

  /// 最大重连次数（null=无限）
  final int? maxReconnectAttempts;

  const ImConfig({
    required this.host,
    required this.port,
    required this.userId,
    required this.token,
    required this.device,
    this.deviceId,
    this.heartbeatInterval = const Duration(seconds: 30),
    this.heartbeatTimeout = const Duration(seconds: 10),
    this.reconnectBaseDelay = const Duration(seconds: 2),
    this.reconnectMaxDelay = const Duration(seconds: 60),
    this.maxReconnectAttempts,
  });
}
