
import '../helpter/logger_helper.dart';
class HttpLog {
  static void d(String msg) {
    LoggerHelper.d(msg);
  }

  static void json(String msg) {
    LoggerHelper.t(msg);
  }

  static void e(String msg) {
    LoggerHelper.e(msg);
  }
}

// 网络请求相关的错误码
class NetExceptionHandle {
  static const int net_parse_error = 1001;
  static const int net_error = 1002;
  static const int net_cancel = 1003;
}
