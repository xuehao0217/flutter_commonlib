import 'package:common_core/common_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_helper_kit/flutter_helper_kit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../assets/assets.dart';
import '../style/theme.dart';
import '../widget/common_widget.dart';

abstract class BaseStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(
        iconBrightness: isDarkMode() ? Brightness.light : Brightness.dark);
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) => Column(
    children: [
      if (showStatusBar()) getStatusBarWidget(context),
      if (showTitleBar()) getCommonTitleBarWidget(context),
      buildContent(context).intoContainer(color: setPageBgColor()).intoExpanded(),
      if (showBottomNavigationBar()) Container(height: context.navigationBarHeight,color: setPageBgColor(),)
    ],
  );

  bool showBackIcon() => true;

  bool showTitleBar() => true;

  bool showStatusBar() => true;

  String setTitle() => "";

  bool showBottomNavigationBar() => true;

  String setBackIcon() => CommonR.assetsIconBackBlack;

  Color setTitleBgColor() => Colors.white;

  Color setStatusBarColor() => Colors.white;

  Color setPageBgColor() => Colors.white;

  Widget? setRightTitleContent() => null;

  Widget buildContent(BuildContext context);

  Widget getStatusBarWidget(BuildContext context) => Container(
        color: setStatusBarColor(),
        width: BuildContextExension(context).width,
        height:  context.statusBarHeight,
      );

  Widget getCommonTitleBarWidget(BuildContext context) => CommonTitleBar(
        showBack: showBackIcon(),
        backgroundColor:
            setTitleBgColor(),
        title: setTitle(),
        backIcon: setBackIcon(),
        backCallBack: () {
          Get.back();
        },
        rightWidget: setRightTitleContent(),
        height: 44,
      );
}
