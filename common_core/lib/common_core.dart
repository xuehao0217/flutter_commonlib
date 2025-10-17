library common_core;

import 'package:common_core/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'helpter/notification_helper.dart';
import 'helpter/sp_helper.dart';
export 'helpter/widget_ext_helper.dart';
export 'widget/common_dialog.dart';
export 'widget/bottom_navigation_bar.dart';
export 'widget/common_listview.dart';
export 'widget/common_widget.dart';
export 'widget/input_widget.dart';
export 'widget/tab_widget.dart';
export 'widget/webview/web_view.dart';

class CommonCore {
  Future<void> init(String logo) async {

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

    ChuckerFlutter.showOnRelease = true;
    ChuckerFlutter.showNotification = false;

    NotificationHelper().initialize(logo);
    SPUtil.init();
    // FirebaseHelper().init();
  }
}



void removeSplash() {
  FlutterNativeSplash.remove();
}