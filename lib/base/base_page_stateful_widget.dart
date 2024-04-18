import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_commonlib/widget/common_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../generated/assets.dart';
import '../style/theme.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
RouteObserver<ModalRoute<void>>();

abstract class BasePgaeStatefulWidget<W extends StatefulWidget> extends State<W>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  bool get wantKeepAlive => true; // true 来保持状态 它主要用于解决在滚动列表（如 ListView、GridView 等）中，当子部件滚出屏幕后被回收，再滚回屏幕时重新创建的问题。

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
    changeStatusBarColor(color:setStatusBarColor(),iconBrightness: isDarkMode()?Brightness.light:Brightness.dark);
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

  Widget _buildContent() {
    //为了显示水波纹
    return Ink(
      color: setPageBgColor(),
      child: Column(
        children: [
          if (showStatusBar())
            Container(
              color: setStatusBarColor() ,
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
            child: buildPageContent(context)
                .intoContainer(color: setPageBgColor()),
          )
        ],
      ),
    );
  }

  ThemeData getThemeData() => Theme.of(context);

  bool showBackIcon() => true;

  bool showTitleBar() => true;

  bool showStatusBar() => true;

  String setTitle() => "";

  String setBackIcon() => R.assetsIconBackBlack;

  Color setTitleBgColor() => getThemeData().scaffoldBackgroundColor;

  Color setStatusBarColor() => getThemeData().scaffoldBackgroundColor;

  Color setPageBgColor() => getThemeData().scaffoldBackgroundColor;

  Widget? setRightTitleContent() => null;

  Widget buildPageContent(BuildContext context);

  void Get2Named(String router) {
    Get.toNamed(router);
  }
}
