// 抽出 BaseWidgetMixin，用于复用通用逻辑
import 'dart:ui';
import 'package:common_core/common_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper_kit/extensions/context/build_context_extension.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../assets/assets.dart';
import '../widget/common_widget.dart';

/// ================================
/// 公共基类抽取：BaseWidgetMixin
/// ================================

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

  /// 标题栏背景色
  Color setTitleBgColor() => Colors.white;

  /// 状态栏背景色
  Color setStatusBarColor() => Colors.white;

  /// 页面背景色
  Color setPageBgColor() => Colors.white;

  /// 标题栏右侧内容
  Widget? setRightTitleContent() => null;

  /// 状态栏 widget
  Widget getStatusBarWidget(BuildContext context) => Container(
    color: setStatusBarColor(),
    width: BuildContextExension(context).width,
    height: context.statusBarHeight,
  );

  /// 公共标题栏 widget
  Widget getCommonTitleBarWidget(BuildContext context) => CommonTitleBar(
    showBack: showBackIcon(),
    backgroundColor: setTitleBgColor(),
    title: setTitle(),
    backIcon: setBackIcon(),
    backCallBack: () => Get.back(),
    rightWidget: setRightTitleContent(),
    height: 44,
  );

  /// 通用布局结构
  Widget buildCommonStructure({
    required BuildContext context,
    required Widget content,
  }) {
    return Column(
      children: [
        if (showStatusBar()) getStatusBarWidget(context),
        if (showTitleBar()) getCommonTitleBarWidget(context),
        content.intoContainer(color: setPageBgColor()).intoExpanded(),
        if (showNavigationBar())
          Container(height: context.navigationBarHeight, color: setPageBgColor()),
      ],
    );
  }
}