# GIM IM SDK (Flutter)

[**中文**](README.md) | [English](README.en.md)

高性能、开箱即用的 **Flutter IM 即时通讯客户端 SDK**，基于 **TCP + Protobuf + Varint32 帧编码** 构建，与 [gim-sdk-java](https://github.com/gogym/gim-sdk-java) 服务端协议完全对齐，覆盖单聊、群聊、送达/已读/撤回、在线状态、好友/群组通知、心跳重连、多端互踢、WebRTC 1:1 通话与群视频（Mesh + SFU）等能力。

A high-performance, production-ready Flutter IM **client** SDK built on **TCP + Protobuf**, aligned with the `gim-sdk-java` server. It covers 1:1 chat, group chat, delivery/read/recall, presence, friend & group notifications, heartbeat & auto-reconnect, multi-device kick, and WebRTC 1:1 / group calls (Mesh + SFU).

---

Copyright 2026 gogym

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

---

## 简介 / Brief Introduction

GIM Flutter SDK 把 IM **客户端**的通用底座沉淀到 SDK 内部：长连接管理、Protobuf 编解码、Varint32 分帧、心跳保活、指数退避重连、前后台恢复、多端互踢、WebRTC 信令状态机与群通话房间生命周期都开箱即用。业务方只需：

1. 继承 [`ImEventListener`](lib/spi/im_event_listener.dart) 处理事件；
2. 用 [`PacketCodec`](lib/protocol/packet_codec.dart) 构建 / 解析 `Packet`；
3. 通过 [`GimImService`](lib/service/gim_im_service.dart) 连接与收发。

GIM Flutter SDK sinks the common IM client foundation into the library: connection management, Protobuf codec, Varint32 framing, heartbeat, exponential-backoff reconnect, foreground/background recovery, multi-device kick, WebRTC signaling state machine and group-call room lifecycle are all built-in. You only handle events, build/parse `Packet`s, and connect through `GimImService`.

- **协议对齐**：与 `gim-sdk-java` 服务端共用 `Packet` / `Cmd` / `DeviceType` / `ContentType`，零改造直连
- **薄壳通信层**：SDK 只负责通信，不含 DB、会话存储、未读数、UI 等业务逻辑，边界清晰
- **可靠长连接**：首包绑定认证 + 心跳超时检测 + 指数退避自动重连 + 前后台适配
- **音视频一体**：内置 1:1 通话状态机与群视频 Mesh/SFU 混合架构，媒体不经信令通道
- **完全开源**：基于 **Apache License 2.0** 协议，作者 **gogym**

---

## 整体架构 / Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     接入方 App 业务代码                        │
│   ImEventListener 实现 / RtcEngineCallback / UI 层           │
├──────────────────────────────────────────────────────────────┤
│                  服务与事件层（service / spi）                 │
│   GimImService（对外唯一入口）  ·  ImEventListener（事件回调） │
├──────────────────────────────────────────────────────────────┤
│                  业务能力层（rtc）                             │
│   RtcEngine（1:1 会话状态机）                                │
│   GroupRtcEngine（群通话房间：Mesh / SFU 策略选择）          │
├──────────────────────────────────────────────────────────────┤
│                  核心通信层（core）                           │
│   ImClient（TCP 连接/重连）  ·  HeartbeatManager（心跳）      │
│   FrameCodec（Varint32 分帧）  ·  ImConnectionState（状态机）│
├──────────────────────────────────────────────────────────────┤
│                  协议层（protocol / model）                    │
│   Packet / Cmd / ContentType / DeviceType · PacketCodec      │
│   ImConfig（连接配置）                                        │
└──────────────────────────────────────────────────────────────┘
                              │ TCP Socket
                              ▼
                    GIM IM Server（gim-sdk-java）
```

### 模块组成 / Modules

| 目录 | 说明 |
|------|------|
| **lib/protocol** | Protobuf 协议定义与编解码：`Packet`、`Cmd`、`ContentType`、`DeviceType`、`PacketCodec`（`ImProto.pb*.dart` 为 protoc 生成） |
| **lib/core** | 核心通信引擎：`ImClient` TCP 连接/重连、`FrameCodec` Varint32 分帧、`HeartbeatManager` 心跳、`ImConnectionState` 状态机 |
| **lib/service** | `GimImService`：对外唯一服务入口，负责连接、发送与事件分发 |
| **lib/spi** | `ImEventListener`：事件监听基类，接入方按需覆盖 |
| **lib/model** | `ImConfig`：连接与心跳/重连配置 |
| **lib/rtc** | WebRTC 能力：`RtcEngine`（1:1）、`rtc/group`（群通话 Mesh + SFU） |

---

## GIM 的特点 / Features

### 一. 与 Java 服务端对齐的统一信封（Packet + Cmd）

所有消息使用统一的 Protobuf 二进制信封 `Packet`：`cmd + sequence + requestId + timestamp + body`。业务语义放在 `body` 里，按 cmd 反序列化为对应 message（`ChatMessage`、`ServerAck`、`RtcSignal`、`RtcGroup` 等）。

| cmd 号段 | 用途 |
|---------|------|
| 1 ~ 9 | 连接管理：BIND_REQ / BIND_RESP / HEARTBEAT / KICK_NOTIFY |
| 10 ~ 19 | 聊天消息：单聊 / 群聊 / SERVER_ACK / DELIVERY_ACK / READ_RECEIPT / MSG_RECALL |
| 20 ~ 29 | 在线状态：ONLINE_STATUS_NOTIFY |
| 30 ~ 39 | 好友通知：FRIEND_REQUEST / FRIEND_STATUS |
| 40 ~ 49 | 群组通知：GROUP_MEMBER / GROUP / GROUP_JOIN_REQUEST |
| 50 ~ 59 | WebRTC 信令：RTC_SIGNAL（1:1 / Mesh 媒体） / RTC_GROUP（群生命周期） |

**为什么用统一信封？** 路由与协议层只关心 `cmd`，无需理解业务 body；扩展新语义只需增一个 cmd + message，SDK 内核零改动。

### 二. 薄壳通信层，业务零耦合

SDK 只做通信：不管理会话列表、不落库、不生成 UUID、不画 UI。这些全部交给接入方，边界清晰、易于二开。接入方通过 [PacketCodec](lib/protocol/packet_codec.dart) 构建 `Packet` 后经唯一出口 [`GimImService.send`](lib/service/gim_im_service.dart) 发送；收到的 `Packet` 由 SDK 按 `cmd` 自动路由到 `ImEventListener` 对应回调。

### 三. 可靠的长连接

- **首包绑定认证**：TCP 建连后立即发送 `BindRequest`，服务端返回 `BindResponse`（`code=0`）后进入 `authenticated`，方可收发。
- **心跳与超时**：[`HeartbeatManager`](lib/core/heartbeat_manager.dart) 定时发送心跳，超时未收到响应即判定断线并触发重连。
- **指数退避重连**：前台按 `reconnectBaseDelay × 2^attempts`（上限 `reconnectMaxDelay`）退避重连；后台降为固定 5 分钟间隔省电。
- **前后台适配**：进入后台 [`pauseForBackground`](lib/core/im_client.dart) 暂停重连（不主动断开存活连接），回到前台 [`reconnectIfNeeded`](lib/core/im_client.dart) 立即恢复。
- **多端互踢**：收到 `KickNotify`（如 code=409 异设备顶号）后停止一切重连，交由业务重新登录。

### 四. 消息能力：单聊 · 群聊 · 撤回 · 已读

- **单聊 / 群聊**：`buildSingleChatMsg`（`chatType=1`）/ `buildGroupChatMsg`（`chatType=2`），支持 `conversationId`、`ext` 扩展字段。
- **服务端 ACK**：`ServerAck`（cmd=12）回执 `serverMsgId`，客户端按 `requestId` 幂等匹配。
- **送达 / 已读**：`DeliveryAck`（cmd=13）、`ReadReceipt`（cmd=14），单聊已读必传 `receiverId` 由服务端直接转发。
- **撤回**：`MsgRecallRequest`（cmd=15）→ 服务端下发 `MsgRecallNotify`（cmd=16）触发 `onMessageRecalled`。

### 五. WebRTC 通话：1:1 + 群视频（Mesh + SFU）

SDK 内置完整的 RTC 信令状态机与媒体管理，媒体不经 IM 信令通道，信令仅承载 SDP / ICE / 生命周期。业务方通过 [`RtcEngineCallback`](lib/rtc/rtc_engine.dart) / [`GroupRtcEngineCallback`](lib/rtc/group/group_rtc_engine.dart) 接收事件，并负责 UI、权限与通话记录。

| 特性 | 1:1 通话（`RtcEngine`） | 群视频通话（`GroupRtcEngine`） |
|------|------------------------|-------------------------------|
| 会话/房间 | 单 PeerConnection 状态机 | 成员快照 + 传输层（Mesh/SFU 工厂） |
| 忙线互斥 | ✅ 通话中忽略新来电 | ✅ 非空闲忽略邀请 |
| 服务端 callId | `CALL_ACK=9` 回传主叫 | 客户端生成 UUID，服务端沿用 |
| 建联超时 | connecting 30s 超时以 failed 收口 | 同左，主动 leave 通知其他成员 |
| 掉线联动 | PeerConnection failed → 对端 `callHangup(reason=failed)` | 成员离开自动关连接/移除媒体 |
| 媒体模式 | P2P 直连 | **Mesh**（P2P 全连接，≤8 人）/ **SFU**（LiveKit，20+ 人） |
| 媒体开关 | `toggleCamera/toggleMicrophone` + `mediaState` 广播 | 同左，经服务端聚合 `participantNotify` |

信令编号约定（`Cmd` 与 `signalType`）：

```
Cmd=50 (RTC_SIGNAL)     1:1 单聊信令 / 群 Mesh 点对点媒体信令
Cmd=51 (RTC_GROUP)      群视频生命周期信令
signalType 1~8          通用媒体信令：offer / answer / ice / callRequest / Accept / Reject / Cancel / Hangup
signalType 9            callAck（服务端 → 主叫，回填 callId）
signalType 20~27        群通话生命周期：groupCallRequest / Invite / Join / Reject / Leave / End / participantNotify / roomState
signalType 100          mediaState（摄像头/麦克风开关，1:1 与群共用）
```

---

## 快速开始 / Quick Start

### 1. 引入依赖（`pubspec.yaml`）

```yaml
dependencies:
  gim_sdk_flutter:
    git:
      url: https://github.com/gogym/gim-sdk-flutter.git
      ref: main
```

```bash
flutter pub get
```

### 2. 连接并收发

```dart
import 'package:gim_sdk_flutter/gim_im_sdk.dart';

// 1. 创建服务实例
final service = GimImService();

// 2. 注册事件监听
service.addEventListener(MyImEventListener());

// 3. 连接并绑定认证
await service.connect(ImConfig(
  host: '192.168.1.100',
  port: 3333,
  userId: 'user_001',
  token: 'jwt_token',              // 由业务服务端签发的 JWT
  device: DeviceType.mobile.value,
  deviceId: 'persisted-uuid',      // 客户端持久化的设备唯一标识
));

// 4. 发送单聊消息
final packet = PacketCodec.buildSingleChatMsg(
  requestId: 'req-uuid-001',
  senderId: 'user_001',
  receiverId: 'user_002',
  contentType: ContentType.text.value,
  content: 'Hello GIM!',
);
service.send(packet);

// 断开连接
await service.disconnect();
```

### 3. 实现事件监听

```dart
class MyImEventListener extends ImEventListener {
  @override
  void onMessageReceived(Packet packet) {
    final msg = PacketCodec.parseChatMessage(packet);
    debugPrint('收到消息 [${msg.senderId}]: ${msg.content}');
    // TODO: 存库 / 更新 UI / 发送送达 ACK
  }

  @override
  void onKicked(int code, String message) {
    // TODO: 账号在其他设备登录，引导重新登录
  }
}
```

> 完整接入示例见 [`docs/SDK接入文档.md`](docs/SDK接入文档.md) 与 [Wiki 快速开始](https://github.com/gogym/gim-sdk-flutter/wiki/快速开始)。

---

## 文档索引 / Documentation

完整文档已发布到 GitHub Wiki（[中文](https://github.com/gogym/gim-sdk-flutter/wiki/Home) | [English](https://github.com/gogym/gim-sdk-flutter/wiki/Home-EN)）：

- [Wiki 首页](https://github.com/gogym/gim-sdk-flutter/wiki/Home)
- [快速开始](https://github.com/gogym/gim-sdk-flutter/wiki/快速开始)
- [架构概览](https://github.com/gogym/gim-sdk-flutter/wiki/架构概览)
- [核心概念：Packet 与协议编解码](https://github.com/gogym/gim-sdk-flutter/wiki/核心概念：Packet与协议编解码)
- [核心概念：连接与认证](https://github.com/gogym/gim-sdk-flutter/wiki/核心概念：连接与认证)
- [核心概念：事件监听（ImEventListener）](https://github.com/gogym/gim-sdk-flutter/wiki/核心概念：事件监听)
- [消息能力：单聊与群聊](https://github.com/gogym/gim-sdk-flutter/wiki/消息能力：单聊与群聊)
- [消息能力：心跳与自动重连](https://github.com/gogym/gim-sdk-flutter/wiki/消息能力：心跳与自动重连)
- [消息能力：撤回、已读与在线状态](https://github.com/gogym/gim-sdk-flutter/wiki/消息能力：撤回、已读与在线状态)
- [WebRTC：1:1 通话](https://github.com/gogym/gim-sdk-flutter/wiki/WebRTC：1对1通话)
- [WebRTC：群视频通话（Mesh + SFU）](https://github.com/gogym/gim-sdk-flutter/wiki/WebRTC：群视频通话)
- [配置参考：ImConfig](https://github.com/gogym/gim-sdk-flutter/wiki/配置参考：ImConfig)
- [前后台与生命周期](https://github.com/gogym/gim-sdk-flutter/wiki/前后台与生命周期)

---

## 构建 / Build

```bash
# 拉取依赖
flutter pub get

# 静态分析
flutter analyze

# 运行单元测试（群通话信令编解码 / DTO 兼容性）
flutter test
```

> `lib/protocol/ImProto.pb*.dart` 由 `ImProto.proto`（见 gim-sdk-java 协议模块）经 `protoc --dart_out` 生成，无需手动编辑。

---

## 为什么写这个 SDK / Why GIM

1. **Flutter IM 客户端重复劳动多**：TCP 分帧、Protobuf 编解码、心跳重连、前后台恢复、多端互踢，每个 App 都要重踩一遍。
2. **与自有服务端天然对齐**：协议直接复用 gim-sdk-java 的 `Packet/Cmd`，客户端零适配成本。
3. **音视频信令状态机复杂**：1:1 与群通话的 offer/answer/ICE、超时清理、掉线联动、Mesh/SFU 切换高度模板化，交给 SDK。
4. **可读优先、边界清晰**：按通信层 / 业务层 / 协议层拆分，单文件不超过千行，注释密度对齐主流开源项目，方便二开与教学。

---

## Bug 反馈与建议 / Issues

- [GitHub Issues](https://github.com/gogym/gim-sdk-flutter/issues)

---

## 许可证 / License

```
Copyright 2026 gogym

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

完整条款见项目根目录 [LICENSE](LICENSE)。每个源码文件顶部均包含 Apache 2.0 协议头与作者声明。

---

## 作者 / Author

**gogym**

- GitHub：<https://github.com/gogym>
- Email：<189155278@qq.com>
