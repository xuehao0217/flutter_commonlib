import 'dart:convert';
import 'dart:io';

import 'package:extended_image/extended_image.dart' as http;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'logger_helper.dart';

/// 需要手动添加 : FCM 的 onBackgroundMessage handler 必须是顶层函数或静态函数
// FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // 数据存本地/发本地通知等
//   LoggerHelper.d("firebaseMessagingBackgroundHandler===${message.data}");
// }

class FirebaseHelper {
  static final FirebaseHelper instance = FirebaseHelper._internal();

  FirebaseHelper._internal();

  factory FirebaseHelper() => instance;

  /// 只调用一次
  Future<void> initFirebaseMessaging() async {
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    final FlutterExceptionHandler? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) async {
      await FirebaseCrashlytics.instance.recordFlutterError(details);
      if (originalOnError != null) {
        originalOnError(details);
      } else {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LoggerHelper.d('用户授权了通知权限');
    } else {
      LoggerHelper.d('用户拒绝了通知权限');
    }

    //var deviceToken = await FirebaseMessaging.instance.getToken();
    // LoggerHelper.d('FCM 设备Token: $deviceToken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LoggerHelper.d(
        "收到前台消息 FirebaseMessaging.onMessage---${message.notification?.title}----${message.notification?.body}-----${message.data}",
      );
      showLocalNotificationForRemote(message);
    });
  }

  void setPushTapCallback(OnPushTapCallback callback) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // App在后台/挂起，通过系统通知栏进入
      callback.call(message, PushSource.MessageOpenedApp);
    });

    // 终止时启动，只需调用一次，可用Future自行管理只触发一次
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // App被终止，点击推送启动
        callback.call(message, PushSource.InitialMessage);
      }
    });
  }

  Future<void> showLocalNotificationForRemote(RemoteMessage message) async {
    final notification = message.notification;
    // 统一提取公共字段
    final title = notification?.title ?? '';
    final body = notification?.body ?? '';
    final badge = int.tryParse(message.data['badge'] ?? '');
    final subtitle = message.data['subtitle'] ?? "";
    final icon = notification?.android?.smallIcon ?? "";

    final androidImage = message.notification?.android?.imageUrl ?? "";
    final iosImage = message.notification?.apple?.imageUrl ?? "";

    String? imagePath;
    if (iosImage.isNotEmpty) {
      imagePath = await _downloadAndSaveImage(iosImage, 'push_image.jpg');
    }
    final details = NotificationHelper.instance.buildNotificationDetails(
      localImagePath: imagePath,
      badgeNumber: badge,
      subtitle: subtitle,
      icon: icon,
    );

    await NotificationHelper.instance.showLocalNotification(
      title,
      body,
      id: notification?.hashCode ?? DateTime.now().hashCode,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  Future<String?> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final response = await http.get(Uri.parse(url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      debugPrint("Image download failed: $e");
      return null;
    }
  }
}

typedef OnPushTapCallback =
    void Function(RemoteMessage message, PushSource source);

enum PushSource { MessageOpenedApp, InitialMessage }
