import 'package:common_core/helpter/sp_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/l10n/app_localizations.dart';
import 'package:get/get.dart';

/// 应用界面语言与主题偏好（持久化到 [SPUtil]）。
///
/// - 语言：`localeTag == null` 表示 [MaterialApp.locale] 为 null，即跟随系统。
/// - 主题：`system` / `light` / `dark`。
/// - 同步 [Get.updateLocale] 以便 GetX 组件与 [MaterialApp] 一致。
class LocaleThemeController extends GetxController {
  static LocaleThemeController get to => Get.find<LocaleThemeController>();

  static const _kLang = 'prefs_app_language';
  static const _kTheme = 'prefs_app_theme';

  static const supportedLangCodes = ['en', 'zh', 'ja', 'fr', 'es', 'de', 'ko'];

  /// null 或视为 system：跟随系统；否则为 [Locale(languageCode)]。
  final Rxn<String> localeTag = Rxn<String>();

  /// `system` | `light` | `dark`
  final RxString themeTag = 'system'.obs;

  /// 传入 [GetMaterialApp.locale]：`null` = 使用设备语言。
  Locale? get appMaterialLocale {
    final t = localeTag.value;
    if (t == null || t.isEmpty || t == 'system') return null;
    return Locale(t);
  }

  ThemeMode get materialThemeMode {
    switch (themeTag.value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> load() async {
    final lang = await SPUtil.getString(_kLang, defaultValue: 'system');
    if (lang == 'system' || lang.isEmpty) {
      localeTag.value = null;
    } else {
      localeTag.value = lang;
    }
    themeTag.value = await SPUtil.getString(_kTheme, defaultValue: 'system');
    _syncGetLocale();
  }

  /// [code]：`system` 或 [supportedLangCodes] 之一。
  Future<void> setLanguage(String code) async {
    if (code == 'system') {
      localeTag.value = null;
      await SPUtil.putString(_kLang, 'system');
    } else {
      localeTag.value = code;
      await SPUtil.putString(_kLang, code);
    }
    _syncGetLocale();
  }

  /// [code]：`system` | `light` | `dark`
  Future<void> setTheme(String code) async {
    themeTag.value = code;
    await SPUtil.putString(_kTheme, code);
  }

  void _syncGetLocale() {
    final mat = appMaterialLocale;
    final loc = mat ?? Get.deviceLocale ?? const Locale('en');
    final supported = AppLocalizations.supportedLocales;
    Get.updateLocale(basicLocaleListResolution([loc], supported));
  }
}
