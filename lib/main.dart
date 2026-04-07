import 'dart:async';
import 'dart:io';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:common_core/base/base_stateful_widget.dart';
import 'package:common_core/common_core.dart';
import 'package:common_core/helpter/talker_helper.dart';
import 'package:common_core/style/theme.dart' as core_theme;
import 'package:common_core/net/dio_utils.dart';
import 'package:dd_check_plugin/dd_check_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_commonlib/auth/auth_service.dart';
import 'package:flutter_commonlib/router/router_config.dart';
import 'package:flutter_commonlib/settings/locale_theme_controller.dart';
import 'package:flutter_commonlib/theme/apple_hig_theme.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'api/http_api.dart';
import 'generated/json/base/json_convert_content.dart';

/// FCM 后台 isolate 入口，须顶层且带 [pragma]；内联再调 [Firebase.initializeApp]。
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await CommonCore().init();

    await Get.putAsync<AuthService>(() async {
      final auth = AuthService();
      await auth.init();
      return auth;
    });

    Get.put(LocaleThemeController());
    await Get.find<LocaleThemeController>().load();

    HttpUtils.init(HttpApi.baseUrl, JsonConvert.fromJsonAsT, headers: {
      "App-Version": "1.0.0",
      "App-Platform": "flutter",
    });

    /// 仅 Debug 连接本机抓包；发布包不初始化。
    /// 抓包机不可达时会长时间阻塞 socket，故加超时，避免一直停在原生启动图。
    if (kDebugMode) {
      try {
        await DdCheckPlugin()
            .init(
              HttpUtils.dio,
              initHost: "192.168.31.101",
              projectName: "X",
              connectSuccess: (Socket socket, SocketConnect connect) {
                "DdCheckPlugin connectSuccess".logI();
              },
            )
            .timeout(const Duration(seconds: 3));
      } on TimeoutException {
        "DdCheckPlugin init 超时，已跳过（请检查 initHost 网络）".logI();
      } catch (e, st) {
        "DdCheckPlugin init 失败: $e".logI();
        assert(() {
          debugPrintStack(stackTrace: st);
          return true;
        }());
      }
    }
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(exception: error, stack: stack),
      );
    }
    if (Firebase.apps.isNotEmpty) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 首帧后再移除原生启动图，避免部分机型上 remove 过早无效而一直停在欢迎页。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    if (!currentRouterController.isClosed) {
      currentRouterController.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeTheme = Get.find<LocaleThemeController>();
    return Obx(
      () => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: localeTheme.appMaterialLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, supported) {
        return basicLocaleListResolution(locales, supported);
      },
      theme: localeTheme.isAppleDesign
          ? AppleHigTheme.lightTheme
          : core_theme.appLightThemeData,
      darkTheme: localeTheme.isAppleDesign
          ? AppleHigTheme.darkTheme
          : core_theme.appDarkThemeData,
      themeMode: localeTheme.materialThemeMode,
      initialRoute: RouterUrlConfig.main,
      builder: (context, child) {
        final smartChild = FlutterSmartDialog.init()(context, child);
        final mq = MediaQuery.of(context);
        final clamped = mq.textScaler.clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.45,
        );
        return MediaQuery(
          data: mq.copyWith(textScaler: clamped),
          child: smartChild,
        );
      },
      navigatorObservers: <NavigatorObserver>[
        routeObserver,
        if (kDebugMode) ChuckerFlutter.navigatorObserver,
      ],
      routingCallback: (routing) {
        if (!currentRouterController.isClosed) {
          currentRouterController.add("${routing?.current}");
        }
      },
      getPages: pages,
    ),
    );
  }
}
