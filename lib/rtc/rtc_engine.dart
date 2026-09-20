import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import '../protocol/ImProto.pb.dart' as proto;
import '../protocol/cmd.dart';
import '../protocol/packet_codec.dart';
import 'rtc_types.dart';

/// RTC 引擎回调接口
///
/// 项目层实现此接口以响应引擎事件：
/// - [onSendSignal] — 引擎需要发送信令时触发，项目层负责通过 IM 通道发出
/// - [onCallStateChanged] — 通话状态变更通知
/// - [onCallEnded] — 通话结束通知（含结束原因）
/// - [onRemoteStreamReceived] — 远端媒体流到达
/// - [onLocalStreamReady] — 本地媒体流就绪（getUserMedia 完成后触发）
/// - [onCallDurationTick] — 每秒通话计时
/// - [onIncomingCall] — 收到来电（被叫方，需展示来电 UI）
/// - [onRemoteMediaStateChanged] — 远端摄像头/麦克风开关变化（用于对端 UI 提示）
class RtcEngineCallback {
  /// 引擎需要发送信令包（项目层通过 IM 通道发送 [packet]）
  final void Function(proto.Packet packet) onSendSignal;

  /// 通话状态变更
  final void Function(RtcCallState state) onCallStateChanged;

  /// 通话结束（含结束原因）
  final void Function(RtcCallEndReason reason) onCallEnded;

  /// 远端媒体流到达
  final void Function(webrtc.MediaStream stream) onRemoteStreamReceived;

  /// 本地媒体流就绪（getUserMedia 完成后触发，供项目层绑定本地预览）
  final void Function(webrtc.MediaStream stream) onLocalStreamReady;

  /// 每秒通话计时（[seconds] 为已通话秒数）
  final void Function(int seconds) onCallDurationTick;

  /// 收到来电（[senderId] 来电方，[callId] 通话ID）
  final void Function(String senderId, String callId) onIncomingCall;

  /// 远端媒体开关状态变更（对端切换摄像头/麦克风）
  ///
  /// 参数为 null 表示该项本次未变化，保留原状态；与 Android SDK 协议一致。
  final void Function(bool? cameraEnabled, bool? micEnabled) onRemoteMediaStateChanged;

  RtcEngineCallback({
    required this.onSendSignal,
    required this.onCallStateChanged,
    required this.onCallEnded,
    required this.onRemoteStreamReceived,
    required this.onLocalStreamReady,
    required this.onCallDurationTick,
    required this.onIncomingCall,
    required this.onRemoteMediaStateChanged,
  });
}

/// RTC 引擎 — WebRTC 通话核心能力
///
/// 封装完整的 WebRTC 信令流程（标准 offer/answer 模型）：
/// 1. 主叫 → callRequest → 服务端 → callRequest(+callId) → 被叫
/// 2. 被叫 → callAccept(+callId) → 服务端 → callAccept(+callId) → 主叫
/// 3. 主叫创建 PeerConnection → createOffer → offer → 被叫
/// 4. 被叫创建 PeerConnection → setRemoteDescription(offer) → createAnswer → answer → 主叫
/// 5. 主叫 setRemoteDescription(answer) → 连接建立
/// 6. 双方交换 ICE candidate
///
/// 使用方通过 [RtcEngineCallback] 接收事件，负责：
/// - 信令发送（通过 IM 通道）
/// - UI 导航（来电页面、通话页面）
/// - 权限管理（麦克风、摄像头）
/// - 通话记录等业务逻辑
class RtcEngine {
  /// 进入 connecting 后未建联的连接超时时长
  ///
  /// 超时后本地以 failed 结束并向对端发 callHangup(reason=failed)，
  /// 避免对端因网络异常收不到后续信令而一直停留在通话页。
  static const Duration _connectTimeout = Duration(seconds: 30);

  /// 获取当前用户 ID 的回调（动态获取，避免初始化时 userId 尚未就绪）
  final String Function() localUserId;

  /// 事件回调
  final RtcEngineCallback callback;

  // ====================== 内部状态 ======================

  /// WebRTC 对等连接
  webrtc.RTCPeerConnection? _peerConnection;

  /// 本地媒体流
  webrtc.MediaStream? _localStream;

