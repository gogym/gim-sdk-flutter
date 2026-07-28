/// 设备类型枚举（对应服务端 DeviceType.java）
///
/// 用于标识客户端设备类型，绑定时上报服务端
enum DeviceType {
  mobile('mobile'),
  desktop('desktop'),
  web('web'),
  pad('pad');

  /// 设备类型编码字符串
  final String value;

  const DeviceType(this.value);

  /// 根据 code 获取设备类型
  static DeviceType fromCode(String code) {
    return DeviceType.values.firstWhere(
      (e) => e.value == code,
      orElse: () => DeviceType.mobile,
    );
  }
}
