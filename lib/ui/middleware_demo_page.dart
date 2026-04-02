import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 演示页：仅从首页「GetMiddleware 示例」进入；该入口在 [AuthService.openWithLoginGateIfNeeded] 中做登录校验。
class MiddlewareDemoPage extends StatelessWidget {
  const MiddlewareDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录门控演示页'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.verified_user_outlined, size: 48, color: cs.primary),
            const SizedBox(height: 16),
            Text(
              '已进入演示页',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              '其它菜单入口不做登录限制；只有点击首页里这一个 Demo 时，'
              '会先根据本地登录态决定是否进登录页。',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
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
  }
}
