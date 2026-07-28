/// RTC 通话相关类型定义
///
/// 包含通话类型、通话状态、信令类型、通话结束原因等枚举和常量。
/// 供 SDK 内部和项目层共同使用。

/// 通话类型
enum RtcCallType { audio, video }

/// 通话状态
enum RtcCallState {
  idle,       // 空闲
  calling,    // 正在呼叫（发起方）
  ringing,    // 来电响铃（接收方）
  connecting, // 连接中（WebRTC 正在协商）
  connected,  // 通话中
  ended,      // 已结束
}

/// RTC 信令类型（signalType 字段值）
///
/// 与 ImProto.proto 中 RtcSignal 注释保持一致：
/// 1=offer, 2=answer, 3=iceCandidate,
/// 4=callRequest, 5=callAccept, 6=callReject, 7=callCancel, 8=callHangup
class RtcSignalType {
  static const int offer = 1;
  static const int answer = 2;
  static const int iceCandidate = 3;
  static const int callRequest = 4;     // 发起通话请求
  static const int callAccept = 5;      // 接听
  static const int callReject = 6;      // 拒绝
  static const int callCancel = 7;      // 取消呼叫
  static const int callHangup = 8;      // 挂断
}

/// 通话结束原因
enum RtcCallEndReason {
  none,       // 无（通话未结束）
  normal,     // 正常挂断
  rejected,   // 对方拒绝
  cancelled,  // 对方取消
  busy,       // 对方忙线
  timeout,    // 无人接听
  failed,     // 连接失败
}
