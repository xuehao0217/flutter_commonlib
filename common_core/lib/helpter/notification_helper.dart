// 导入包
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import 'logger_helper.dart';

typedef NotificationTapCallback = void Function(NotificationResponse response);

NotificationTapCallback? onForegroundTap;
NotificationTapCallback? onBackgroundTap;

// 提供注册方法
void setOnForegroundTap(NotificationTapCallback callback) {
  onForegroundTap = callback;
}

void setOnBackgroundTap(NotificationTapCallback callback) {
  onBackgroundTap = callback;
}

class NotificationHelper {
  static final NotificationHelper instance = NotificationHelper._internal();

  factory NotificationHelper() => instance;

  NotificationHelper._internal();

  // FlutterLocalNotificationsPlugin是一个用于处理本地通知的插件，它提供了在Flutter应用程序中发送和接收本地通知的功能。
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 初始化函数
  Future<void> initialize(String logo) async {
    // AndroidInitializationSettings是一个用于设置Android上的本地通知初始化的类
    // 使用了app_icon作为参数，这意味着在Android上，应用程序的图标将被用作本地通知的图标。
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(logo);
    // 15.1是DarwinInitializationSettings，旧版本好像是IOSInitializationSettings（有些例子中就是这个）
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    // 初始化
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      // 通用（推荐）
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotification, // 后台点击ios/android13+
    );
  }

  /// 通用通知细节生成方法
  NotificationDetails buildNotificationDetails({
    String? localImagePath,
    // =============== iOS专有参数 ===============
    bool presentAlert = true,
    bool presentBadge = true,
    bool presentSound = true,
    int? badgeNumber,
    String? subtitle,
    //String? sound,
    // =============== Android专有参数 ===============
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
    //Color? color,
    // =============== 你也可以补充更多参数 ===============
  }) {
    final iosDetails = DarwinNotificationDetails(
      presentAlert: presentAlert,
      presentBadge: presentBadge,
      presentSound: presentSound,
      badgeNumber: badgeNumber,
      subtitle: subtitle,
      attachments: localImagePath != null ? [DarwinNotificationAttachment(localImagePath)] : null,
      //sound: sound,
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
      icon: icon,
      largeIcon:  localImagePath != null ? FilePathAndroidBitmap(localImagePath): null,
      //color: color,
    );
    return NotificationDetails(iOS: iosDetails, android: androidDetails);
  }


  Future<void> showLocalNotification(
    String title,
    String body, {
    int id = 1,
    NotificationDetails? notificationDetails,
    String? payload,
  }) async {
    await _notificationsPlugin.show(
      id, // 保证有通知ID。推荐携带业务唯一ID
      title,
      body,
      notificationDetails ?? buildNotificationDetails(),
      payload: payload, // 业务自定义跳转参数等
    );
  }

}

// 用户点击通知（前台/后台）触发
void onDidReceiveNotification(NotificationResponse response) {
  LoggerHelper.d('NotificationHelper onDidReceiveNotification: ${response}');
  onForegroundTap?.call(response);
  // 这里可以跳转页面等
}

// 新版需要加一个后台tap支持
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotification(NotificationResponse response) {
  LoggerHelper.d(
    'NotificationHelper onDidReceiveBackgroundNotification: ${response}',
  );
  onBackgroundTap?.call(response);
}
