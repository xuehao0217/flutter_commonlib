import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class StatusBarUtils {
  //isDarkForeground true 浅色  false 深色
  static void changeStatusColor(Color color, bool isDarkForeground) async {
    // try {
    //   await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    //   setStatusBarWhiteForeground(isDarkForeground);
    // } on PlatformException catch (e) {
    //   debugPrint(e.toString());
    // }
    // setStatusBarWhiteForeground(isDarkForeground);
  }


  //isDarkForeground true 浅色  false 深色
  static void setStatusBarWhiteForeground(bool isDarkForeground) async {
    // try {
    //   //状态栏前景图标文字 是否是浅色 true 浅色  false 深色
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(!isDarkForeground);
    //   //NavigationBar前景图标文字 是否是浅色 true 浅色  false 深色
    //   FlutterStatusbarcolor.setNavigationBarWhiteForeground(!isDarkForeground);
    // } on PlatformException catch (e) {
    //   debugPrint(e.toString());
    // }
  }
}
