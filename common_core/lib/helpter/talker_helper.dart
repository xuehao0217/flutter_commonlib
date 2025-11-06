import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// 全局 Talker 实例
final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    // enabled: kDebugMode,
    useHistory: true,
    useConsoleLogs: kDebugMode,
    maxHistoryItems: 500,
    timeFormat: TimeFormat.timeAndSeconds,
    titles: {
      TalkerKey.httpRequest: '🌐 Request',
      TalkerKey.httpResponse: '✅ Response',
      TalkerKey.error: '❌ Error',
      TalkerKey.debug: '🐞 Debug',
    },
    colors: {
      TalkerKey.httpRequest: AnsiPen()..cyan(),
      TalkerKey.httpResponse: AnsiPen()..green(),
      TalkerKey.error: AnsiPen()..red(bold: true),
      TalkerKey.debug: AnsiPen()..gray(),
    },
  ),
);


void main() {
  // ---------------------------
  // LoggerHelper 使用示例
  // ---------------------------

  LogHelper.d("这是普通 debug 日志");
  LogHelper.d("这是带 tag 的 debug 日志", tag: "HomePage");
  LogHelper.w("这是 warning 日志");

  try {
    int result = 10 ~/ 0; // 故意制造异常
  } catch (e, stack) {
    LogHelper.e("捕获到异常", error: e, stackTrace: stack, tag: "Calculator");
  }

  LogHelper.i("这是 info 日志");
  LogHelper.t("这是 trace 日志");
  LogHelper.dNoStack("这是无堆栈 debug 日志", tag: "NoStack");

  Map<String, dynamic> user = {
    "id": 1001,
    "name": "Alice",
    "roles": ["admin", "user"],
  };
  LogHelper.json(user, tag: "UserData");

  List<int> numbers = [1, 2, 3, 4, 5];
  LogHelper.json(numbers, tag: "NumbersList");

  String jsonString = '{"title":"Logger Example","success":true}';
  LogHelper.json(jsonString, tag: "JSONString");

  "扩展方法 debug 日志".logD(tag: "Ext");
  "扩展方法 warning 日志".logW(tag: "Ext");

  try {
    int x = 5 ~/ 0;
  } catch (e, stack) {
    "扩展方法 error 日志".logE(error: e, stackTrace: stack, tag: "Ext");
  }

  "扩展方法 info 日志".logI(tag: "Ext");
  "扩展方法 trace 日志".logT(tag: "Ext");
  "扩展方法无堆栈 debug 日志".logDNoStack(tag: "Ext");
  "扩展方法 JSON 日志".logJson(tag: "Ext");

  // 打开 Talker 日志界面（在 Flutter app 中）
  // runApp(TalkerScreen(talker: talker));
}

/// ------------------------------------------------------
/// LoggerHelper (Talker 版本)
/// ------------------------------------------------------
class LogHelper {
  /// release 自动关闭日志
  static bool enable = kDebugMode;

  LogHelper._();

  /// Debug 日志
  static void d(dynamic message, {String? tag}) {
    if (!enable) return;
    final msg = _format(message, tag: tag);
    talker.debug(msg);
  }

  /// Info 日志
  static void i(dynamic message, {String? tag}) {
    if (!enable) return;
    final msg = _format(message, tag: tag);
    talker.info(msg);
  }

  /// Warning 日志
  static void w(dynamic message, {String? tag}) {
    if (!enable) return;
    final msg = _format(message, tag: tag);
    talker.warning(msg);
  }

  /// Error 日志（支持 error + stackTrace）
  static void e(
      dynamic message, {
        dynamic error,
        StackTrace? stackTrace,
        String? tag,
      }) {
    if (!enable) return;
    final msg = _format(message, tag: tag);
    talker.error(msg, error, stackTrace);
  }

  /// Trace / Verbose 日志
  static void t(dynamic message, {String? tag}) {
    if (!enable) return;
    final msg = _format(message, tag: tag);
    talker.verbose(msg);
  }

  /// 无堆栈 Debug 日志（简单输出）
  static void dNoStack(dynamic message, {String? tag}) {
    if (!enable) return;
    final msg = _format(message, tag: tag);
    talker.log(msg, logLevel: LogLevel.debug);
  }

  /// JSON 日志（自动格式化 Map/List/String）
  static void json(dynamic message, {String? tag}) {
    if (!enable) return;
    try {
      final pretty = message is String
          ? JsonEncoder.withIndent('  ').convert(jsonDecode(message))
          : JsonEncoder.withIndent('  ').convert(message);
      talker.debug(tag != null ? '[$tag]\n$pretty' : pretty);
    } catch (_) {
      d(message, tag: tag);
    }
  }

  /// 格式化 message，添加 tag（防止 JSON 转换异常）
  static String _format(dynamic message, {String? tag}) {
    String msg;
    try {
      if (message is Map || message is List) {
        msg = JsonEncoder.withIndent('  ').convert(message);
      } else {
        msg = message.toString();
      }
    } catch (e) {
      msg = message.toString();
    }
    return tag != null ? '[$tag] $msg' : msg;
  }
}

/// ------------------------------------------------------
/// 扩展方法 (与原版保持一致)
/// ------------------------------------------------------
extension StringExtensions on String {
  void logD({String? tag}) => LogHelper.d(this, tag: tag);
  void logW({String? tag}) => LogHelper.w(this, tag: tag);
  void logE({dynamic error, StackTrace? stackTrace, String? tag}) =>
      LogHelper.e(this, error: error, stackTrace: stackTrace, tag: tag);
  void logI({String? tag}) => LogHelper.i(this, tag: tag);
  void logT({String? tag}) => LogHelper.t(this, tag: tag);
  void logJson({String? tag}) => LogHelper.json(this, tag: tag);
  void logDNoStack({String? tag}) => LogHelper.dNoStack(this, tag: tag);
}
