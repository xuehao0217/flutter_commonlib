import 'package:intl/intl.dart';

// final now = DateTime.now();
// print(TimeHelper.formatDateTime(now));
// print(TimeHelper.now());
// print(TimeHelper.timestampMillis());
// print(TimeHelper.fromTimestamp(1730178312123));
// print(TimeHelper.utcToLocal("2025-10-22T08:45:12Z"));
// print(TimeHelper.formatCountdown(Duration(hours: 2, minutes: 5, seconds: 10)));
// print(TimeHelper.friendlyTime(DateTime.now().subtract(Duration(minutes: 5))));
// print(TimeHelper.nowMap());

// final timeMap = TimeHelper.nowFull();
// print(timeMap);
//   {
//     local: 2025-10-22 16:45:12,
//     utc: 2025-10-22 08:45:12,
//     timestampMillis: 1730178312123,
//     timestampSeconds: 1730178312,
//     friendly: 今天 16:45
//   }
// // 获取单独字段
// print(timeMap['friendly']);
// print(timeMap['utc']);


class TimeHelper {
  /// 格式化 DateTime
  static String formatDateTime(
    DateTime dateTime, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
  }) {
    return DateFormat(pattern).format(dateTime);
  }

  /// 当前时间字符串
  static String now({String pattern = 'yyyy-MM-dd HH:mm:ss'}) {
    return formatDateTime(DateTime.now(), pattern: pattern);
  }

  /// 当前时间戳（毫秒）
  static int timestampMillis() => DateTime.now().millisecondsSinceEpoch;

  /// 当前时间戳（秒）
  static int timestampSeconds() =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000;

  /// 时间戳（毫秒）转字符串
  static String fromTimestamp(
    int timestampMillis, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
  }) {
    return formatDateTime(
      DateTime.fromMillisecondsSinceEpoch(timestampMillis),
      pattern: pattern,
    );
  }

  /// 时间戳（秒）转字符串
  static String fromTimestampSeconds(
    int timestampSeconds, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
  }) {
    return formatDateTime(
      DateTime.fromMillisecondsSinceEpoch(timestampSeconds * 1000),
      pattern: pattern,
    );
  }

  /// 字符串转 DateTime
  static DateTime parse(
    String dateStr, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
  }) {
    return DateFormat(pattern).parse(dateStr);
  }

  /// DateTime 转时间戳
  static int toTimestampMillis(DateTime dt) => dt.millisecondsSinceEpoch;

  static int toTimestampSeconds(DateTime dt) =>
      dt.millisecondsSinceEpoch ~/ 1000;

  /// 延迟执行
  static Future<void> delay(int seconds, Function callback) async {
    await Future.delayed(Duration(seconds: seconds));
    callback();
  }

  /// 获取本地时间 / UTC 时间 / 时间戳 Map
  static Map<String, dynamic> nowMap({String pattern = 'yyyy-MM-dd HH:mm:ss'}) {
    final now = DateTime.now();
    final utc = now.toUtc();
    return {
      'local': formatDateTime(now, pattern: pattern),
      'utc': formatDateTime(utc, pattern: pattern),
      'timestampMillis': now.millisecondsSinceEpoch,
      'timestampSeconds': now.millisecondsSinceEpoch ~/ 1000,
    };
  }

  /// 判断是否是今天
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// 判断是否本周
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    return date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
        date.isBefore(weekEnd);
  }

  /// 判断是否本月
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// 时间加减
  static DateTime addDays(DateTime date, int days) =>
      date.add(Duration(days: days));

  static DateTime addHours(DateTime date, int hours) =>
      date.add(Duration(hours: hours));

  static DateTime addMinutes(DateTime date, int minutes) =>
      date.add(Duration(minutes: minutes));

  static DateTime addSeconds(DateTime date, int seconds) =>
      date.add(Duration(seconds: seconds));

  /// 获取两个时间差，返回 Map（天/小时/分钟/秒）
  static Map<String, int> diff(DateTime from, DateTime to) {
    final diff = to.difference(from);
    return {
      'days': diff.inDays,
      'hours': diff.inHours % 24,
      'minutes': diff.inMinutes % 60,
      'seconds': diff.inSeconds % 60,
    };
  }

  /// UTC 转本地时间字符串
  static String utcToLocal(
    String utcStr, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
  }) {
    final dt = DateTime.parse(utcStr).toLocal();
    return formatDateTime(dt, pattern: pattern);
  }

  /// 格式化倒计时，返回 HH:mm:ss
  static String formatCountdown(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(duration.inHours);
    final m = twoDigits(duration.inMinutes % 60);
    final s = twoDigits(duration.inSeconds % 60);
    return '$h:$m:$s';
  }

  /// 友好时间显示，比如：刚刚 / 5分钟前 / 今天 12:34 / 昨天 12:34 / 2025-10-20
  static String friendlyTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (isToday(dateTime))
      return '今天 ${formatDateTime(dateTime, pattern: 'HH:mm')}';
    if (isToday(dateTime.subtract(const Duration(days: 1))))
      return '昨天 ${formatDateTime(dateTime, pattern: 'HH:mm')}';
    return formatDateTime(dateTime, pattern: 'yyyy-MM-dd');
  }

  /// 综合时间信息 Map
  ///
  /// 返回示例：
  /// {
  ///   'local': '2025-10-22 16:45:12',
  ///   'utc': '2025-10-22 08:45:12',
  ///   'timestampMillis': 1730178312123,
  ///   'timestampSeconds': 1730178312,
  ///   'friendly': '今天 16:45'
  /// }
  static Map<String, dynamic> nowFull({String pattern = 'yyyy-MM-dd HH:mm:ss'}) {
    final now = DateTime.now();
    return {
      'local': formatDateTime(now, pattern: pattern),
      'utc': formatDateTime(now.toUtc(), pattern: pattern),
      'timestampMillis': now.millisecondsSinceEpoch,
      'timestampSeconds': now.millisecondsSinceEpoch ~/ 1000,
      'friendly': friendlyTime(now),
    };
  }
}