  /// 通话状态
  RtcCallState _state = RtcCallState.idle;

  /// 通话结束原因
  RtcCallEndReason _endReason = RtcCallEndReason.none;

  /// 远端用户 ID
  String _remoteUserId = '';

  /// 通话 ID（服务端生成）
  String _callId = '';

  /// 是否为发起方
  bool _isInitiator = false;

  /// 通话类型
  RtcCallType _callType = RtcCallType.video;

  /// ICE 候选缓冲（在远端描述设置前暂存）
  final List<webrtc.RTCIceCandidate> _pendingCandidates = [];

  /// 远端媒体流（对端轨道未关联 MediaStream 时由本端自建并装载远端轨道）
  webrtc.MediaStream? _remoteStream;

  /// 远端描述是否已设置
  bool _remoteDescSet = false;

  /// 媒体是否已就绪
  bool _mediaReady = false;

  /// 是否正在 SDP 协商（防重复 OFFER/ACCEPT 触发并发协商，对标 Android SDK）
  bool _negotiating = false;

  /// 最近一次来电的 callId（跨通话保留，用于拦截服务端重复投递的来电信令）
  String _lastCallId = '';

  /// 服务端下发的 TURN 凭证信息
  Map<String, dynamic>? _serverTurnInfo;

  /// 通话计时器
  Timer? _callTimer;

  /// 连接超时计时器（connecting 态启动，建联或结束后取消）
  Timer? _connectTimer;

  /// 通话时长（秒）
  int _callDuration = 0;

  // ====================== Getters ======================

  RtcCallState get state => _state;
  RtcCallEndReason get endReason => _endReason;
  String get remoteUserId => _remoteUserId;
  String get callId => _callId;
  bool get isInitiator => _isInitiator;
  RtcCallType get callType => _callType;
  int get callDuration => _callDuration;
  webrtc.MediaStream? get localStream => _localStream;

  // ====================== 构造与销毁 ======================

  RtcEngine({
    required this.localUserId,
    required this.callback,
  });

  /// 释放所有资源
  Future<void> dispose() async {
    _callTimer?.cancel();
    _connectTimer?.cancel();
    await _cleanup();
  }

  // ====================== 公开 API ======================

  /// 发起通话（主叫方入口）
  ///
  /// [targetUserId] 目标用户 ID
  /// [type] 通话类型（音频/视频）
  Future<void> startCall(String targetUserId, RtcCallType type) async {
    _remoteUserId = targetUserId;
    _callType = type;
    _isInitiator = true;
    _endReason = RtcCallEndReason.none;
    _callId = ''; // callId 由服务端生成，通过 callAck 回传（未到达前 cancel 由服务端按占用会话兜底）
    // 上一通通话清理完成后允许立即发起新通话
    _negotiating = false;

    _updateState(RtcCallState.calling);

    // 获取本地媒体流
    await _acquireLocalMedia(type);

    // 发送呼叫请求信令（callId 留空，服务端会填充）
    _sendSignal(RtcSignalType.callRequest, targetUserId, {
      'callType': type == RtcCallType.video ? 'video' : 'audio',
    }, callId: '');
  }

  /// 接听通话（被叫方入口）
  ///
  /// 发送 callAccept 信令，并提前获取本地媒体流。
  Future<void> acceptCall() async {
    // 接听新来电，重置协商标志
    _negotiating = false;
    _sendSignal(RtcSignalType.callAccept, _remoteUserId, {}, callId: _callId);
    _updateState(RtcCallState.connecting);
    _startConnectTimer();

    // 提前获取本地媒体流
    if (!_mediaReady) {
      await _acquireLocalMedia(_callType);
    }
  }

  /// 拒绝通话（被叫方）
  void rejectCall() {
    _endReason = RtcCallEndReason.rejected;
    _sendSignal(RtcSignalType.callReject, _remoteUserId, {'reason': 'reject'}, callId: _callId);
    _endCall();
  }

  /// 取消呼叫（主叫方）
  void cancelCall() {
    _endReason = RtcCallEndReason.cancelled;
    _sendSignal(RtcSignalType.callCancel, _remoteUserId, {'reason': 'cancel'}, callId: _callId);
    _endCall();
  }

