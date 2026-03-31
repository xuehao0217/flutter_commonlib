import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/common_core.dart';
import 'package:common_core/helpter/get_ext_helper.dart';
import 'package:common_core/helpter/logger_helper.dart';
import 'package:common_core/helpter/notification_helper.dart';
import 'package:common_core/helpter/talker_helper.dart';
import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import '../generated/assets.dart';
import '../router/router_config.dart';
import 'vm/home_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends BaseVMStatefulWidget<HomePage, HomeViewModel> {
  @override
  void onPageShow() {
    super.onPageShow();
    viewModel.getCacheSizeAsync();
  }

  @override
  void initData() {}

  @override
  bool showTitleBar() => false;

  @override
  createViewModel() => HomeViewModel();

  @override
  Widget buildPageContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _HomeHero(colorScheme: cs),
        const SizedBox(height: 20),
        _SectionTitle(
          icon: Icons.tune_rounded,
          label: '外观与调试',
          colorScheme: cs,
        ),
        const SizedBox(height: 10),
        ChuckerFlutter.chuckerButton.withPadding(
          const EdgeInsets.only(bottom: 8),
        ),
        _DemoTile(
          icon: Icons.dark_mode_outlined,
          title: '主题切换',
          subtitle: '当前：${Get.isDarkMode ? "深色" : "浅色"}',
          colorScheme: cs,
          onTap: () {
            Get.changeThemeMode(
              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
            );
          },
        ),
        _SectionTitle(
          icon: Icons.route_rounded,
          label: '界面与导航',
          colorScheme: cs,
        ),
        const SizedBox(height: 10),
        _DemoTile(
          icon: Icons.refresh_rounded,
          title: '下拉刷新示例',
          subtitle: '列表刷新与加载',
          colorScheme: cs,
          onTap: () => GetXHelper.to(RouterUrlConfig.list_refresh),
        ),
        _DemoTile(
          icon: Icons.camera_alt_outlined,
          title: '拍照打水印',
          subtitle: '相机与图片处理',
          colorScheme: cs,
          onTap: () => GetXHelper.to(RouterUrlConfig.watermark),
        ),
        _DemoTile(
          icon: Icons.language_rounded,
          title: 'WebView',
          subtitle: '内嵌浏览器',
          colorScheme: cs,
          onTap: () {
            GetXHelper.to(
              RouterUrlConfig.webview,
              parameters: {
                WebViewPage.Url: "https://www.baidu.com?hideTitle=1",
                WebViewPage.Title: "Title",
              },
            );
          },
        ),
        _DemoTile(
          icon: Icons.system_update_rounded,
          title: '版本更新',
          subtitle: '下载与更新流程',
          colorScheme: cs,
          onTap: () => GetXHelper.to(RouterUrlConfig.download),
        ),
        _DemoTile(
          icon: Icons.notifications_active_outlined,
          title: '本地通知',
          subtitle: '推送展示测试',
          colorScheme: cs,
          onTap: () async {
            final ok = await NotificationHelper.instance.showLocalNotification(
              '本地通知',
              '这是一条测试通知',
            );
            if (!context.mounted) return;
            if (!ok) {
              Get.snackbar(
                '通知权限',
                '未授权或被拒绝，请在系统设置中为本应用开启通知',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
            }
          },
        ),
        _DemoTile(
          icon: Icons.extension_outlined,
          title: 'Flutter Helper Kit',
          subtitle: '工具集示例页',
          colorScheme: cs,
          onTap: () => GetXHelper.to(RouterUrlConfig.flutter_helper_kit),
        ),
        _DemoTile(
          icon: Icons.unfold_more_double_rounded,
          title: '滚动联动 Demo',
          subtitle: 'BindShowOnScroll',
          colorScheme: cs,
          onTap: () => GetXHelper.to(RouterUrlConfig.scroll_demo),
        ),
        _DemoTile(
          icon: Icons.grid_view_rounded,
          title: 'GridView',
          subtitle: '网格列表示例',
          colorScheme: cs,
          onTap: () => GetXHelper.to(RouterUrlConfig.grid_view),
        ),
        _SectionTitle(
          icon: Icons.terminal_rounded,
          label: '日志与诊断',
          colorScheme: cs,
        ),
        const SizedBox(height: 10),
        _DemoTile(
          icon: Icons.terminal_rounded,
          title: 'Talker 诊断屏',
          subtitle: '日志与网络追踪',
          colorScheme: cs,
          onTap: () async {
            LogHelper.d("这是普通 debug 日志");
            LogHelper.d("这是带 tag 的 debug 日志", tag: "HomePage");
            LogHelper.w("这是 warning 日志");

            try {
              int result = 10 ~/ 0;
              result + 1;
            } catch (e, stack) {
              LoggerHelper.e(
                "捕获到异常",
                error: e,
                stackTrace: stack,
                tag: "Calculator",
              );
            }

            LogHelper.i("这是 info 日志");
            LogHelper.t("这是 trace 日志");
            LogHelper.dNoStack("这是无堆栈 debug 日志", tag: "NoStack");

            Map<String, dynamic> user = {
              "id": 1001,
              "name": "Alice",
              "roles": ["admin", "user"],
            };
            LogHelper.json(user, tag: "UserData");

            List<int> numbers = [1, 2, 3, 4, 5];
            LogHelper.json(numbers, tag: "NumbersList");

            String jsonString = '{"title":"Logger Example","success":true}';
            LogHelper.json(jsonString, tag: "JSONString");

            await 3.secondsDelay();

            openTalkerScreen();
          },
        ),
        Obx(
          () => _DemoTile(
            icon: Icons.delete_sweep_outlined,
            title: '清理缓存',
            subtitle: '当前约 ${viewModel.cacheSize}',
            colorScheme: cs,
            onTap: () async {
              viewModel.clearCache();
            },
          ),
        ),
        _SectionTitle(
          icon: Icons.image_outlined,
          label: '其他',
          colorScheme: cs,
        ),
        const SizedBox(height: 10),
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => GetXHelper.to(RouterUrlConfig.blurry),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.blur_on_rounded, color: cs.primary, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hero 与模糊',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '点击查看图片过渡动画',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: "Hero",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        R.assetsIcLogo,
                        width: 72,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.75),
            colorScheme.tertiary.withValues(alpha: 0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flutter Demo',
            style: tt.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '组件与能力速览 · Material 3',
            style: tt.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: colorScheme.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
