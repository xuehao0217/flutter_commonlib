import 'dart:async';
import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:common_core/base/base_stateful_widget.dart';
import 'package:common_core/common_core.dart';
import 'package:common_core/helpter/logger_helper.dart';
import 'package:common_core/helpter/notification_helper.dart';
import 'package:common_core/net/dio_utils.dart';
import 'package:common_core/style/theme.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/router/router_config.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'api/http_api.dart';
import 'generated/assets.dart';
import 'generated/json/base/json_convert_content.dart';

Future<void> main() async {
  await CommonCore().init(R.assetsIcLogo);

  HttpUtils.init(HttpApi.baseUrl,JsonConvert.fromJsonAsT,headers: {
    "App-Version": "1.0.0",
    "App-Platform": "flutter",
  });

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      theme: appLightThemeData,
      darkTheme: appDarkThemeData,
      themeMode: ThemeMode.system,
      initialRoute: RouterRULConfig.main,
      builder: FlutterSmartDialog.init(),
      // 注册路由观察者
      navigatorObservers: <NavigatorObserver>[routeObserver,ChuckerFlutter.navigatorObserver],
      routingCallback: (routing) {
        currentRouterController.add("${routing?.current}");
      },
      // 定义路由表
      getPages: pages,
    );
  }
}
