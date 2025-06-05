library common_core;

import 'dart:ui';

import 'package:common_core/helpter/log_utils.dart';
import 'package:common_core/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:chucker_flutter/chucker_flutter.dart';

class CommonCore {
  static Future<void> initApp() async {
    ChuckerFlutter.showOnRelease = true;
    ChuckerFlutter.showNotification = true;
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // 一键开启沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode() ? Brightness.light : Brightness.dark,
      ),
    );
    // 限制竖屏
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Log.init();
    // NotificationHelper().initialize();
  }
}
