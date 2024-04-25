import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpter/status_utils.dart';
import '../widget/get_build_widget.dart';

//创建Dark ThemeData对象
final ThemeData appDarkThemeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white10,

    ///主色调
    // 主要部分背景颜色（导航和tabBar等）
    scaffoldBackgroundColor: Colors.black,
    //Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
    textTheme:
        TextTheme(displayLarge: TextStyle(color: Colors.yellow, fontSize: 15)),
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.yellow)));

//创建light ThemeData对象
final ThemeData appLightThemeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,

    ///主色调
    // 主要部分背景颜色（导航和tabBar等）
    scaffoldBackgroundColor: Colors.white,
    //Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
    textTheme:
        TextTheme(displayLarge: TextStyle(color: Colors.blue, fontSize: 15)),
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black)));

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
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color,
    statusBarIconBrightness: iconBrightness,
  ));
}