  /// 挂断通话
  void hangup() {
    _endReason = RtcCallEndReason.normal;
    _sendSignal(RtcSignalType.callHangup, _remoteUserId, {'reason': 'normal'}, callId: _callId);
    _endCall();
  }

  /// 切换摄像头开关（通话中实时生效）
  ///
  /// 切换后向对端广播媒体状态信令（mediaState），对端 UI 据此显示禁用图标。
  void toggleCamera() {
    final stream = _localStream;
    if (stream == null) return;
    final videoTracks = stream.getVideoTracks();
    if (videoTracks.isEmpty) return;
    for (final track in videoTracks) {
      track.enabled = !track.enabled;
    }
    // 以第一个轨道的新状态作为本端摄像头开关，通知对端
    _sendMediaState(camera: videoTracks.first.enabled);
  }

  /// 切换麦克风开关（通话中实时生效）
  ///
  /// 切换后向对端广播媒体状态信令（mediaState），对端 UI 据此显示静音胶囊。
  void toggleMicrophone() {
    final stream = _localStream;
    if (stream == null) return;
    final audioTracks = stream.getAudioTracks();
    if (audioTracks.isEmpty) return;
    for (final track in audioTracks) {
      track.enabled = !track.enabled;
    }
    // 以第一个轨道的新状态作为本端麦克风开关，通知对端
    _sendMediaState(mic: audioTracks.first.enabled);
  }

  /// 切换前后摄像头
  Future<void> switchCamera() async {
    try {
      final videoTracks = _localStream?.getVideoTracks();
      if (videoTracks == null || videoTracks.isEmpty) return;
      await webrtc.Helper.switchCamera(videoTracks.first);
    } catch (e) {
      debugPrint('[RtcEngine] switchCamera failed: $e');
    }
  }

  /// 查询摄像头是否启用
  bool get cameraEnabled {
    final tracks = _localStream?.getVideoTracks();
    if (tracks == null || tracks.isEmpty) return false;
    return tracks.first.enabled;
  }

  /// 查询麦克风是否启用
  bool get microphoneEnabled {
    final tracks = _localStream?.getAudioTracks();
    if (tracks == null || tracks.isEmpty) return false;
    return tracks.first.enabled;
  }

  /// 格式化通话时长
  static String formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ====================== 信令分发入口 ======================

  /// 处理收到的 RTC 信令（由项目层从 IM 事件中转调）
  void handleSignal(proto.RtcSignal signal) {
    debugPrint('[RtcEngine] signal type=${signal.signalType} from=${signal.senderId} callId=${signal.callId}, state=$_state');

    // 空闲状态下仅响应来电请求，其余视为过期信令
    if (_state == RtcCallState.idle && signal.signalType != RtcSignalType.callRequest) {
      debugPrint('[RtcEngine] signal dropped (idle), type=${signal.signalType}');
      return;
    }

    switch (signal.signalType) {
      case RtcSignalType.callRequest:
        // 诊断日志：服务端中转时是否填充 callId / 下发 turn 凭证
        debugPrint('[RtcEngine] CALL_REQUEST raw payload: ${signal.payload}');
        _onCallRequest(signal);
        break;
      case RtcSignalType.callAccept:
        // 诊断日志：服务端中转时是否填充 callId / 下发 turn 凭证
        debugPrint('[RtcEngine] CALL_ACCEPT raw payload: ${signal.payload}');
        _onCallAccept(signal);
        break;
      case RtcSignalType.callAck:
        _onCallAck(signal);
        break;
      case RtcSignalType.callReject:
        _onCallReject(signal);
        break;
      case RtcSignalType.callCancel:
        _onCallCancel(signal);
        break;
      case RtcSignalType.callHangup:
        _onCallHangup(signal);
        break;
      case RtcSignalType.offer:
        _onOffer(signal);
        break;
      case RtcSignalType.answer:
        _onAnswer(signal);
        break;
      case RtcSignalType.iceCandidate:
        _onIceCandidate(signal);
        break;
      case RtcSignalType.mediaState:
        _onMediaState(signal);
        break;
    }
  }

  // ====================== 信令事件处理 ======================

