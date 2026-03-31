import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'logger_helper.dart';

/// 请求并检查通知权限（Android 13+ / iOS）。
///
/// Android：须已在 Manifest 中声明 [POST_NOTIFICATIONS]。
/// 返回 `true` 表示可展示通知（或当前平台无需请求）。
Future<bool> ensureNotificationPermissions(
  FlutterLocalNotificationsPlugin plugin,
) async {
  if (kIsWeb) return false;
  try {
    if (Platform.isAndroid) {
      final android = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final already = await android?.areNotificationsEnabled() ?? false;
      if (already) return true;
      final granted = await android?.requestNotificationsPermission();
      if (granted == true) return true;
      return await android?.areNotificationsEnabled() ?? false;
    }
    if (Platform.isIOS) {
      final ios = plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final r = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return r ?? false;
    }
    if (Platform.isMacOS) {
      final mac = plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      final r = await mac?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return r ?? false;
    }
  } catch (e, st) {
    LoggerHelper.e(
      'ensureNotificationPermissions failed',
      error: e,
      stackTrace: st,
    );
  }
  return true;
}

typedef NotificationTapCallback = void Function(NotificationResponse response);

NotificationTapCallback? onForegroundTap;
NotificationTapCallback? onBackgroundTap;

/// 设置前台通知点击回调
/// [callback] 前台通知点击时触发的回调函数
void setOnForegroundTap(NotificationTapCallback callback) {
  onForegroundTap = callback;
}

/// 设置后台通知点击回调
/// [callback] 后台通知点击时触发的回调函数
void setOnBackgroundTap(NotificationTapCallback callback) {
  onBackgroundTap = callback;
}

/// [flutter_local_notifications] 单例；[showLocalNotification] 前会 [ensureNotificationPermissions]。
class NotificationHelper {
  static final NotificationHelper instance = NotificationHelper._internal();

  factory NotificationHelper() => instance;

  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 初始化通知插件
  ///
  /// [androidDefaultIcon] 须为 **Android drawable 资源名**（如 `ic_stat_notification`），
  /// 不能传 Flutter 的 `assets/...` 路径，否则 small icon 解析失败、通知无法展示。
  Future<void> initialize({String androidDefaultIcon = 'ic_stat_notification'}) async {
    try {
      final androidInit = AndroidInitializationSettings(androidDefaultIcon);
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
      );

      final settings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _notificationsPlugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotification,
      );

      LoggerHelper.d(
        "NotificationHelper initialized, Android icon drawable: $androidDefaultIcon",
      );
    } catch (e, st) {
      LoggerHelper.e(
        "NotificationHelper initialization failed",
        error: e,
        stackTrace: st,
      );
    }
  }

  /// 构建通知详情对象，用于显示本地通知
  ///
  /// [localImagePath] 本地图片路径，用于显示大图（iOS/Darwin 和 Android）
  ///
  /// iOS 专有参数：
  /// [presentAlert] 是否展示弹窗
  /// [presentBadge] 是否更新应用角标
  /// [presentSound] 是否播放通知声音
  /// [badgeNumber] iOS 应用角标数量
  /// [subtitle] iOS 通知副标题
  ///
  /// Android 专有参数：
  /// [channelId] 通知渠道ID
  /// [channelName] 通知渠道名称
  /// [channelDescription] 通知渠道描述
  /// [importance] 通知重要性
  /// [priority] 通知优先级
  /// [ticker] Android 状态栏滚动文本
  /// [playSound] 是否播放声音
  /// [enableVibration] 是否振动
  /// [enableLights] 是否闪灯
  /// [icon] Android small icon 的 drawable 名（默认 `ic_stat_notification`）
  NotificationDetails buildNotificationDetails({
    String? localImagePath,
    // iOS
    bool presentAlert = true,
    bool presentBadge = true,
    bool presentSound = true,
    int? badgeNumber,
    String? subtitle,
    // Android
    String channelId = 'fcm_default_channel',
    String channelName = '推送通知',
    String channelDescription = '应用消息推送通知',
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    String ticker = '通知',
    bool playSound = true,
    bool enableVibration = true,
    bool enableLights = true,
    String? icon,
  }) {
    final iosDetails = DarwinNotificationDetails(
      presentAlert: presentAlert,
      presentBadge: presentBadge,
      presentSound: presentSound,
      badgeNumber: badgeNumber,
      subtitle: subtitle,
      attachments:
          localImagePath != null
              ? [DarwinNotificationAttachment(localImagePath)]
              : null,
    );

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      ticker: ticker,
      playSound: playSound,
      enableVibration: enableVibration,
      enableLights: enableLights,
      icon: (icon != null && icon.isNotEmpty) ? icon : 'ic_stat_notification',
      largeIcon:
          localImagePath != null ? FilePathAndroidBitmap(localImagePath) : null,
    );

    return NotificationDetails(iOS: iosDetails, android: androidDetails);
  }

  /// 显示本地通知
  ///
  /// [title] 通知标题
  /// [body] 通知内容
  /// [id] 通知ID，用于区分不同通知，默认 1
  /// [notificationDetails] 自定义通知细节对象，如果为空会使用默认构建方法
  /// [payload] 通知附带数据，可用于跳转页面或传递业务参数
  ///
  /// 返回是否已成功发起展示（含权限通过）；未授权时为 `false`。
  Future<bool> showLocalNotification(
    String title,
    String body, {
    int id = 1,
    NotificationDetails? notificationDetails,
    String? payload,
  }) async {
    try {
      final ok = await ensureNotificationPermissions(_notificationsPlugin);
      if (!ok) {
        LoggerHelper.w(
          'Local notification skipped: permission not granted',
          tag: 'Notification',
        );
        return false;
      }
      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails ?? buildNotificationDetails(),
        payload: payload,
      );
      LoggerHelper.d("Notification shown: $title, id: $id, payload: $payload");
      return true;
    } catch (e, st) {
      LoggerHelper.e("Failed to show notification", error: e, stackTrace: st);
      return false;
    }
  }
}

/// 前台通知点击回调
/// [response] 用户点击通知后的回调信息
void onDidReceiveNotification(NotificationResponse response) {
  try {
    LoggerHelper.d("Foreground notification tapped: ${response.payload}");
    onForegroundTap?.call(response);
  } catch (e, st) {
    LoggerHelper.e("Error handling foreground tap", error: e, stackTrace: st);
  }
}

/// 后台通知点击回调
/// [response] 用户点击通知后的回调信息（后台/应用关闭状态触发）
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotification(NotificationResponse response) {
  try {
    LoggerHelper.d("Background notification tapped: ${response.payload}");
    onBackgroundTap?.call(response);
  } catch (e, st) {
    LoggerHelper.e("Error handling background tap", error: e, stackTrace: st);
  }
}
