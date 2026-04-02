import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../l10n/app_localizations.dart';
import '../settings/locale_theme_controller.dart';

/// 多语言（7 种 + 跟随系统）与主题（跟随/浅色/深色）Demo，选项写入 SP。
class LocaleThemeDemoPage extends StatelessWidget {
  const LocaleThemeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = LocaleThemeController.to;
    final cs = Theme.of(context).colorScheme;

    String langTitle(String code) {
      return switch (code) {
        'system' => l10n.langFollowSystem,
        'en' => l10n.langEnglish,
        'zh' => l10n.langChineseSimplified,
        'ja' => l10n.langJapanese,
        'fr' => l10n.langFrench,
        'es' => l10n.langSpanish,
        'de' => l10n.langGerman,
        'ko' => l10n.langKorean,
        _ => code,
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.localeThemeDemoTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            l10n.localeThemeDemoSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.appearanceLanguage,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final raw = c.localeTag.value;
            final groupValue =
                (raw == null || raw.isEmpty || raw == 'system') ? 'system' : raw;
            return Column(
              children: [
                _langRadio(c, l10n, groupValue, 'system', langTitle),
                _langRadio(c, l10n, groupValue, 'en', langTitle),
                _langRadio(c, l10n, groupValue, 'zh', langTitle),
                _langRadio(c, l10n, groupValue, 'ja', langTitle),
                _langRadio(c, l10n, groupValue, 'fr', langTitle),
                _langRadio(c, l10n, groupValue, 'es', langTitle),
                _langRadio(c, l10n, groupValue, 'de', langTitle),
                _langRadio(c, l10n, groupValue, 'ko', langTitle),
              ],
            );
          }),
          const SizedBox(height: 16),
          Text(
            l10n.appearanceTheme,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Obx(
            () {
              final t = c.themeTag.value;
              return Column(
                children: [
                  RadioListTile<String>(
                    value: 'system',
                    groupValue: t,
                    onChanged: (_) async {
                      await c.setTheme('system');
                      SmartDialog.showToast(l10n.localeSavedHint);
                    },
                    title: Text(l10n.themeFollowSystem),
                  ),
                  RadioListTile<String>(
                    value: 'light',
                    groupValue: t,
                    onChanged: (_) async {
                      await c.setTheme('light');
                      SmartDialog.showToast(l10n.localeSavedHint);
                    },
                    title: Text(l10n.themeLight),
                  ),
                  RadioListTile<String>(
                    value: 'dark',
                    groupValue: t,
                    onChanged: (_) async {
                      await c.setTheme('dark');
                      SmartDialog.showToast(l10n.localeSavedHint);
                    },
                    title: Text(l10n.themeDark),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _langRadio(
    LocaleThemeController c,
    AppLocalizations l10n,
    String groupValue,
    String code,
    String Function(String code) langTitle,
  ) {
    return RadioListTile<String>(
      value: code,
      groupValue: groupValue,
      onChanged: (v) async {
        if (v == null) return;
        await c.setLanguage(v);
        SmartDialog.showToast(l10n.localeSavedHint);
      },
      title: Text(langTitle(code)),
      subtitle: code == 'system' ? null : Text(code),
    );
  }
}