  /// 收到呼叫请求（被叫方）
  void _onCallRequest(proto.RtcSignal signal) {
    // 同一通来电的重复信令（服务端重投）→ 丢弃
    if (signal.callId.isNotEmpty && signal.callId == _lastCallId && _state != RtcCallState.idle) {
      debugPrint('[RtcEngine] duplicate CALL_REQUEST ignored, callId=${signal.callId}');
      return;
    }
    // 通话进行中收到新来电 → 忽略，防止串线
    if (_state == RtcCallState.calling ||
        _state == RtcCallState.connecting ||
        _state == RtcCallState.connected) {
      debugPrint('[RtcEngine] CALL_REQUEST ignored (busy), state=$_state');
      return;
    }

    _lastCallId = signal.callId;
    // 新通话开始，重置协商标志
    _negotiating = false;

    _remoteUserId = signal.senderId;
    _callId = signal.callId;
    _isInitiator = false;
    _endReason = RtcCallEndReason.none;

    // 解析服务端下发的 TURN 凭证与通话类型
    if (signal.payload.isNotEmpty) {
      try {
        final payload = jsonDecode(signal.payload) as Map<String, dynamic>;
        _parseTurnFromPayload(payload);
        // 通话类型由主叫 payload 指定（此前硬编码 video，音频来电会被误判为视频）
        _callType = payload['callType'] == 'audio' ? RtcCallType.audio : RtcCallType.video;
      } catch (e) {
        debugPrint('[RtcEngine] parse CALL_REQUEST payload error: $e');
      }
    }

    _updateState(RtcCallState.ringing);

    // 通知项目层展示来电 UI
    callback.onIncomingCall(signal.senderId, signal.callId);
  }

  /// 收到接听（主叫方）→ 创建 PeerConnection 并发送 Offer
  void _onCallAccept(proto.RtcSignal signal) {
    // SDP 协商已在进行或已完成 → 重复 accept（信令重投），丢弃
    if (_negotiating || _remoteDescSet) {
      debugPrint('[RtcEngine] duplicate CALL_ACCEPT ignored, state=$_state');
      return;
    }

    if (signal.callId.isNotEmpty) {
      _callId = signal.callId;
    }

    // 解析服务端下发的 TURN 凭证（在创建 PeerConnection 之前）
    if (signal.payload.isNotEmpty) {
      _parseTurnFromPayload(jsonDecode(signal.payload) as Map<String, dynamic>);
    }

    _updateState(RtcCallState.connecting);
    _startConnectTimer();
    _createAndSendOffer();
  }

  /// 收到服务端呼叫确认（主叫方）→ 记录服务端生成的权威 callId
  ///
  /// 主叫 startCall 时 callId 留空，由服务端生成后经 CALL_ACK 回传；
  /// 存下后 cancel/hangup 等信令即可携带正确 callId。
  /// 兼容：若 cancel 先于 CALL_ACK 到达，服务端会按主叫占用会话兜底解析，不影响结束。
  void _onCallAck(proto.RtcSignal signal) {
    if (signal.callId.isNotEmpty) {
      _callId = signal.callId;
      debugPrint('[RtcEngine] CALL_ACK received, callId=$_callId');
    }
  }

  /// 收到拒绝
  void _onCallReject(proto.RtcSignal signal) {
    // 过期拒绝信令（callId 不匹配）→ 丢弃，防止误伤新通话
    if (signal.callId.isNotEmpty && signal.callId != _callId) {
      debugPrint('[RtcEngine] stale CALL_REJECT ignored, callId=${signal.callId} != $_callId');
      return;
    }

    final payload = signal.payload.isNotEmpty ? jsonDecode(signal.payload) : {};
    final reason = payload['reason'] as String?;
    _endReason = (reason == 'busy') ? RtcCallEndReason.busy : RtcCallEndReason.rejected;
    _endCall();
  }

  /// 收到取消
  void _onCallCancel(proto.RtcSignal signal) {
    // 过期取消信令（callId 不匹配）→ 丢弃，防止误伤新通话
    if (signal.callId.isNotEmpty && signal.callId != _callId) {
      debugPrint('[RtcEngine] stale CALL_CANCEL ignored, callId=${signal.callId} != $_callId');
      return;
    }
    _endReason = RtcCallEndReason.cancelled;
    _endCall();
  }

