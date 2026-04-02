// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tabHome => '首页';

  @override
  String get tabMessage => '消息';

  @override
  String get tabMine => '我的';

  @override
  String get localeThemeDemoTitle => '多语言与主题';

  @override
  String get localeThemeDemoSubtitle => '运行时切换语言/主题，并写入本地 SP';

  @override
  String get appearanceLanguage => '界面语言';

  @override
  String get appearanceTheme => '主题模式';

  @override
  String get langFollowSystem => '跟随系统语言';

  @override
  String get langEnglish => '英语';

  @override
  String get langChineseSimplified => '简体中文';

  @override
  String get langJapanese => '日语';

  @override
  String get langFrench => '法语';

  @override
  String get langSpanish => '西班牙语';

  @override
  String get langGerman => '德语';

  @override
  String get langKorean => '韩语';

  @override
  String get themeFollowSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get localeSavedHint => '已保存，返回后底部栏等会随语言更新。';
}
