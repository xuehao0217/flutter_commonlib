// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabMessage => 'Messages';

  @override
  String get tabMine => 'Profile';

  @override
  String get localeThemeDemoTitle => 'Language & theme';

  @override
  String get localeThemeDemoSubtitle =>
      'Runtime locale + theme with persistence (SP)';

  @override
  String get appearanceLanguage => 'Language';

  @override
  String get appearanceTheme => 'Theme';

  @override
  String get langFollowSystem => 'Use device language';

  @override
  String get langEnglish => 'English';

  @override
  String get langChineseSimplified => 'Chinese (Simplified)';

  @override
  String get langJapanese => 'Japanese';

  @override
  String get langFrench => 'French';

  @override
  String get langSpanish => 'Spanish';

  @override
  String get langGerman => 'German';

  @override
  String get langKorean => 'Korean';

  @override
  String get themeFollowSystem => 'Use device theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get localeSavedHint => 'Saved. Tabs update after returning.';
}
