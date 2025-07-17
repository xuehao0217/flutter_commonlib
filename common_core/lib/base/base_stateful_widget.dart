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

import 'base_page_widget.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

abstract class BaseStatefulWidget<W extends StatefulWidget> extends State<W>
    with AutomaticKeepAliveClientMixin, RouteAware, BaseWidgetMixin {

  @override
  bool get wantKeepAlive => true;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.let((route) {
      routeObserver.subscribe(this, route);
    });
    changeStatusBarColor(
      iconBrightness: isDarkMode() ? Brightness.light : Brightness.dark,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() => onPageShow();

  @override
  void didPop() => onPageHide();

  @override
  void didPopNext() => onPageShow();

  @override
  void didPushNext() => onPageHide();

  /// 页面显示
  void onPageShow() {}

  /// 页面隐藏
  void onPageHide() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildCommonStructure(
      context: context,
      content: buildPageContent(context),
    );
  }

  /// 子类实现
  Widget buildPageContent(BuildContext context);
}
