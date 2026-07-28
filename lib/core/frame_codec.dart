import 'dart:typed_data';

/// Varint32 帧编解码器
/// 对齐服务端 Netty 的 ProtobufVarint32FrameDecoder/Encoder
///
/// 协议格式：[length(varint32)][payload(length bytes)]
/// - length: 消息体长度（不含 length 本身）
/// - payload: protobuf 序列化的 Packet 字节
class FrameCodec {
  FrameCodec._();

  /// 将 payload 编码为带 Varint32 长度前缀的帧
  static Uint8List encode(Uint8List payload) {
    final lengthBytes = _encodeVarint32(payload.length);
    final frame = Uint8List(lengthBytes.length + payload.length);
    frame.setRange(0, lengthBytes.length, lengthBytes);
    frame.setRange(lengthBytes.length, frame.length, payload);
    return frame;
  }

  /// 从缓冲区中解码帧（支持粘包/拆包）
  ///
  /// 返回值：
  /// - 成功解码：返回 (payload, bytesConsumed)
  /// - 数据不足：返回 null
  static FrameDecodeResult? decode(Uint8List buffer, int offset) {
    if (offset >= buffer.length) return null;

    // 解码 varint32 长度
    int length = 0;
    int shift = 0;
    int pos = offset;

    while (pos < buffer.length) {
      final byte = buffer[pos];
      length |= (byte & 0x7F) << shift;
      pos++;

      if ((byte & 0x80) == 0) {
        break;
      }

      shift += 7;
      if (shift >= 32) {
        throw StateError('Varint32 too long');
      }
    }

    // 检查 varint 是否完整
    if (pos >= buffer.length && (buffer[pos - 1] & 0x80) != 0) {
      return null; // 数据不完整，等待更多数据
    }

    // 检查 payload 是否完整
    if (pos + length > buffer.length) {
      return null; // payload 数据不足
    }

    // 提取 payload
    final payload = Uint8List.fromList(
        buffer.sublist(pos, pos + length));

    return FrameDecodeResult(
      payload: payload,
      bytesConsumed: pos - offset + length,
    );
  }

  /// 从缓冲区中解码所有可用帧（处理粘包）
  static List<Uint8List> decodeAll(Uint8List buffer) {
    final frames = <Uint8List>[];
    int offset = 0;

    while (offset < buffer.length) {
      final result = decode(buffer, offset);
      if (result == null) break;

      frames.add(result.payload);
      offset += result.bytesConsumed;
    }

    return frames;
  }

  /// 编码 varint32（Little-Endian，最高位标记后续字节）
  static Uint8List _encodeVarint32(int value) {
    final bytes = <int>[];

    // 使用无符号处理
    int v = value & 0xFFFFFFFF;

    while (v >= 0x80) {
      bytes.add((v & 0x7F) | 0x80);
      v >>= 7;
    }
    bytes.add(v);

    return Uint8List.fromList(bytes);
  }
}

/// 帧解码结果
class FrameDecodeResult {
  /// 解码出的 payload
  final Uint8List payload;

  /// 消耗的字节数（varint长度字段 + payload）
  final int bytesConsumed;

  const FrameDecodeResult({
    required this.payload,
    required this.bytesConsumed,
  });
}
