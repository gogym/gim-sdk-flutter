/// GIM IM SDK — Flutter 即时通讯核心能力 SDK
///
/// 基于 TCP + Protobuf + Varint32 帧编码
/// 提供连接管理、消息收发、事件监听等核心能力
///
/// 使用方只需：
/// 1. 继承 [ImEventListener] 实现事件处理
/// 2. 创建 [GimImService] 并注册监听器
/// 3. 调用 [GimImService.connect] 建立连接
/// 4. 通过 [PacketCodec] 构建 Packet 后调用 [GimImService.send] 发送
library gim_sdk_flutter;

// protocol 层
export 'protocol/ImProto.pb.dart';
export 'protocol/cmd.dart';
export 'protocol/content_type.dart';
export 'protocol/device_type.dart';
export 'protocol/packet_codec.dart';

// core 层
export 'core/connection_state.dart';
export 'core/frame_codec.dart';
export 'core/heartbeat_manager.dart';
export 'core/im_client.dart';

// spi 层
export 'spi/im_event_listener.dart';

// model 层
export 'model/im_config.dart';

// service 层
export 'service/gim_im_service.dart';

// rtc 层
export 'rtc/rtc_types.dart';
export 'rtc/rtc_engine.dart';

// rtc 群通话层
// 注意：SFU 模式对外暴露 LiveKit 的 VideoTrack/VideoTrackRenderer 渲染类型，
// 使用方无需直接依赖 livekit_client
export 'package:livekit_client/livekit_client.dart'
    show VideoTrack, VideoTrackRenderer, VideoViewMirrorMode;

export 'rtc/group/group_rtc_types.dart';
export 'rtc/group/group_rtc_dto.dart';
export 'rtc/group/group_media_transport.dart';
export 'rtc/group/group_rtc_engine.dart';
