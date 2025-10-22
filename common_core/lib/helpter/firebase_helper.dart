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
import 'notification_helper.dart';

/// 需要手动添加 : FCM 的 onBackgroundMessage handler 必须是顶层函数或静态函数
// FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // 数据存本地/发本地通知等
//   LoggerHelper.d("firebaseMessagingBackgroundHandler===${message.data}");
// }

void main() {
  setOnForegroundTap((response) {
    final map = jsonDecode(response.payload.toString());
    var router = map["router"];
    var arguments = map["arguments"];
  });

  setOnBackgroundTap((response) {
    LoggerHelper.d('后台点击通知回调 payload: ${response}');
  });

  // 设置推送点击回调
  FirebaseHelper.instance.setPushTapCallback((message, source) {
    LoggerHelper.d(
      "Push tapped! Source: $source, payload: ${message.data}",
      tag: "Main",
    );
    // 这里可以根据 message.data 跳转页面
  });
}

typedef OnPushTapCallback =
    void Function(RemoteMessage message, PushSource source);

enum PushSource { MessageOpenedApp, InitialMessage }

class FirebaseHelper {
  // 单例
  static final FirebaseHelper instance = FirebaseHelper._internal();

  factory FirebaseHelper() => instance;

  FirebaseHelper._internal();

  /// 初始化 Firebase 和 FCM
  /// 只需调用一次
  Future<void> initFirebaseMessaging() async {
    await Firebase.initializeApp();

    // Crashlytics 开启
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    _setupFlutterErrorHandling();

    // 请求通知权限
    await _requestNotificationPermission();

    // 前台消息监听
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    LoggerHelper.d("FirebaseMessaging initialized");
  }

  /// 设置推送点击回调
  void setPushTapCallback(OnPushTapCallback callback) {
    // App 在后台/挂起，通过系统通知栏进入
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      LoggerHelper.d("onMessageOpenedApp: ${message.data}");
      callback.call(message, PushSource.MessageOpenedApp);
    });

    // App 被终止，通过系统通知栏启动
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        LoggerHelper.d("getInitialMessage: ${message.data}");
        callback.call(message, PushSource.InitialMessage);
      }
    });
  }

  /// 前台消息处理
  void _handleForegroundMessage(RemoteMessage message) {
    LoggerHelper.d(
      "Foreground message received: "
      "${message.notification?.title} - ${message.notification?.body} - ${message.data}",
    );
    _showLocalNotification(message);
  }

  /// 显示本地通知
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final title = notification?.title ?? '';
      final body = notification?.body ?? '';
      final badge = int.tryParse(message.data['badge'] ?? '');
      final subtitle = message.data['subtitle'] ?? '';
      final icon = notification?.android?.smallIcon ?? '';

      // 下载 iOS/Android 通知图片
      String? localImagePath;
      final imageUrl =
          notification?.android?.imageUrl ??
          notification?.apple?.imageUrl ??
          '';
      if (imageUrl.isNotEmpty) {
        localImagePath = await _downloadAndSaveImage(
          imageUrl,
          'push_image.jpg',
        );
      }

      final details = NotificationHelper.instance.buildNotificationDetails(
        localImagePath: localImagePath,
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
    } catch (e, st) {
      LoggerHelper.e(
        "Failed to show local notification",
        error: e,
        stackTrace: st,
      );
    }
  }

  /// 下载并保存图片到本地
  Future<String?> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final response = await http.get(Uri.parse(url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      LoggerHelper.d("Image downloaded: $filePath");
      return filePath;
    } catch (e) {
      LoggerHelper.e("Image download failed: $url", error: e);
      return null;
    }
  }

  /// 设置 FlutterError 全局异常捕获并上传 Crashlytics
  void _setupFlutterErrorHandling() {
    final FlutterExceptionHandler? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) async {
      await FirebaseCrashlytics.instance.recordFlutterError(details);
      if (originalOnError != null) {
        originalOnError(details);
      } else {
        FlutterError.dumpErrorToConsole(details);
      }
    };
  }

  /// 请求通知权限
  Future<void> _requestNotificationPermission() async {
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
  }
}
