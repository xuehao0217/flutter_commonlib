import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

//创建Dark ThemeData对象
final ThemeData appDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,

  ///主色调
  // 主要部分背景颜色（导航和tabBar等）
  scaffoldBackgroundColor: Colors.black,

  //Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  //设置AppBar的主题
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.black),
  ),
);

//创建light ThemeData对象
final ThemeData appLightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,

  ///主色调
  // 主要部分背景颜色（导航和tabBar等）
  scaffoldBackgroundColor: Colors.white,

  //Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Colors.transparent,
  ),
);

bool isDarkMode() {
  // if (Get.isPlatformDarkMode) {
  //   return true;
  // } else {
  //   if (Get.isDarkMode) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  return Get.isDarkMode || Get.isPlatformDarkMode;
}

ThemeData getThemeData() {
  if (isDarkMode()) {
    return appDarkThemeData;
  } else {
    return appLightThemeData;
  }
}

TextTheme getThemeTextTheme() => getThemeData().textTheme;

// return AnnotatedRegion<SystemUiOverlayStyle>(
//   value: getStatusBarStyle(),
//   child: _buildContent(),
// );
SystemUiOverlayStyle getStatusBarStyle() {
  //MediaQuery.of(context).platformBrightness == Brightness.dark
  final isDarkModeTheme = isDarkMode();
  final statusBarColor =
      isDarkModeTheme ? Colors.black : Colors.white; // 根据暗黑模式选择颜色
  final statusBarIconBrightness =
      isDarkModeTheme ? Brightness.light : Brightness.dark; // 根据暗黑模式选择图标颜色
  return SystemUiOverlayStyle(
    statusBarColor: statusBarColor,
    statusBarIconBrightness: statusBarIconBrightness,
  );
}

//color 为null 不显示状态栏
void changeStatusBarColor({Color? color, Brightness? iconBrightness}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarIconBrightness: iconBrightness,
    ),
  );
}