  /// 收到挂断
  ///
  /// 解析 payload reason：'failed' 映射为连接失败（如对端建联超时/失败时主动同步），
  /// 其余视为正常挂断。
  void _onCallHangup(proto.RtcSignal signal) {
    // 过期挂断信令（callId 不匹配）→ 丢弃，防止误伤新通话
    if (signal.callId.isNotEmpty && signal.callId != _callId) {
      debugPrint('[RtcEngine] stale CALL_HANGUP ignored, callId=${signal.callId} != $_callId');
      return;
    }
    _endReason = RtcCallEndReason.normal;
    if (signal.payload.isNotEmpty) {
      try {
        final payload = jsonDecode(signal.payload);
        if (payload is Map && payload['reason'] == 'failed') {
          _endReason = RtcCallEndReason.failed;
        }
      } catch (_) {}
    }
    _endCall();
  }

  /// 收到对端媒体开关状态（通话中对端切换摄像头/麦克风）
  ///
  /// 过期信令（callId 不匹配）丢弃，防止串线到新通话。
  void _onMediaState(proto.RtcSignal signal) {
    if (signal.callId.isNotEmpty && signal.callId != _callId) {
      debugPrint('[RtcEngine] stale MEDIA_STATE ignored, callId=${signal.callId} != $_callId');
      return;
    }
    if (signal.payload.isEmpty) return;
    try {
      final payload = jsonDecode(signal.payload) as Map<String, dynamic>;
      final hasCamera = payload.containsKey('camera');
      final hasMic = payload.containsKey('mic');
      if (!hasCamera && !hasMic) return;
      final camera = hasCamera ? payload['camera'] as bool? : null;
      final mic = hasMic ? payload['mic'] as bool? : null;
      debugPrint('[RtcEngine] Remote media state: camera=$camera, mic=$mic');
      callback.onRemoteMediaStateChanged(camera, mic);
    } catch (e) {
      debugPrint('[RtcEngine] parse media state error: $e');
    }
  }

  /// 通知对端本端媒体开关状态（payload 只带变化项）
  ///
  /// 与 Android SDK `sendMediaState` 协议一致：`{"camera": bool}` / `{"mic": bool}`。
  void _sendMediaState({bool? camera, bool? mic}) {
    if (camera == null && mic == null) return;
    if (_remoteUserId.isEmpty) return;
    final payload = <String, dynamic>{};
    if (camera != null) payload['camera'] = camera;
    if (mic != null) payload['mic'] = mic;
    _sendSignal(RtcSignalType.mediaState, _remoteUserId, payload, callId: _callId);
    debugPrint('[RtcEngine] Media state sent: camera=$camera, mic=$mic');
  }

  // ====================== WebRTC 核心流程 ======================

  /// 主叫方：创建 Offer 并发送
  Future<void> _createAndSendOffer() async {
    await _initPeerConnection();

    // 标记协商进行中，防止重复 CALL_ACCEPT 触发并发 createOffer
    _negotiating = true;
    try {
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      _sendSignal(RtcSignalType.offer, _remoteUserId, {
        'sdp': offer.sdp,
      }, callId: _callId);

      debugPrint('[RtcEngine] Offer sent to $_remoteUserId');
    } catch (e) {
      _negotiating = false;
      debugPrint('[RtcEngine] createOffer failed: $e');
      rethrow;
    }
  }

  /// 被叫方：收到 Offer，创建 Answer
  Future<void> _onOffer(proto.RtcSignal signal) async {
    // SDP 协商已在进行或已完成 → 重复 offer（信令重投），丢弃
    if (_negotiating || _remoteDescSet) {
      debugPrint('[RtcEngine] duplicate OFFER ignored');
      return;
    }
    // 标记协商进行中，防止重复 OFFER 触发并发 setRemoteDescription
    _negotiating = true;

    try {
      await _initPeerConnection();

      final payload = jsonDecode(signal.payload);
      final desc = webrtc.RTCSessionDescription(payload['sdp'] as String, 'offer');
      await _peerConnection!.setRemoteDescription(desc);
      debugPrint('[RtcEngine] Remote description set (offer)');

      await _flushPendingCandidates();

      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      _sendSignal(RtcSignalType.answer, signal.senderId, {
        'sdp': answer.sdp,
      }, callId: _callId);

      // 协商完成（answer 已发出）
      _negotiating = false;
      debugPrint('[RtcEngine] Answer sent to ${signal.senderId}');
    } catch (e) {
      _negotiating = false;
      rethrow;
    }
  }

