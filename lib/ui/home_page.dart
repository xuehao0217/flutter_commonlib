import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/common_core.dart';
import 'package:common_core/helpter/get_ext_helper.dart';
import 'package:common_core/helpter/logger_helper.dart';
import 'package:common_core/helpter/notification_helper.dart';
import 'package:common_core/helpter/talker_helper.dart';
import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter_commonlib/l10n/app_localizations.dart';
import 'package:flutter_commonlib/settings/locale_theme_controller.dart';
import '../auth/auth_service.dart';
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

  TextStyle? _sectionHeaderStyle(BuildContext context) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
      );

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() {
      if (LocaleThemeController.to.isAppleDesign) {
        return _buildAppleHome(context);
      }
      return _buildMaterialHome(context);
    });
  }

  Widget _designSwitcherApple(BuildContext context) {
    final c = LocaleThemeController.to;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CupertinoSlidingSegmentedControl<String>(
        groupValue: c.designSystemTag.value,
        onValueChanged: (v) {
          if (v != null) c.setDesignSystem(v);
        },
        thumbColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        children: {
          LocaleThemeController.designApple: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Text('Apple'),
          ),
          LocaleThemeController.designGoogle: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Text('Material'),
          ),
        },
      ),
    );
  }

  Widget _designSwitcherMaterial(BuildContext context) {
    final c = LocaleThemeController.to;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment<String>(
            value: LocaleThemeController.designGoogle,
            label: Text('Material'),
            icon: Icon(Icons.palette_outlined, size: 18),
          ),
          ButtonSegment<String>(
            value: LocaleThemeController.designApple,
            label: Text('Apple'),
            icon: Icon(Icons.phone_iphone_outlined, size: 18),
          ),
        ],
        selected: {c.designSystemTag.value},
        onSelectionChanged: (s) {
          if (s.isEmpty) return;
          c.setDesignSystem(s.first);
        },
      ),
    );
  }

  Widget _buildAppleHome(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        _HomeHero(
          colorScheme: cs,
          subtitle: 'Human Interface · 分组列表与标签栏',
        ),
        _designSwitcherApple(context),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: ChuckerFlutter.chuckerButton,
        ),
        CupertinoListSection.insetGrouped(
          header: Text('外观与调试', style: _sectionHeaderStyle(context)),
          children: [
            CupertinoListTile(
              title: Text(l10n.localeThemeDemoTitle),
              subtitle: Text(l10n.localeThemeDemoSubtitle),
              leading: Icon(CupertinoIcons.globe, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => GetXHelper.to(RouterUrlConfig.locale_theme_demo),
            ),
          ],
        ),
        CupertinoListSection.insetGrouped(
          header: Text('界面与导航', style: _sectionHeaderStyle(context)),
          children: [
            CupertinoListTile(
              title: const Text('下拉刷新示例'),
              subtitle: const Text('列表刷新与加载'),
              leading: Icon(CupertinoIcons.arrow_clockwise, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => GetXHelper.to(RouterUrlConfig.list_refresh),
            ),
            CupertinoListTile(
              title: const Text('拍照打水印'),
              subtitle: const Text('相机与图片处理'),
              leading: Icon(CupertinoIcons.camera, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => GetXHelper.to(RouterUrlConfig.watermark),
            ),
            CupertinoListTile(
              title: const Text('头像裁剪'),
              subtitle: const Text('相册选图并裁成圆形头像'),
              leading: Icon(CupertinoIcons.crop, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => GetXHelper.to(RouterUrlConfig.avatar_crop_demo),
            ),
            CupertinoListTile(
              title: const Text('WebView'),
              subtitle: const Text('内嵌浏览器'),
              leading: Icon(CupertinoIcons.link, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
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
            CupertinoListTile(
              title: const Text('版本更新'),
              subtitle: const Text('下载与更新流程'),
              leading: Icon(CupertinoIcons.arrow_down_circle, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => GetXHelper.to(RouterUrlConfig.download),
            ),
            CupertinoListTile(
              title: const Text('本地通知'),
              subtitle: const Text('推送展示测试'),
              leading: Icon(CupertinoIcons.bell, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () async {
                final ok = await NotificationHelper.instance
                    .showLocalNotification('本地通知', '这是一条测试通知');
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
            CupertinoListTile(
              title: const Text('Flutter Helper Kit'),
              subtitle: const Text('工具集示例页'),
              leading: Icon(CupertinoIcons.square_grid_2x2, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => GetXHelper.to(RouterUrlConfig.flutter_helper_kit),
            ),
            CupertinoListTile(
              title: const Text('滚动联动 Demo'),
              subtitle: const Text('BindShowOnScroll'),
              leading: Icon(CupertinoIcons.arrow_up_arrow_down_circle,
                  color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => GetXHelper.to(RouterUrlConfig.scroll_demo),
            ),
            CupertinoListTile(
              title: const Text('GridView'),
              subtitle: const Text('网格列表示例'),
              leading: Icon(CupertinoIcons.square_grid_3x2, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => GetXHelper.to(RouterUrlConfig.grid_view),
            ),
            Obx(
              () => CupertinoListTile(
                title: const Text('模拟登录状态'),
                subtitle: Text(
                  AuthService.to.isLoggedIn.value
                      ? '开：视为已登录，门控 Demo 直接进入'
                      : '关：未登录时门控会进登录页',
                ),
                leading: Icon(
                  AuthService.to.isLoggedIn.value
                      ? CupertinoIcons.check_mark_circled
                      : CupertinoIcons.person_crop_circle_badge_xmark,
                  color: cs.primary,
                ),
                trailing: CupertinoSwitch(
                  value: AuthService.to.isLoggedIn.value,
                  onChanged: (v) async {
                    if (v) {
                      await AuthService.to.markLoggedInForDemo();
                    } else {
                      await AuthService.to.clearSessionKeepNavigation();
                    }
                  },
                ),
              ),
            ),
            CupertinoListTile(
              title: const Text('登录门控 Demo'),
              subtitle: const Text('仅本行：未登录先去登录页'),
              leading: Icon(CupertinoIcons.lock_shield, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () => AuthService.openWithLoginGateIfNeeded(
                RouterUrlConfig.middleware_demo,
              ),
            ),
          ],
        ),
        CupertinoListSection.insetGrouped(
          header: Text('日志与诊断', style: _sectionHeaderStyle(context)),
          children: [
            CupertinoListTile(
              title: const Text('Talker 诊断屏'),
              subtitle: const Text('日志与网络追踪'),
              leading: Icon(CupertinoIcons.text_bubble, color: cs.primary),
              trailing: const CupertinoListTileChevron(),
              onTap: () async {
                await _runTalkerLogging();
              },
            ),
            Obx(
              () => CupertinoListTile(
                title: const Text('清理缓存'),
                subtitle: Text('当前约 ${viewModel.cacheSize}'),
                leading: Icon(CupertinoIcons.delete, color: cs.primary),
                onTap: () async {
                  viewModel.clearCache();
                },
              ),
            ),
          ],
        ),
        CupertinoListSection.insetGrouped(
          header: Text('其他', style: _sectionHeaderStyle(context)),
          children: [
            CupertinoListTile(
              title: const Text('Hero 与模糊'),
              subtitle: const Text('点击图片过渡动画'),
              leading: Icon(CupertinoIcons.circle_grid_3x3_fill, color: cs.primary),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: "Hero",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        R.assetsIcLogo,
                        width: 56,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const CupertinoListTileChevron(),
                ],
              ),
              onTap: () => GetXHelper.to(RouterUrlConfig.blurry),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _runTalkerLogging() async {
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
  }

  Widget _buildMaterialHome(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _HomeHero(
          colorScheme: cs,
          subtitle: 'Material Design 3 · 组件与导航',
        ),
        _designSwitcherMaterial(context),
        ChuckerFlutter.chuckerButton.withPadding(
          const EdgeInsets.only(bottom: 8),
        ),
        _SectionTitle(
          icon: Icons.tune_rounded,
          label: '外观与调试',
          colorScheme: cs,
        ),
        const SizedBox(height: 10),
        _DemoTile(
          icon: Icons.translate_rounded,
          title: l10n.localeThemeDemoTitle,
          subtitle: l10n.localeThemeDemoSubtitle,
          colorScheme: cs,
          onTap: () => GetXHelper.to(RouterUrlConfig.locale_theme_demo),
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
          icon: Icons.crop_rounded,
          title: '头像裁剪',
          subtitle: '相册选图并裁成圆形头像',
          colorScheme: cs,
          onTap: () => GetXHelper.to(RouterUrlConfig.avatar_crop_demo),
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
            final ok = await NotificationHelper.instance
                .showLocalNotification('本地通知', '这是一条测试通知');
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
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          clipBehavior: Clip.antiAlias,
          child: Obx(
            () => SwitchListTile.adaptive(
              secondary: Icon(
                AuthService.to.isLoggedIn.value
                    ? Icons.verified_user_outlined
                    : Icons.person_off_outlined,
                color: cs.primary,
              ),
              title: const Text('模拟登录状态'),
              subtitle: Text(
                AuthService.to.isLoggedIn.value
                    ? '开：视为已登录，点下方 Demo 直接进入演示页'
                    : '关：视为未登录，点下方 Demo 会先进登录页',
              ),
              value: AuthService.to.isLoggedIn.value,
              onChanged: (v) async {
                if (v) {
                  await AuthService.to.markLoggedInForDemo();
                } else {
                  await AuthService.to.clearSessionKeepNavigation();
                }
              },
            ),
          ),
        ),
        _DemoTile(
          icon: Icons.filter_alt_outlined,
          title: '登录门控 Demo',
          subtitle: '仅本按钮：未登录先去登录页，成功后自动进演示页',
          colorScheme: cs,
          onTap: () => AuthService.openWithLoginGateIfNeeded(
            RouterUrlConfig.middleware_demo,
          ),
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
          onTap: () => _runTalkerLogging(),
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
  const _HomeHero({
    required this.colorScheme,
    required this.subtitle,
  });

  final ColorScheme colorScheme;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.82),
            colorScheme.tertiary.withValues(alpha: 0.88),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flutter Demo',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: colorScheme.onPrimary.withValues(alpha: 0.92),
              fontSize: 15,
              height: 1.25,
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
                    color:
                        colorScheme.primaryContainer.withValues(alpha: 0.55),
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
