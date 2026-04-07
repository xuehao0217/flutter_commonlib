import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../l10n/app_localizations.dart';
import '../settings/locale_theme_controller.dart';

/// 外观：语言、浅色/深色、**设计规范（Apple / Google）**。
class LocaleThemeDemoPage extends StatelessWidget {
  const LocaleThemeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = LocaleThemeController.to;

    return Obx(() {
      if (c.isAppleDesign) {
        return _AppleAppearancePage(l10n: l10n, c: c);
      }
      return _MaterialAppearancePage(l10n: l10n, c: c);
    });
  }
}

class _AppleAppearancePage extends StatelessWidget {
  const _AppleAppearancePage({
    required this.l10n,
    required this.c,
  });

  final AppLocalizations l10n;
  final LocaleThemeController c;

  String _langTitle(String code) {
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const langCodes = ['system', 'en', 'zh', 'ja', 'fr', 'es', 'de', 'ko'];
    final headerStyle = TextStyle(
      fontSize: 13,
      color: CupertinoColors.secondaryLabel.resolveFrom(context),
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.localeThemeDemoTitle),
        backgroundColor: cs.surface.withValues(alpha: 0.92),
      ),
      child: Material(
        color: cs.surface,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                l10n.localeThemeDemoSubtitle,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            CupertinoListSection.insetGrouped(
              header: Text('界面规范', style: headerStyle),
              children: [
                Obx(() {
                  final d = c.designSystemTag.value;
                  return CupertinoListTile(
                    title: const Text('Apple · Human Interface'),
                    subtitle: const Text('分组列表、Cupertino 标签栏'),
                    trailing: d == LocaleThemeController.designApple
                        ? Icon(CupertinoIcons.check_mark, color: cs.primary, size: 20)
                        : null,
                    onTap: () => c.setDesignSystem(LocaleThemeController.designApple),
                  );
                }),
                Obx(() {
                  final d = c.designSystemTag.value;
                  return CupertinoListTile(
                    title: const Text('Google · Material 3'),
                    subtitle: const Text('主题、底部导航与 Tab'),
                    trailing: d == LocaleThemeController.designGoogle
                        ? Icon(CupertinoIcons.check_mark, color: cs.primary, size: 20)
                        : null,
                    onTap: () => c.setDesignSystem(LocaleThemeController.designGoogle),
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            CupertinoListSection.insetGrouped(
              header: Text(l10n.appearanceLanguage, style: headerStyle),
              children: [
                for (final code in langCodes)
                  Obx(() {
                    final raw = c.localeTag.value;
                    final current = (raw == null ||
                            raw.isEmpty ||
                            raw == 'system')
                        ? 'system'
                        : raw;
                    final selected = current == code;
                    return CupertinoListTile(
                      title: Text(_langTitle(code)),
                      subtitle: code == 'system' ? null : Text(code),
                      trailing: selected
                          ? Icon(
                              CupertinoIcons.check_mark,
                              color: cs.primary,
                              size: 20,
                            )
                          : null,
                      onTap: () async {
                        await c.setLanguage(code);
                        SmartDialog.showToast(l10n.localeSavedHint);
                      },
                    );
                  }),
              ],
            ),
            const SizedBox(height: 8),
            CupertinoListSection.insetGrouped(
              header: Text(l10n.appearanceTheme, style: headerStyle),
              children: [
                Obx(() {
                  final t = c.themeTag.value;
                  return CupertinoListTile(
                    title: Text(l10n.themeFollowSystem),
                    trailing: t == 'system' || t.isEmpty
                        ? Icon(CupertinoIcons.check_mark, color: cs.primary, size: 20)
                        : null,
                    onTap: () async {
                      await c.setTheme('system');
                      SmartDialog.showToast(l10n.localeSavedHint);
                    },
                  );
                }),
                Obx(() {
                  final t = c.themeTag.value;
                  return CupertinoListTile(
                    title: Text(l10n.themeLight),
                    trailing: t == 'light'
                        ? Icon(CupertinoIcons.check_mark, color: cs.primary, size: 20)
                        : null,
                    onTap: () async {
                      await c.setTheme('light');
                      SmartDialog.showToast(l10n.localeSavedHint);
                    },
                  );
                }),
                Obx(() {
                  final t = c.themeTag.value;
                  return CupertinoListTile(
                    title: Text(l10n.themeDark),
                    trailing: t == 'dark'
                        ? Icon(CupertinoIcons.check_mark, color: cs.primary, size: 20)
                        : null,
                    onTap: () async {
                      await c.setTheme('dark');
                      SmartDialog.showToast(l10n.localeSavedHint);
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialAppearancePage extends StatelessWidget {
  const _MaterialAppearancePage({
    required this.l10n,
    required this.c,
  });

  final AppLocalizations l10n;
  final LocaleThemeController c;

  String _langTitle(String code) {
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const langCodes = ['system', 'en', 'zh', 'ja', 'fr', 'es', 'de', 'ko'];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.localeThemeDemoTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(
            l10n.localeThemeDemoSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            '界面规范',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final d = c.designSystemTag.value;
            return Column(
              children: [
                RadioListTile<String>(
                  value: LocaleThemeController.designGoogle,
                  groupValue: d,
                  onChanged: (v) async {
                    if (v == null) return;
                    await c.setDesignSystem(v);
                    SmartDialog.showToast(l10n.localeSavedHint);
                  },
                  title: const Text('Google · Material Design 3'),
                  subtitle: const Text('主题来自 common_core / Material 3'),
                ),
                RadioListTile<String>(
                  value: LocaleThemeController.designApple,
                  groupValue: d,
                  onChanged: (v) async {
                    if (v == null) return;
                    await c.setDesignSystem(v);
                    SmartDialog.showToast(l10n.localeSavedHint);
                  },
                  title: const Text('Apple · Human Interface'),
                  subtitle: const Text('iOS 语义色与分组列表'),
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
          Text(
            l10n.appearanceLanguage,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final raw = c.localeTag.value;
            final group = (raw == null || raw.isEmpty || raw == 'system')
                ? 'system'
                : raw;
            return Column(
              children: [
                for (final code in langCodes)
                  RadioListTile<String>(
                    value: code,
                    groupValue: group,
                    onChanged: (v) async {
                      if (v == null) return;
                      await c.setLanguage(v);
                      SmartDialog.showToast(l10n.localeSavedHint);
                    },
                    title: Text(_langTitle(code)),
                    subtitle: code == 'system' ? null : Text(code),
                  ),
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
          Obx(() {
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
          }),
        ],
      ),
    );
  }
}