  /// 主叫方：收到 Answer，设置远端描述
  Future<void> _onAnswer(proto.RtcSignal signal) async {
    // 远端描述已设置 → 重复 answer（信令重投），丢弃
    if (_remoteDescSet) {
      debugPrint('[RtcEngine] duplicate ANSWER ignored');
      return;
    }

    final payload = jsonDecode(signal.payload);
    final desc = webrtc.RTCSessionDescription(payload['sdp'] as String, 'answer');
    await _peerConnection!.setRemoteDescription(desc);
    debugPrint('[RtcEngine] Remote description set (answer)');

    await _flushPendingCandidates();
    // 协商完成（answer 已设置）
    _negotiating = false;
  }

  /// 处理远端 ICE Candidate
  Future<void> _onIceCandidate(proto.RtcSignal signal) async {
    final payload = jsonDecode(signal.payload);
    final candidate = webrtc.RTCIceCandidate(
      payload['candidate'] as String,
      payload['sdpMid'] as String?,
      payload['sdpMLineIndex'] as int?,
    );

    if (_remoteDescSet && _peerConnection != null) {
      await _peerConnection!.addCandidate(candidate);
      debugPrint('[RtcEngine] Remote ICE candidate added immediately');
    } else {
      _pendingCandidates.add(candidate);
      debugPrint('[RtcEngine] Remote ICE candidate buffered (pending: ${_pendingCandidates.length})');
    }
  }

  // ====================== PeerConnection 管理 ======================

