import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_commonlib/widget/common_widget.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../generated/assets.dart';
import '../helpter/status_utils.dart';
import 'mvvm/base_view_abs.dart';
import 'mvvm/base_stateful_widget.dart';
import 'mvvm/base_stateless_widget.dart';
import 'mvvm/base_view_model.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

abstract class BasePgaeStatefulWidget<W extends StatefulWidget> extends State<W>
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
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    StatusBarUtils.changeStatusColor(Colors.transparent,true);
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
    //为了显示水波纹
    return Ink(
      color: setPageBgColor(),
      child: Column(
        children: [
          if (showStatusBar())
            Container(
              color: setStatusBarColor(),
              width: ScreenUtil.getScreenW(context),
              height: ScreenUtil.getStatusBarH(context),
            ),
          if (showTitleBar())
            CommonTitleBar(
              showBack: showBackIcon(),
              backgroundColor: setTitleBgColor(),
              title: setTitle(),
              backIcon: setBackIcon(),
              backCallBack: () {
                Get.back();
              },
              rightWidget: setRightTitleContent(),
              height: 44,
            ),
          Expanded(
            child: buildPageContent(context),
          )
        ],
      ),
    );
  }

  bool showBackIcon() => true;

  bool showTitleBar() => true;

  bool showStatusBar() => true;

  String setTitle() => "";

  String setBackIcon() => R.assetsIconBackBlack;

  Color setTitleBgColor() => Colors.white;

  Color setStatusBarColor() => Colors.transparent;

  Color setPageBgColor() => Colors.white;

  Widget? setRightTitleContent() => null;

  Widget buildPageContent(BuildContext context);

  void Get2Named(String router) {
    Get.toNamed(router);
  }
}
