// 页面通用骨架：状态栏、标题栏、内容区、底部安全区（能力见 [BaseWidgetMixin]）。
import 'package:common_core/common_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper_kit/extensions/context/build_context_extension.dart';
import 'package:get/get.dart';

import '../assets/assets.dart';
import '../style/theme.dart';

/// ================================
/// 公共基类抽取：BaseWidgetMixin
/// ================================

/// 状态栏、标题栏、内容区、底部占位与返回逻辑；与 [BaseStatefulWidget]、[BaseStatelessWidget] 组合使用。
///
/// 默认返回为 [Get.back]；配色建议与 [appLightThemeData] / [appDarkThemeData] 对齐。
mixin BaseWidgetMixin {
  /// 设置是否展示返回按钮
  bool showBackIcon() => true;

  /// 设置是否展示标题栏
  bool showTitleBar() => true;

  /// 设置是否展示状态栏占位
  bool showStatusBar() => true;

  /// 设置是否展示导航栏占位
  bool showNavigationBar() => true;

  /// 页面标题内容
  String setTitle() => "";

  /// 返回按钮图标
  String setBackIcon() => CommonR.assetsIconBackBlack;

  /// 标题栏背景色（与 [appLightThemeData] / [appDarkThemeData] 的 surface 对齐）
  Color setTitleBgColor() =>
      isDarkMode() ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

  /// 状态栏背景色
  Color setStatusBarColor() =>
      isDarkMode() ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

  /// 页面背景色
  Color setPageBgColor() =>
      isDarkMode() ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

  /// 标题栏右侧内容
  Widget? setRightTitleContent() => null;

  /// 状态栏 widget
  Widget getStatusBarWidget(BuildContext context) => Container(
    color: setStatusBarColor(),
    width: BuildContextExension(context).width,
    height: context.statusBarHeight,
  );

  ///底部NavigationBarWidget
  Widget getNavigationBarWidget(BuildContext context)=> Container(
      height: context.navigationBarHeight,
      color: setPageBgColor()
  );


  /// 公共标题栏 widget
  Widget getCommonTitleBarWidget(BuildContext context) => CommonTitleBar(
    showBack: showBackIcon(),
    backgroundColor: setTitleBgColor(),
    title: setTitle(),
    backIcon: setBackIcon(),
    backCallBack: () => onBackPressed(),
    rightWidget: setRightTitleContent(),
    height: 44,
  );

  /// 通用布局结构
  Widget buildCommonStructure({
    required BuildContext context,
    required Widget content,
  }) => Column(
    children: [
      if (showStatusBar()) getStatusBarWidget(context),
      if (showTitleBar()) getCommonTitleBarWidget(context),
      content.withContainer(color: setPageBgColor()).withExpanded(),
      if (showNavigationBar())
        getNavigationBarWidget(context),
    ],
  );

  /// 自定义返回事件（默认执行 Get.back）
  void onBackPressed() {
    Get.back();
  }
}
