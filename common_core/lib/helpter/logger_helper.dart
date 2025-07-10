import 'package:logger/logger.dart';

class LoggerHelper {
  // 静态 Logger 实例
  static final Logger _logger = Logger(printer: PrettyPrinter());
  static final Logger _loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

  LoggerHelper._(); // 不允许实例化

  static void d(dynamic message) {
    _logger.d(message);
  }

  static void w(dynamic message) {
    _logger.w(message);
  }

  static void e(dynamic message) {
    _logger.e(message);
  }

  static void i(dynamic message) {
    _logger.i(message);
  }

  // 如果你需要无堆栈日志
  static void dNoStack(dynamic message) {
    _loggerNoStack.d(message);
  }

  static void t(dynamic message) {
    _logger.t(message);
  }
}


extension StringExtensions on String {
  void printLogger() {
     LoggerHelper.d(this);
  }
}