  /// 初始化 PeerConnection
  ///
  /// 防重复：如果 PeerConnection 已存在且媒体就绪则复用
  Future<void> _initPeerConnection() async {
    if (_peerConnection != null && _mediaReady) {
      debugPrint('[RtcEngine] PeerConnection already exists, reusing');
      return;
    }

    final config = {
      'iceServers': _buildIceServers(),
    };
    _peerConnection = await webrtc.createPeerConnection(config);
    debugPrint('[RtcEngine] PeerConnection created');

    _remoteDescSet = false;
    // 注意：此处不清空 _pendingCandidates —— 被叫在收到 offer 前缓冲的主叫候选
    // 依赖它存活到 setRemoteDescription 后回放；上一通话的残留由 _cleanup() 清理
    // （对标 Android SDK initPeerConnection 的同名注释）

    _peerConnection!.onIceCandidate = (candidate) {
      debugPrint('[RtcEngine] Local ICE candidate generated');
      _sendSignal(RtcSignalType.iceCandidate, _remoteUserId, {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      }, callId: _callId);
    };

    _peerConnection!.onTrack = (event) {
      debugPrint('[RtcEngine] onTrack: kind=${event.track.kind}, streams=${event.streams.length}');
      if (event.streams.isNotEmpty) {
        callback.onRemoteStreamReceived(event.streams[0]);
        return;
      }
      // 对端轨道未关联 MediaStream（Android 端 UNIFIED_PLAN addTrack 不带
      // streamId，原生 onAddTrack 收到的 MediaStream[] 为空）时，本端自建流
      // 装载远端轨道，否则渲染层拿不到 MediaStream、看不到对端画面
      unawaited(_attachRemoteTrack(event.track));
    };

    _peerConnection!.onConnectionState = (state) {
      debugPrint('[RtcEngine] PeerConnection state: $state');
      if (state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        _onPeerConnected();
      } else if (state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        // 建联失败：以 failed 结束并向对端同步挂断，
        // 否则对端收不到任何信令会一直停留在通话页
        _onPeerConnectionBroken();
      }
      // 注意：Disconnected 是瞬态（网络切换/信号抖动时闪断），
      // libwebrtc 会自动重连回到 Connected 或最终进入 Failed，
      // 此处不结束通话，避免偶发闪断误杀正常通话
    };

    // 备用：ICE 连接状态（某些平台 onConnectionState 不可靠）
    _peerConnection!.onIceConnectionState = (state) {
      debugPrint('[RtcEngine] ICE connection state: $state');
      if (state == webrtc.RTCIceConnectionState.RTCIceConnectionStateConnected ||
          state == webrtc.RTCIceConnectionState.RTCIceConnectionStateCompleted) {
        _onPeerConnected();
      }
    };

    // 获取本地媒体流（如果尚未获取）
    if (!_mediaReady) {
      await _acquireLocalMedia(_callType);
    }

    // 将本地媒体轨道添加到 PeerConnection
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });
      debugPrint('[RtcEngine] Local tracks added to PeerConnection');
    }
  }

  /// 连接成功回调（去重）
  void _onPeerConnected() {
    _connectTimer?.cancel();
    if (_state == RtcCallState.connected) return;
    _updateState(RtcCallState.connected);
    _startTimer();
    debugPrint('[RtcEngine] Call connected, timer started');
  }

  /// 对等连接失败/断开（PeerConnection Failed 或 Disconnected）
  ///
  /// 向对端发 callHangup(reason=failed) 后本地结束，保证双方通话页同步退出。
  /// 幂等：已结束/空闲时忽略（如对端先发来挂断信令导致本地已结束）。
  void _onPeerConnectionBroken() {
    if (_state == RtcCallState.ended || _state == RtcCallState.idle) return;
    _endCallWithNotify(RtcCallEndReason.failed);
  }

  /// 将缓冲的 ICE 候选添加到 PeerConnection
  Future<void> _flushPendingCandidates() async {
    _remoteDescSet = true;
    if (_pendingCandidates.isEmpty) return;
    debugPrint('[RtcEngine] Flushing ${_pendingCandidates.length} pending ICE candidates');
    for (final candidate in _pendingCandidates) {
      await _peerConnection!.addCandidate(candidate);
    }
    _pendingCandidates.clear();
  }

  // ====================== 媒体管理 ======================

  /// 获取本地媒体流
  ///
  /// 直接调用 getUserMedia，权限由项目层在调用 startCall/acceptCall 前确保。
  Future<void> _acquireLocalMedia(RtcCallType type) async {
    if (_mediaReady) return;

    final constraints = {
      'audio': true,
      'video': type == RtcCallType.video,
    };
    _localStream = await webrtc.navigator.mediaDevices.getUserMedia(constraints);
    _mediaReady = true;
    // 通知项目层本地流已就绪（避免依赖调用时序获取预览流）
    callback.onLocalStreamReady(_localStream!);
    debugPrint('[RtcEngine] Local media acquired: '
        'audio=${_localStream!.getAudioTracks().length}, '
        'video=${_localStream!.getVideoTracks().length}');
  }

  // ====================== 内部工具 ======================

  /// 发送信令
  void _sendSignal(int signalType, String receiverId, Map<String, dynamic> payload, {String? callId}) {
    final body = proto.RtcSignal()
      ..signalType = signalType
      ..senderId = localUserId()
      ..receiverId = receiverId
      ..payload = jsonEncode(payload)
      ..callId = callId ?? _callId;

    final packet = PacketCodec.create(Cmd.rtcSignal, body: body);
    callback.onSendSignal(packet);
  }

  /// 更新状态并通知
  void _updateState(RtcCallState newState) {
    _state = newState;
    callback.onCallStateChanged(newState);
  }

  /// 结束通话
  ///
  /// 注意回调顺序：必须先通知 onCallEnded（结束原因已确定，
  /// 项目层依赖此时保存通话记录），再通知状态变为 ended，
  /// 否则项目层监听 ended 时拿不到结束原因/通话记录。
  void _endCall() {
    _callTimer?.cancel();
    _connectTimer?.cancel();

    if (_endReason == RtcCallEndReason.none) {
      _endReason = RtcCallEndReason.failed;
    }

    callback.onCallEnded(_endReason);
    _updateState(RtcCallState.ended);
    _cleanup();

    // 延迟恢复空闲状态
    Future.delayed(const Duration(seconds: 1), () {
      if (_state == RtcCallState.ended) {
        _updateState(RtcCallState.idle);
      }
    });
  }

  /// 以指定原因结束通话并通知对端（本地异常终止统一入口）
  ///
  /// 用于连接失败/建联超时等本端异常场景：先向对端发 callHangup(reason)，
  /// 再走 [_endCall] 本地收口，保证对端不会停留在通话页。
  /// 幂等：已结束/空闲时直接忽略。
  void _endCallWithNotify(RtcCallEndReason reason) {
    if (_state == RtcCallState.ended || _state == RtcCallState.idle) return;
    _endReason = reason;
    if (_remoteUserId.isNotEmpty) {
      _sendSignal(RtcSignalType.callHangup, _remoteUserId,
          {'reason': reason.name}, callId: _callId);
    }
    _endCall();
  }

  /// 启动连接超时计时（connecting 态调用，建联成功或结束后取消）
  ///
  /// 超时仍未建联则以 failed 结束并通知对端，避免双方无限等待。
  void _startConnectTimer() {
    _connectTimer?.cancel();
    _connectTimer = Timer(_connectTimeout, () {
      if (_state == RtcCallState.connecting) {
        debugPrint('[RtcEngine] Connect timeout ($_connectTimeout)');
        _endCallWithNotify(RtcCallEndReason.failed);
      }
    });
  }

  /// 将远端轨道装入自建流并通知（惰性创建，多轨道复用同一条流）
  ///
  /// audio/video 各触发一次 onTrack，每次都会通知回调；
  /// 轨道按 id 去重，渲染层拿到同一流对象刷新即可。
  Future<void> _attachRemoteTrack(webrtc.MediaStreamTrack track) async {
    try {
      _remoteStream ??= await webrtc.createLocalMediaStream('remote_stream');
      final exists =
          _remoteStream!.getTracks().any((t) => t.id == track.id);
      if (!exists) {
        // addToNative 默认 true：原生流需持有轨道，渲染器才能出画面
        await _remoteStream!.addTrack(track);
      }
      callback.onRemoteStreamReceived(_remoteStream!);
      debugPrint('[RtcEngine] remote track attached: kind=${track.kind}');
    } catch (e) {
      debugPrint('[RtcEngine] attach remote track error: $e');
    }
  }

  /// 清理 WebRTC 资源
  Future<void> _cleanup() async {
    try {
      await _localStream?.dispose();
      _localStream = null;
      await _remoteStream?.dispose();
      _remoteStream = null;
      await _peerConnection?.close();
      _peerConnection = null;
      _mediaReady = false;
      _remoteDescSet = false;
      _negotiating = false;
      _pendingCandidates.clear();
      _serverTurnInfo = null;
      _callId = '';
    } catch (e) {
      debugPrint('[RtcEngine] cleanup error: $e');
    }
  }

  /// 启动通话计时
  void _startTimer() {
    _callDuration = 0;
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _callDuration += 1;
      callback.onCallDurationTick(_callDuration);
    });
  }

  // ====================== ICE / TURN 配置 ======================

  /// 构建 ICE 服务器配置
  ///
  /// 优先使用服务端在 callRequest/callAccept 中下发的 TURN 凭证，
  /// 若未收到则回退到 Google 公共 STUN。
  List<Map<String, dynamic>> _buildIceServers() {
    final servers = <Map<String, dynamic>>[];

    final turnInfo = _serverTurnInfo;
    if (turnInfo != null && turnInfo['turnUrl'] != null) {
      if (turnInfo['stunUrl'] != null) {
        servers.add({'urls': turnInfo['stunUrl']});
      }
      servers.add({
        'urls': turnInfo['turnUrl'],
        'username': turnInfo['username'] ?? '',
        'credential': turnInfo['credential'] ?? '',
      });
      debugPrint('[RtcEngine] ICE servers: STUN+TURN from server payload');
      return servers;
    }

    servers.add({'urls': 'stun:stun.l.google.com:19302'});
    debugPrint('[RtcEngine] ICE servers: fallback to Google STUN');
    return servers;
  }

  /// 从信令 payload 中解析服务端下发的 TURN 凭证
  void _parseTurnFromPayload(Map<String, dynamic> payload) {
    final turn = payload['turn'];
    if (turn is Map<String, dynamic>) {
      _serverTurnInfo = turn;
      debugPrint('[RtcEngine] TURN info parsed: turnUrl=${turn['turnUrl']}');
    }
  }
}
