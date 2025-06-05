//
// // 导入包
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:async';
//
// import '../assets/assets.dart';
//
// class NotificationHelper {
//   // 使用单例模式进行初始化
//   static final NotificationHelper _instance = NotificationHelper._internal();
//   factory NotificationHelper() => _instance;
//   NotificationHelper._internal();
//
//   // FlutterLocalNotificationsPlugin是一个用于处理本地通知的插件，它提供了在Flutter应用程序中发送和接收本地通知的功能。
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   // 初始化函数
//   Future<void> initialize() async {
//     // AndroidInitializationSettings是一个用于设置Android上的本地通知初始化的类
//     // 使用了app_icon作为参数，这意味着在Android上，应用程序的图标将被用作本地通知的图标。
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings(CommonR.assetsIcLogo);
//     // 15.1是DarwinInitializationSettings，旧版本好像是IOSInitializationSettings（有些例子中就是这个）
//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings();
//     // 初始化
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS);
//     await _notificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse, // 通用（推荐）
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground, // 后台点击ios/android13+
//     );
//   }
//
//   /// 通用通知细节生成方法
//   NotificationDetails buildNotificationDetails({
//     // =============== iOS专有参数 ===============
//     bool presentAlert = true,
//     bool presentBadge = true,
//     bool presentSound = true,
//     int? badgeNumber,
//     String? subtitle,
//     //String? sound,
//     // =============== Android专有参数 ===============
//     String channelId = 'fcm_default_channel',
//     String channelName = '推送通知',
//     String channelDescription = '应用消息推送通知',
//     Importance importance = Importance.max,
//     Priority priority = Priority.high,
//     String ticker = '通知',
//     bool playSound = true,
//     bool enableVibration = true,
//     bool enableLights = true,
//     String? icon,
//     //Color? color,
//     // =============== 你也可以补充更多参数 ===============
//   }) {
//     final iosDetails = DarwinNotificationDetails(
//       presentAlert: presentAlert,
//       presentBadge: presentBadge,
//       presentSound: presentSound,
//       badgeNumber: badgeNumber,
//       subtitle: subtitle,
//       //sound: sound,
//     );
//
//     final androidDetails = AndroidNotificationDetails(
//       channelId,
//       channelName,
//       channelDescription: channelDescription,
//       importance: importance,
//       priority: priority,
//       ticker: ticker,
//       playSound: playSound,
//       enableVibration: enableVibration,
//       enableLights: enableLights,
//       icon: icon,
//       //color: color,
//     );
//
//     return NotificationDetails(
//       iOS: iosDetails,
//       android: androidDetails,
//     );
//   }
//
//   // Future<void> showLocalNotificationForRemote(RemoteMessage message) async {
//   //   // 1. 获取通知内容。不一定总有 notification 字段（纯data消息可能为null，可以用data兜底）
//   //   RemoteNotification? notification = message.notification;
//   //   AndroidNotification? android = message.notification?.android;
//   //
//   //   // 通知标题&内容，如果没有notification字段可用data中的自定义字段
//   //   String title = notification?.title ?? message.data['title'] ?? '通知';
//   //   String body = notification?.body ?? message.data['body'] ?? '';
//   //
//   //   NotificationDetails details = buildNotificationDetails(
//   //     badgeNumber: int.tryParse(message.data['badge'] ?? ''),
//   //     subtitle: message.data['subtitle'],
//   //     icon: message.notification?.android?.smallIcon,
//   //   );
//   //   // 发起一个通知
//   //   await _notificationsPlugin.show(
//   //     notification?.hashCode ?? DateTime.now().hashCode, // 保证有通知ID。推荐携带业务唯一ID
//   //     title,
//   //     body,
//   //     details,
//   //     payload: message.data.isNotEmpty ? message.data.toString() : null, // 业务自定义跳转参数等
//   //   );
//   // }
//
//   Future<void> showLocalNotification(String title,String message,{String? subtitle}) async {
//     NotificationDetails details = buildNotificationDetails(
//       badgeNumber: 1,
//       subtitle: subtitle,
//     );
//     // 发起一个通知
//     await _notificationsPlugin.show(
//       1, // 保证有通知ID。推荐携带业务唯一ID
//       title,
//       message,
//       details,
//       payload: null, // 业务自定义跳转参数等
//     );
//   }
//
//
//   // 用户点击通知（前台/后台）触发
//   void onDidReceiveNotificationResponse(NotificationResponse response) {
//     print('用户点击了通知，payload: ${response.payload}');
//     // 这里可以跳转页面等
//   }
//
//
// // 新版需要加一个后台tap支持
//   @pragma('vm:entry-point')
//   void notificationTapBackground(NotificationResponse notificationResponse) {
//     print('后台点击通知: ${notificationResponse.payload}');
//   }
// }