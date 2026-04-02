// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabMessage => 'メッセージ';

  @override
  String get tabMine => 'マイページ';

  @override
  String get localeThemeDemoTitle => '言語とテーマ';

  @override
  String get localeThemeDemoSubtitle => '実行時の切り替えと SP への保存';

  @override
  String get appearanceLanguage => '言語';

  @override
  String get appearanceTheme => 'テーマ';

  @override
  String get langFollowSystem => '端末の言語に合わせる';

  @override
  String get langEnglish => '英語';

  @override
  String get langChineseSimplified => '中国語（簡体字）';

  @override
  String get langJapanese => '日本語';

  @override
  String get langFrench => 'フランス語';

  @override
  String get langSpanish => 'スペイン語';

  @override
  String get langGerman => 'ドイツ語';

  @override
  String get langKorean => '韓国語';

  @override
  String get themeFollowSystem => '端末のテーマに合わせる';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get localeSavedHint => '保存しました。戻るとタブなどが更新されます。';
}
