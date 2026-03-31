/// `common_core`：可复用壳层与工具集合。
///
/// - 入口：[CommonCore.init] 串联启动图、系统 UI、Chucker、本地通知、SP、Firebase 等。
/// - 对外导出：通用组件（[CommonTitleBar]、[BottomNavigationBarWidget] 等）、扩展与 WebView 页，详见下方 `export`。
/// - 宿主须在 `main` 中调用 [HttpUtils.init] 配置 baseUrl 与 JSON 解析。
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

/// 应用壳层初始化入口，由宿主在 `main` 中 `await` 调用一次。
class CommonCore {
  /// [androidNotificationIcon]：Android 通知 small icon 的 **drawable 资源名**（如 `ic_stat_notification`），勿传 `assets/...` 路径。
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

/// 移除启动图（若 [CommonCore.init] 中已 `preserve`）。
void removeSplash() {
  FlutterNativeSplash.remove();
}

/// 打开 Talker 诊断页（依赖 [talker] 单例）。
void openTalkerScreen() {
  Get.to(() => TalkerScreen(talker: talker));
}
