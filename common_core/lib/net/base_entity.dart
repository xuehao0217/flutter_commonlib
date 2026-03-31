/// 统一 HTTP 响应壳：与后端约定 `errorCode == 0` 为成功，[data] 为泛型解析入口。
class BaseEntity {
  final int errorCode;
  final String errorMsg;
  /// 业务数据，多为 Map / List，由宿主 [JsonConvertAsT] 转成模型。
  final dynamic data;

  const BaseEntity({
    required this.errorCode,
    required this.errorMsg,
    this.data,
  });

  bool isSuccess() => errorCode == 0;

  // 基础解析方法
  factory BaseEntity.fromJson(Map<String, dynamic> json) {
    return BaseEntity(
      errorCode: json['errorCode'] as int? ?? -1,
      errorMsg: json['errorMsg'] as String? ?? '',
      data: json['data'],
    );
  }
}