import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/settings/locale_theme_controller.dart';
import 'package:get/get.dart';

/// 演示页：仅从首页「登录门控」进入。
class MiddlewareDemoPage extends StatelessWidget {
  const MiddlewareDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Obx(() {
      if (LocaleThemeController.to.isAppleDesign) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('登录门控演示'),
            backgroundColor: cs.surface.withValues(alpha: 0.92),
          ),
          child: Material(
            color: cs.surface,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Icon(
                    CupertinoIcons.check_mark_circled,
                    size: 48,
                    color: cs.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '已进入演示页',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '其它入口不做登录限制；只有首页里对应列表项会先校验本地登录态。',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CupertinoButton.filled(
                    onPressed: () => Get.back(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: BorderRadius.circular(10),
                    child: const Text('返回'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(title: const Text('登录门控演示')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_user_outlined, size: 48, color: cs.primary),
              const SizedBox(height: 16),
              Text(
                '已进入演示页',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                '其它入口不做登录限制；只有首页里对应列表项会先校验本地登录态。',
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
