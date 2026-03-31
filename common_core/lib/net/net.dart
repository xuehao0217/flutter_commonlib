import '../helpter/logger_helper.dart';
import '../helpter/talker_helper.dart';

/// 网络层日志桥接（转发到 [LogHelper] / [LoggerHelper]）。
class HttpLog {
  static void d(String msg) {
    LogHelper.d(msg);
  }

  static void json(String msg) {
    LogHelper.t(msg);
  }

  static void e(String msg) {
    LoggerHelper.e(msg);
  }
}

/// 与 [HttpUtils] / [BaseEntity] 配合使用的业务侧错误码（含解析失败、取消等）。
class NetExceptionHandle {
  static const int net_parse_error = 1001;
  static const int net_error = 1002;
  static const int net_cancel = 1003;
}
