// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabMessage => 'Messages';

  @override
  String get tabMine => 'Profil';

  @override
  String get localeThemeDemoTitle => 'Langue et thème';

  @override
  String get localeThemeDemoSubtitle =>
      'Changement à l\'exécution et enregistrement (SP)';

  @override
  String get appearanceLanguage => 'Langue';

  @override
  String get appearanceTheme => 'Thème';

  @override
  String get langFollowSystem => 'Langue de l\'appareil';

  @override
  String get langEnglish => 'Anglais';

  @override
  String get langChineseSimplified => 'Chinois (simplifié)';

  @override
  String get langJapanese => 'Japonais';

  @override
  String get langFrench => 'Français';

  @override
  String get langSpanish => 'Espagnol';

  @override
  String get langGerman => 'Allemand';

  @override
  String get langKorean => 'Coréen';

  @override
  String get themeFollowSystem => 'Thème de l\'appareil';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get localeSavedHint =>
      'Enregistré. Les onglets se mettent à jour au retour.';
}
