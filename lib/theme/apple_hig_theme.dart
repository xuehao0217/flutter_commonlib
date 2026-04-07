import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Apple Human Interface Guidelines 常用语义色（浅色 / 深色）与 Material 主题桥接。
///
/// 参考：[Human Interface Guidelines — Color](https://developer.apple.com/design/human-interface-guidelines/color)
abstract final class AppleHigTheme {
  /// iOS 系统蓝（浅色）
  static const Color systemBlueLight = Color(0xFF007AFF);

  /// iOS 系统蓝（深色）
  static const Color systemBlueDark = Color(0xFF0A84FF);

  /// 分组表视图背景（systemGroupedBackground）
  static const Color groupedBackgroundLight = Color(0xFFF2F2F7);

  static const Color groupedBackgroundDark = Color(0xFF000000);

  /// 次级分组内容背景（secondarySystemGroupedBackground，浅色近似白色）
  static const Color secondaryGroupedLight = Color(0xFFFFFFFF);

  static const Color secondaryGroupedDark = Color(0xFF1C1C1E);

  static ColorScheme _lightScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: systemBlueLight,
      brightness: Brightness.light,
    );
    return base.copyWith(
      primary: systemBlueLight,
      onPrimary: CupertinoColors.white,
      surface: groupedBackgroundLight,
      onSurface: const Color(0xFF000000),
      onSurfaceVariant: const Color(0x993C3C43),
      outline: const Color(0xFFC6C6C8),
      outlineVariant: const Color(0xFFE5E5EA),
      surfaceContainerLow: secondaryGroupedLight,
      surfaceContainerHigh: secondaryGroupedLight,
      surfaceContainerHighest: const Color(0xFFE5E5EA),
    );
  }

  static ColorScheme _darkScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: systemBlueDark,
      brightness: Brightness.dark,
    );
    return base.copyWith(
      primary: systemBlueDark,
      onPrimary: CupertinoColors.white,
      surface: groupedBackgroundDark,
      onSurface: CupertinoColors.white,
      onSurfaceVariant: const Color(0x99EBEBF5),
      outline: const Color(0xFF38383A),
      outlineVariant: const Color(0xFF48484A),
      surfaceContainerLow: secondaryGroupedDark,
      surfaceContainerHigh: const Color(0xFF2C2C2E),
      surfaceContainerHighest: const Color(0xFF3A3A3C),
    );
  }

  static ThemeData _materialFromScheme(
    ColorScheme scheme,
    Brightness brightness,
  ) {
    final navStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness:
          brightness == Brightness.dark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: scheme.surface,
      systemNavigationBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      primaryColor: scheme.primary,
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: scheme.primary,
        scaffoldBackgroundColor: scheme.surface,
        barBackgroundColor: scheme.surface.withValues(alpha: 0.9),
        applyThemeToAll: true,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: navStyle,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.41,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        textColor: scheme.onSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData lightTheme = _materialFromScheme(_lightScheme(), Brightness.light);
  static ThemeData darkTheme = _materialFromScheme(_darkScheme(), Brightness.dark);
}
