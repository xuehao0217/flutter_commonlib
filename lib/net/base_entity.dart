import '../generated/json/base/json_convert_content.dart';

class BaseEntity<T> {
  BaseEntity(this.code, this.msg, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    code =json["errorCode"] as int;
    msg = json["errorMsg"] as String;
    data = _generateOBJ<T>(json["data"] as Object?);
  }

  late int code;
  late String msg;
  T? data;

  isSuccess()=>code==0;

  T? _generateOBJ<O>(Object? json) {
    if (json == null) {
      return null;
    }
    if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    } else {
      /// 处理JSON解析
      return JsonConvert.fromJsonAsT<T>(json);
    }
  }
}
