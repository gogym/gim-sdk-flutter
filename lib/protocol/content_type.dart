/// 消息内容类型枚举（对应服务端 ContentType.java）
///
/// 用于标识聊天消息的内容类型
enum ContentType {
  text(1, '文字', '[消息]'),
  image(2, '图片', '[图片]'),
  audio(3, '语音', '[语音]'),
  video(4, '视频', '[视频]'),
  file(5, '文件', '[文件]'),
  location(6, '位置', '[位置]'),
  custom(7, '自定义', '[自定义消息]'),
  callRecord(8, '通话记录', '[通话记录]');

  /// 数值编码（与服务端一致）
  final int value;

  /// 可读标签
  final String label;

  /// 推送显示文本
  final String pushText;

  const ContentType(this.value, this.label, this.pushText);

  /// 根据 value 获取枚举
  static ContentType fromValue(int value) {
    return ContentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ContentType.text,
    );
  }
}
