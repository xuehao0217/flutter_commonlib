import 'package:common_core/common_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../assets/assets.dart';
import '../style/theme.dart';
import '../widget/common_widget.dart';
import 'package:flutter_helper_kit/flutter_helper_kit.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

abstract class BaseStatefulWidget<W extends StatefulWidget> extends State<W>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  bool get wantKeepAlive =>
      true; // true 来保持状态 它主要用于解决在滚动列表（如 ListView、GridView 等）中，当子部件滚出屏幕后被回收，再滚回屏幕时重新创建的问题。

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // 页面路由发生变化
    ModalRoute.of(context)?.let((c){
      routeObserver.subscribe(this, c);
    });

    super.didChangeDependencies();
    changeStatusBarColor(
        iconBrightness: isDarkMode() ? Brightness.light : Brightness.dark);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didPush() {
    // 页面被推入
    onPageShow();
  }

  @override
  void didPop() {
    onPageHide();
  }

  @override
  void didPopNext() {
    onPageShow();
  }

  @override
  void didPushNext() {
    // 返回到该页面
    onPageHide();
  }

  void onPageShow() {}

  void onPageHide() {}

  @override
  Widget build(BuildContext context) {
    super.build(context); //AutomaticKeepAliveClientMixin 必须要这么调用
    return _buildContent();
  }

  Widget _buildContent() =>Column(
    children: [
      if (showStatusBar()) getStatusBarWidget(),
      if (showTitleBar())getCommonTitleBarWidget(),
      buildPageContent(context).intoContainer(color: setPageBgColor()).intoExpanded(),
      if (showBottomNavigationBar()) Container(height: context.navigationBarHeight,color: setPageBgColor(),)
    ],
  );

  Widget getStatusBarWidget() => Container(
    color: setStatusBarColor(),
    width: BuildContextExension(context).width,
    height: context.statusBarHeight,
  );

  Widget getCommonTitleBarWidget()=>CommonTitleBar(
    showBack: showBackIcon(),
    backgroundColor: setTitleBgColor(),
    title: setTitle(),
    backIcon: setBackIcon(),
    backCallBack: () {
      Get.back();
    },
    rightWidget: setRightTitleContent(),
    height: 44,
  );

  bool showBackIcon() => true;

  bool showTitleBar() => true;

  bool showStatusBar() => true;

  bool showBottomNavigationBar() => true;

  String setTitle() => "";

  String setBackIcon() => CommonR.assetsIconBackBlack;

  Color setTitleBgColor() => context.scaffoldBackgroundColor;

  Color setStatusBarColor() => context.scaffoldBackgroundColor;

  Color setPageBgColor() => context.scaffoldBackgroundColor;

  Widget? setRightTitleContent() => null;

  Widget buildPageContent(BuildContext context);
}