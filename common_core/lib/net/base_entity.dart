
class BaseEntity {
  final int errorCode;
  final String errorMsg;
  final dynamic data;  // 使用 dynamic 以支持 Map 和 List

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