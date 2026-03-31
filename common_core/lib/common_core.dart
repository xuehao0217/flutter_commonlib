/// 公共库入口：[CommonCore.init] 初始化壳层；Widget/工具见下方 export。
library common_core;

import 'dart:convert';
import 'package:common_core/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'helpter/firebase_helper.dart';
import 'helpter/logger_helper.dart';
import 'helpter/notification_helper.dart';
import 'helpter/sp_helper.dart';
import 'helpter/talker_helper.dart';
export 'helpter/widget_ext_helper.dart';
export 'widget/common_dialog.dart';
export 'widget/bottom_navigation_bar.dart';
export 'widget/common_listview.dart';
export 'widget/common_widget.dart';
export 'widget/input_widget.dart';
export 'widget/tab_widget.dart';
export 'widget/webview/web_view.dart';

class CommonCore {
  /// [androidNotificationIcon] 为 Android `res/drawable` 下的资源名，勿传 Flutter `assets/...`。
  Future<void> init({String androidNotificationIcon = 'ic_stat_notification'}) async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    ///一键开启沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode() ? Brightness.light : Brightness.dark,

        // systemNavigationBarColor: Colors.transparent, // 导航栏背景色
        // systemNavigationBarDividerColor: Colors.transparent, // 导航栏分割线颜色
        // systemNavigationBarIconBrightness: Brightness.dark, // 导航栏图标颜色（深色）
      ),
    );

    //限制竖屏
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 发布包不展示 Chucker 调试入口；开发/Profile 可按需改为 true
    ChuckerFlutter.showOnRelease = false;
    ChuckerFlutter.showNotification = false;

    NotificationHelper().initialize(androidDefaultIcon: androidNotificationIcon);

    SPUtil.init();

    FirebaseHelper().initFirebaseMessaging();
  }
}

void removeSplash() {
  FlutterNativeSplash.remove();
}


void openTalkerScreen() {
  Get.to(() => TalkerScreen(talker: talker));
}
