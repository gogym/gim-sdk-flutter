# GIM IM SDK (Flutter)

[**中文**](README.md) | **English**

A high-performance, production-ready Flutter IM **client** SDK built on **TCP + Protobuf + Varint32 framing**, fully aligned with the [gim-sdk-java](https://github.com/gogym/gim-sdk-java) server protocol. It covers 1:1 chat, group chat, delivery/read/recall, presence, friend & group notifications, heartbeat & auto-reconnect, multi-device kick, and WebRTC 1:1 / group calls (Mesh + SFU).

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

## Introduction

GIM Flutter SDK sinks the common IM client foundation into the library: connection management, Protobuf codec, Varint32 framing, heartbeat keep-alive, exponential-backoff reconnect, foreground/background recovery, multi-device kick, WebRTC signaling state machine and group-call room lifecycle are all built-in. You only need to:

1. Extend [`ImEventListener`](lib/spi/im_event_listener.dart) to handle events;
2. Use [`PacketCodec`](lib/protocol/packet_codec.dart) to build / parse `Packet`s;
3. Connect and send/receive through [`GimImService`](lib/service/gim_im_service.dart).

- **Protocol alignment**: shares `Packet` / `Cmd` / `DeviceType` / `ContentType` with the `gim-sdk-java` server — connect directly with zero adaptation
- **Thin communication layer**: the SDK only handles transport — no DB, conversation storage, unread counters, or UI, with clean boundaries
- **Reliable long connection**: first-packet bind authentication + heartbeat timeout detection + exponential-backoff auto-reconnect + foreground/background adaptation
- **Built-in A/V**: complete 1:1 call state machine and group video Mesh/SFU hybrid architecture; media never travels over the signaling channel
- **Fully open source**: under the **Apache License 2.0**, author **gogym**

---

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                 Integrating App's Business Code               │
│   ImEventListener impl / RtcEngineCallback / UI layer        │
├──────────────────────────────────────────────────────────────┤
│            Service & Event Layer (service / spi)             │
│   GimImService (single public entry)  ·  ImEventListener     │
├──────────────────────────────────────────────────────────────┤
│               Business Capability Layer (rtc)                │
│   RtcEngine (1:1 session state machine)                      │
│   GroupRtcEngine (group call room: Mesh / SFU selection)     │
├──────────────────────────────────────────────────────────────┤
│                Core Communication Layer (core)               │
│   ImClient (TCP connect/reconnect)  ·  HeartbeatManager      │
│   FrameCodec (Varint32 framing)  ·  ImConnectionState        │
├──────────────────────────────────────────────────────────────┤
│            Protocol Layer (protocol / model)                 │
│   Packet / Cmd / ContentType / DeviceType · PacketCodec      │
│   ImConfig (connection config)                               │
└──────────────────────────────────────────────────────────────┘
                              │ TCP Socket
                              ▼
                    GIM IM Server (gim-sdk-java)
```

### Modules

| Directory | Description |
|------|------|
| **lib/protocol** | Protobuf protocol definitions and codec: `Packet`, `Cmd`, `ContentType`, `DeviceType`, `PacketCodec` (`ImProto.pb*.dart` are protoc-generated) |
| **lib/core** | Core communication engine: `ImClient` TCP connection/reconnect, `FrameCodec` Varint32 framing, `HeartbeatManager`, `ImConnectionState` state machine |
| **lib/service** | `GimImService`: the single public service entry for connection, sending, and event dispatch |
| **lib/spi** | `ImEventListener`: event listener base class, override as needed |
| **lib/model** | `ImConfig`: connection, heartbeat, and reconnect configuration |
| **lib/rtc** | WebRTC capabilities: `RtcEngine` (1:1), `rtc/group` (group calls Mesh + SFU) |

---

## Features

### 1. Unified envelope aligned with the Java server (Packet + Cmd)

All messages use a unified Protobuf binary envelope `Packet`: `cmd + sequence + requestId + timestamp + body`. Business semantics live in `body` and are deserialized per cmd into the corresponding message (`ChatMessage`, `ServerAck`, `RtcSignal`, `RtcGroup`, etc.).

| cmd range | Purpose |
|---------|------|
| 1 ~ 9 | Connection management: BIND_REQ / BIND_RESP / HEARTBEAT / KICK_NOTIFY |
| 10 ~ 19 | Chat messages: 1:1 / group / SERVER_ACK / DELIVERY_ACK / READ_RECEIPT / MSG_RECALL |
| 20 ~ 29 | Presence: ONLINE_STATUS_NOTIFY |
| 30 ~ 39 | Friend notifications: FRIEND_REQUEST / FRIEND_STATUS |
| 40 ~ 49 | Group notifications: GROUP_MEMBER / GROUP / GROUP_JOIN_REQUEST |
| 50 ~ 59 | WebRTC signaling: RTC_SIGNAL (1:1 / Mesh media) / RTC_GROUP (group lifecycle) |

**Why a unified envelope?** Routing and the protocol layer only care about `cmd` and never need to understand the business body; adding new semantics only requires a new cmd + message, with zero changes to the SDK core.

### 2. Thin communication layer, zero business coupling

The SDK only does transport: it doesn't manage conversation lists, persist to DB, generate UUIDs, or render UI. All of that is left to the integrator, keeping boundaries clean and easy to extend. You build `Packet`s via [PacketCodec](lib/protocol/packet_codec.dart) and send them through the single exit [`GimImService.send`](lib/service/gim_im_service.dart); received `Packet`s are automatically routed by `cmd` to the matching `ImEventListener` callback.

### 3. Reliable long connection

- **First-packet bind authentication**: right after the TCP handshake a `BindRequest` is sent; once the server returns `BindResponse` (`code=0`) the state becomes `authenticated` and send/receive is allowed.
- **Heartbeat & timeout**: [`HeartbeatManager`](lib/core/heartbeat_manager.dart) sends heartbeats periodically; a missing response within the timeout is treated as a disconnect and triggers reconnection.
- **Exponential-backoff reconnect**: in the foreground it backs off as `reconnectBaseDelay × 2^attempts` (capped at `reconnectMaxDelay`); in the background it drops to a fixed 5-minute interval to save battery.
- **Foreground/background adaptation**: on entering background [`pauseForBackground`](lib/core/im_client.dart) pauses reconnecting (without actively dropping live connections); on returning to foreground [`reconnectIfNeeded`](lib/core/im_client.dart) recovers immediately.
- **Multi-device kick**: after receiving `KickNotify` (e.g. code=409, a different device taking over), all reconnection stops and re-login is left to the business layer.

### 4. Messaging: 1:1 chat · group chat · recall · read receipts

- **1:1 / group chat**: `buildSingleChatMsg` (`chatType=1`) / `buildGroupChatMsg` (`chatType=2`), with optional `conversationId` and `ext` fields.
- **Server ACK**: `ServerAck` (cmd=12) returns the authoritative `serverMsgId`; clients match idempotently by `requestId`.
- **Delivery / read**: `DeliveryAck` (cmd=13), `ReadReceipt` (cmd=14); for 1:1 read receipts `receiverId` is required and the server forwards directly.
- **Recall**: `MsgRecallRequest` (cmd=15) → the server pushes `MsgRecallNotify` (cmd=16), triggering `onMessageRecalled`.

### 5. WebRTC calls: 1:1 + group video (Mesh + SFU)

The SDK embeds a complete RTC signaling state machine and media management. Media never travels over the IM signaling channel — signaling only carries SDP / ICE / lifecycle events. You receive events via [`RtcEngineCallback`](lib/rtc/rtc_engine.dart) / [`GroupRtcEngineCallback`](lib/rtc/group/group_rtc_engine.dart) and own the UI, permissions, and call records.

| Feature | 1:1 call (`RtcEngine`) | Group call (`GroupRtcEngine`) |
|------|------------------------|-------------------------------|
| Session/room | Single PeerConnection state machine | Member snapshot + transport layer (Mesh/SFU factory) |
| Busy exclusion | ✅ Ignores new incoming during a call | ✅ Ignores invites when not idle |
| Server-side callId | Returned to caller via `CALL_ACK=9` | Client generates UUID, server reuses it |
| Connect timeout | connecting times out at 30s, closes as failed | Same, actively leaves and notifies other members |
| Drop linkage | PeerConnection failed → `callHangup(reason=failed)` to peer | Member leaving auto-closes connection / removes media |
| Media mode | P2P direct | **Mesh** (full P2P, ≤8 people) / **SFU** (LiveKit, 20+ people) |
| Media toggles | `toggleCamera/toggleMicrophone` + `mediaState` broadcast | Same, aggregated server-side into `participantNotify` |

Signaling numbering (`Cmd` and `signalType`):

```
Cmd=50 (RTC_SIGNAL)     1:1 chat signaling / group Mesh point-to-point media signaling
Cmd=51 (RTC_GROUP)      Group video lifecycle signaling
signalType 1~8          Generic media signaling: offer / answer / ice / callRequest / Accept / Reject / Cancel / Hangup
signalType 9            callAck (server → caller, fills in callId)
signalType 20~27        Group call lifecycle: groupCallRequest / Invite / Join / Reject / Leave / End / participantNotify / roomState
signalType 100          mediaState (camera/mic toggle, shared by 1:1 and group)
```

---

## Quick Start

### 1. Add the dependency (`pubspec.yaml`)

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

### 2. Connect and send/receive

```dart
import 'package:gim_sdk_flutter/gim_im_sdk.dart';

// 1. Create the service instance
final service = GimImService();

// 2. Register an event listener
service.addEventListener(MyImEventListener());

// 3. Connect and bind-authenticate
await service.connect(ImConfig(
  host: '192.168.1.100',
  port: 3333,
  userId: 'user_001',
  token: 'jwt_token',              // JWT signed by your business server
  device: DeviceType.mobile.value,
  deviceId: 'persisted-uuid',      // client-persisted unique device ID
));

// 4. Send a 1:1 chat message
final packet = PacketCodec.buildSingleChatMsg(
  requestId: 'req-uuid-001',
  senderId: 'user_001',
  receiverId: 'user_002',
  contentType: ContentType.text.value,
  content: 'Hello GIM!',
);
service.send(packet);

// Disconnect
await service.disconnect();
```

### 3. Implement the event listener

```dart
class MyImEventListener extends ImEventListener {
  @override
  void onMessageReceived(Packet packet) {
    final msg = PacketCodec.parseChatMessage(packet);
    debugPrint('Message received [${msg.senderId}]: ${msg.content}');
    // TODO: persist / update UI / send delivery ACK
  }

  @override
  void onKicked(int code, String message) {
    // TODO: account logged in on another device, guide re-login
  }
}
```

> For a complete integration sample see [`docs/SDK接入文档.md`](docs/SDK接入文档.md) and the [Wiki Quick Start](https://github.com/gogym/gim-sdk-flutter/wiki/Quick-Start).

---

## Documentation

Full documentation is published on the GitHub Wiki ([中文](https://github.com/gogym/gim-sdk-flutter/wiki/Home) | [English](https://github.com/gogym/gim-sdk-flutter/wiki/Home-EN)):

| 中文 | English |
|------|---------|
| [Wiki 首页](https://github.com/gogym/gim-sdk-flutter/wiki/Home) | [Wiki Home](https://github.com/gogym/gim-sdk-flutter/wiki/Home-EN) |
| [快速开始](https://github.com/gogym/gim-sdk-flutter/wiki/快速开始) | [Quick Start](https://github.com/gogym/gim-sdk-flutter/wiki/Quick-Start) |
| [架构概览](https://github.com/gogym/gim-sdk-flutter/wiki/架构概览) | [Architecture Overview](https://github.com/gogym/gim-sdk-flutter/wiki/Architecture-Overview) |
| [核心概念：Packet 与协议编解码](https://github.com/gogym/gim-sdk-flutter/wiki/核心概念：Packet与协议编解码) | [Core Concept: Packet & Codec](https://github.com/gogym/gim-sdk-flutter/wiki/Core-Concept-Packet-and-Codec) |
| [核心概念：连接与认证](https://github.com/gogym/gim-sdk-flutter/wiki/核心概念：连接与认证) | [Core Concept: Connection & Auth](https://github.com/gogym/gim-sdk-flutter/wiki/Core-Concept-Connection-and-Auth) |
| [核心概念：事件监听](https://github.com/gogym/gim-sdk-flutter/wiki/核心概念：事件监听) | [Core Concept: Event Listener](https://github.com/gogym/gim-sdk-flutter/wiki/Core-Concept-Event-Listener) |
| [消息能力：单聊与群聊](https://github.com/gogym/gim-sdk-flutter/wiki/消息能力：单聊与群聊) | [Messaging: 1:1 & Group Chat](https://github.com/gogym/gim-sdk-flutter/wiki/Messaging-Single-and-Group-Chat) |
| [消息能力：心跳与自动重连](https://github.com/gogym/gim-sdk-flutter/wiki/消息能力：心跳与自动重连) | [Messaging: Heartbeat & Auto-Reconnect](https://github.com/gogym/gim-sdk-flutter/wiki/Messaging-Heartbeat-and-Auto-Reconnect) |
| [消息能力：撤回、已读与在线状态](https://github.com/gogym/gim-sdk-flutter/wiki/消息能力：撤回、已读与在线状态) | [Messaging: Recall, Read & Presence](https://github.com/gogym/gim-sdk-flutter/wiki/Messaging-Recall-Read-Online-Status) |
| [WebRTC：1:1 通话](https://github.com/gogym/gim-sdk-flutter/wiki/WebRTC：1对1通话) | [WebRTC: 1:1 Call](https://github.com/gogym/gim-sdk-flutter/wiki/WebRTC-One-to-One-Call) |
| [WebRTC：群视频通话](https://github.com/gogym/gim-sdk-flutter/wiki/WebRTC：群视频通话) | [WebRTC: Group Video Call](https://github.com/gogym/gim-sdk-flutter/wiki/WebRTC-Group-Video-Call) |
| [配置参考：ImConfig](https://github.com/gogym/gim-sdk-flutter/wiki/配置参考：ImConfig) | [Config Reference: ImConfig](https://github.com/gogym/gim-sdk-flutter/wiki/Configuration-Reference-ImConfig) |
| [前后台与生命周期](https://github.com/gogym/gim-sdk-flutter/wiki/前后台与生命周期) | [Lifecycle: Background & Foreground](https://github.com/gogym/gim-sdk-flutter/wiki/Background-and-Foreground-Lifecycle) |

---

## Build

```bash
# Fetch dependencies
flutter pub get

# Static analysis
flutter analyze

# Run unit tests (group-call signaling codec / DTO compatibility)
flutter test
```

> `lib/protocol/ImProto.pb*.dart` are generated from `ImProto.proto` (see the gim-sdk-java protocol module) via `protoc --dart_out` — never edit them manually.

---

## Why This SDK

1. **Flutter IM clients repeat a lot of work**: TCP framing, Protobuf codec, heartbeat/reconnect, foreground/background recovery, multi-device kick — every app steps into the same traps.
2. **Naturally aligned with your own server**: the protocol directly reuses gim-sdk-java's `Packet/Cmd`, zero client adaptation cost.
3. **A/V signaling state machines are complex**: 1:1 and group call offer/answer/ICE, timeout cleanup, drop linkage, Mesh/SFU switching are highly templated — let the SDK handle them.
4. **Readability first, clean boundaries**: split into communication / business / protocol layers, no file over a thousand lines, comment density on par with mainstream open-source projects — easy to extend and to teach from.

---

## Bug Reports & Suggestions

- [GitHub Issues](https://github.com/gogym/gim-sdk-flutter/issues)

---

## License

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

Full terms in the project root [LICENSE](LICENSE). Every source file starts with the Apache 2.0 header and author declaration.

---

## Author

**gogym**

- GitHub: <https://github.com/gogym>
- Email: <189155278@qq.com>
