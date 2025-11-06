import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

void main() {
  // ---------------------------
  // LoggerHelper 使用示例
  // ---------------------------

  // 1. 普通 Debug 日志
  LoggerHelper.d("这是普通 debug 日志");

  // 2. 带 tag 的 Debug 日志
  LoggerHelper.d("这是带 tag 的 debug 日志", tag: "HomePage");

  // 3. Warning 日志
  LoggerHelper.w("这是 warning 日志");

  // 4. Error 日志（带 error 和 stackTrace）
  try {
    int result = 10 ~/ 0; // 故意制造异常
  } catch (e, stack) {
    LoggerHelper.e("捕获到异常", error: e, stackTrace: stack, tag: "Calculator");
  }

  // 5. Info 日志
  LoggerHelper.i("这是 info 日志");

  // 6. Trace 日志
  LoggerHelper.t("这是 trace 日志");

  // 7. 无堆栈 Debug 日志
  LoggerHelper.dNoStack("这是无堆栈 debug 日志", tag: "NoStack");

  // 8. JSON / Map / List 日志
  Map<String, dynamic> user = {
    "id": 1001,
    "name": "Alice",
    "roles": ["admin", "user"],
  };
  LoggerHelper.json(user, tag: "UserData");

  List<int> numbers = [1, 2, 3, 4, 5];
  LoggerHelper.json(numbers, tag: "NumbersList");

  String jsonString = '{"title":"Logger Example","success":true}';
  LoggerHelper.json(jsonString, tag: "JSONString");

  // ---------------------------
  // 扩展方法使用示例
  // ---------------------------
  "扩展方法 debug 日志".loggerD(tag: "Ext");
  "扩展方法 warning 日志".loggerW(tag: "Ext");
  try {
    int x = 5 ~/ 0;
  } catch (e, stack) {
    "扩展方法 error 日志".loggerE(error: e, stackTrace: stack, tag: "Ext");
  }
  "扩展方法 info 日志".loggerI(tag: "Ext");
  "扩展方法 trace 日志".loggerT(tag: "Ext");
  "扩展方法无堆栈 debug 日志".loggerDNoStack(tag: "Ext");
  "扩展方法 JSON 日志".loggerJson(tag: "Ext");
}

class LoggerHelper {
  /// 日志是否启用（release 自动关闭）
  static bool enable = kDebugMode;

  /// 默认 Logger（带堆栈）
  static final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 2));

  /// 无堆栈 Logger
  static final Logger _loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  LoggerHelper._(); // 私有构造，不允许实例化

  /// Debug 日志
  static void d(dynamic message, {String? tag}) {
    if (!enable) return;
    _logger.d(_formatMessage(message, tag: tag));
  }

  /// Warning 日志
  static void w(dynamic message, {String? tag}) {
    if (!enable) return;
    _logger.w(_formatMessage(message, tag: tag));
  }

  /// Error 日志，可带 error 和 stackTrace
  static void e(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!enable) return;
    _logger.e(
      _formatMessage(message, tag: tag),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Info 日志
  static void i(dynamic message, {String? tag}) {
    if (!enable) return;
    _logger.i(_formatMessage(message, tag: tag));
  }

  /// Trace 日志
  static void t(dynamic message, {String? tag}) {
    if (!enable) return;
    _logger.t(_formatMessage(message, tag: tag));
  }

  /// 无堆栈 Debug 日志
  static void dNoStack(dynamic message, {String? tag}) {
    if (!enable) return;
    _loggerNoStack.d(_formatMessage(message, tag: tag));
  }

  /// JSON / Map / List 格式化日志
  static void json(dynamic message, {String? tag}) {
    if (!enable) return;
    try {
      if (message is String) {
        final decoded = jsonDecode(message);
        _logger.d(JsonEncoder.withIndent('  ').convert(decoded));
      } else {
        _logger.d(JsonEncoder.withIndent('  ').convert(message));
      }
    } catch (_) {
      _logger.d(_formatMessage(message, tag: tag));
    }
  }

  /// 内部统一格式化信息，支持 tag
  static String _formatMessage(dynamic message, {String? tag}) {
    final msg =
        message is Map || message is List
            ? JsonEncoder.withIndent('  ').convert(message)
            : message.toString();
    return tag != null ? '[$tag] $msg' : msg;
  }
}

/// 扩展方法，更直观
extension StringExtensions on String {
  void loggerD({String? tag}) => LoggerHelper.d(this, tag: tag);

  void loggerW({String? tag}) => LoggerHelper.w(this, tag: tag);

  void loggerE({dynamic error, StackTrace? stackTrace, String? tag}) =>
      LoggerHelper.e(this, error: error, stackTrace: stackTrace, tag: tag);

  void loggerI({String? tag}) => LoggerHelper.i(this, tag: tag);

  void loggerT({String? tag}) => LoggerHelper.t(this, tag: tag);

  void loggerJson({String? tag}) => LoggerHelper.json(this, tag: tag);

  void loggerDNoStack({String? tag}) => LoggerHelper.dNoStack(this, tag: tag);
}
