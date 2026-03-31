import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// 品牌种子色：靛蓝偏紫，亮/暗由 [ColorScheme.fromSeed] 展开。
const Color _kSeed = Color(0xFF4F46E5);

/// 暗黑模式主题（Material 3）
final ThemeData appDarkThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _kSeed,
    brightness: Brightness.dark,
    surface: const Color(0xFF0F172A),
  ),
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 1,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
  ),
);

/// 明亮模式主题（Material 3）
final ThemeData appLightThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _kSeed,
    brightness: Brightness.light,
    surface: const Color(0xFFF8FAFC),
  ),
  scaffoldBackgroundColor: const Color(0xFFF1F5F9),
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    backgroundColor: Color(0xFFF8FAFC),
    surfaceTintColor: Color(0x1A000000),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
  ),
);

/// 当前是否暗黑模式
bool isDarkMode() {
  return Get.isDarkMode || Get.isPlatformDarkMode;
}

ThemeData getThemeData() => isDarkMode() ? appDarkThemeData : appLightThemeData;

TextTheme getThemeTextTheme() => getThemeData().textTheme;

/// 状态栏与导航栏与主题对齐（浅色页用深字，深色页用浅字）
SystemUiOverlayStyle getStatusBarStyle() {
  final dark = isDarkMode();
  final surface = dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
    systemNavigationBarColor: surface,
    systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
  );
}

void changeStatusBarColor({Color? color, Brightness? iconBrightness}) {
  final dark = isDarkMode();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color ?? Colors.transparent,
      statusBarIconBrightness:
          iconBrightness ?? (dark ? Brightness.light : Brightness.dark),
      systemNavigationBarColor: color ?? (dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
      systemNavigationBarIconBrightness:
          iconBrightness ?? (dark ? Brightness.light : Brightness.dark),
    ),
  );
}
