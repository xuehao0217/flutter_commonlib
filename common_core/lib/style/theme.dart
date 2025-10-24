import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// =======================
/// 全局主题管理配置
/// =======================

/// 🌙 暗黑模式主题
final ThemeData appDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white54,
  ),
);

/// ☀️ 明亮模式主题
final ThemeData appLightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.deepPurpleAccent,
    unselectedItemColor: Colors.grey,
  ),
);

/// =======================
/// 工具方法
/// =======================

/// 当前是否暗黑模式
bool isDarkMode() {
  // 优先 GetX 的手动暗黑模式，其次根据系统判断
  return Get.isDarkMode || Get.isPlatformDarkMode;
}

/// 获取当前主题数据（亮/暗自动适配）
ThemeData getThemeData() => isDarkMode() ? appDarkThemeData : appLightThemeData;

/// 获取当前文本样式
TextTheme getThemeTextTheme() => getThemeData().textTheme;

/// 获取状态栏样式（适配亮/暗主题）
SystemUiOverlayStyle getStatusBarStyle() {
  final dark = isDarkMode();
  return SystemUiOverlayStyle(
    statusBarColor: dark ? Colors.black : Colors.white,
    statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
    systemNavigationBarColor: dark ? Colors.black : Colors.white,
    systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
  );
}

/// 动态修改状态栏样式
///
/// [color] 为 `null` 时不修改背景色，保持透明；
/// [iconBrightness] 可选传入以自定义图标亮度。
void changeStatusBarColor({Color? color, Brightness? iconBrightness}) {
  final dark = isDarkMode();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color ?? (dark ? Colors.black : Colors.white),
      statusBarIconBrightness:
      iconBrightness ?? (dark ? Brightness.light : Brightness.dark),
      systemNavigationBarColor: color ?? (dark ? Colors.black : Colors.white),
      systemNavigationBarIconBrightness:
      iconBrightness ?? (dark ? Brightness.light : Brightness.dark),
    ),
  );
}
