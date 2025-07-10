// import 'dart:convert';
//
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'logger_helper.dart';
// import 'notification_helper.dart';
//
// /// 需要手动添加 : FCM 的 onBackgroundMessage handler 必须是顶层函数或静态函数
// // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   await Firebase.initializeApp();
// //   // 数据存本地/发本地通知等
// //   LoggerHelper.d("firebaseMessagingBackgroundHandler===${message.data}");
// // }
//
// class FirebaseHelper {
//   static final FirebaseHelper instance = FirebaseHelper._internal();
//
//   FirebaseHelper._internal();
//
//   factory FirebaseHelper() => instance;
//
//   /// 只调用一次
//   Future<void> init() async {
//     await Firebase.initializeApp();
//     await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//
//
//     final FlutterExceptionHandler? originalOnError = FlutterError.onError;
//     FlutterError.onError = (FlutterErrorDetails details) async {
//       await FirebaseCrashlytics.instance.recordFlutterError(details);
//       if (originalOnError != null) {
//         originalOnError(details);
//       } else {
//         FlutterError.dumpErrorToConsole(details);
//       }
//     };
//
//
//
//     final settings = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       LoggerHelper.d('用户授权了通知权限');
//     } else {
//       LoggerHelper.d('用户拒绝了通知权限');
//     }
//
//     //var deviceToken = await FirebaseMessaging.instance.getToken();
//     // LoggerHelper.d('FCM 设备Token: $deviceToken');
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       LoggerHelper.d(
//         "收到前台消息 FirebaseMessaging.onMessage---${message.notification?.title}----${message.notification?.body}-----${message.data}",
//       );
//       showLocalNotificationForRemote(message);
//     });
//   }
//
//
//   void setPushTapCallback(OnPushTapCallback callback) {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // App在后台/挂起，通过系统通知栏进入
//       callback.call(message, PushSource.MessageOpenedApp);
//     });
//
//     // 终止时启动，只需调用一次，可用Future自行管理只触发一次
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         // App被终止，点击推送启动
//         callback.call(message, PushSource.InitialMessage);
//       }
//     });
//   }
//
//
//   Future<void> showLocalNotificationForRemote(RemoteMessage message) async {
//     // 1. 获取通知内容。不一定总有 notification 字段（纯data消息可能为null，可以用data兜底）
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//
//     // 通知标题&内容，如果没有notification字段可用data中的自定义字段
//     String title = notification?.title ?? message.data['title'] ?? '';
//     String body = notification?.body ?? message.data['body'] ?? '';
//
//     NotificationDetails details = NotificationHelper.instance.buildNotificationDetails(
//       badgeNumber: int.tryParse(message.data['badge'] ?? ''),
//       subtitle: message.data['subtitle'],
//       icon: message.notification?.android?.smallIcon,
//     );
//     // 发起一个通知
//     NotificationHelper.instance.showLocalNotification(title, body,id:notification?.hashCode ?? DateTime.now().hashCode,
//       notificationDetails: details,
//       payload: jsonEncode(message.data), // 业务自定义跳转参数等
//     );
//   }
//
//
// }
//
//
// typedef OnPushTapCallback =void Function(RemoteMessage message, PushSource source);
// enum PushSource { MessageOpenedApp, InitialMessage }
