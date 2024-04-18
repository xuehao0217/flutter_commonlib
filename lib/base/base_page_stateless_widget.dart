import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_commonlib/widget/common_widget.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../generated/assets.dart';
import '../helpter/status_utils.dart';
import '../style/theme.dart';

abstract class BasePageStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(iconBrightness: isDarkMode()?Brightness.light:Brightness.dark);
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) => Ink(
        //为了显示水波纹
        color: setPageBgColor(),
        child: Column(
          children: [
            if (showStatusBar())
              Container(
                color: setStatusBarColor() ??
                    Theme.of(context).scaffoldBackgroundColor,
                width: ScreenUtil.getScreenW(context),
                height: ScreenUtil.getStatusBarH(context),
              ),
            if (showTitleBar())
              CommonTitleBar(
                showBack: showBackIcon(),
                backgroundColor: setTitleBgColor() ??
                    Theme.of(context).scaffoldBackgroundColor,
                title: setTitle(),
                backIcon: setBackIcon(),
                backCallBack: () {
                  Get.back();
                },
                rightWidget: setRightTitleContent(),
                height: 44,
              ),
            Expanded(
              child: buildContent(context).intoContainer(
                  color: setPageBgColor() ??
                      Theme.of(context).scaffoldBackgroundColor),
            )
          ],
        ),
      );

  bool showBackIcon() => true;

  bool showTitleBar() => true;

  bool showStatusBar() => true;

  String setTitle() => "";

  String setBackIcon() => R.assetsIconBackBlack;

  Color? setTitleBgColor() => null;

  Color? setStatusBarColor() => null;

  Color? setPageBgColor() => null;

  Widget? setRightTitleContent() => null;

  Widget buildContent(BuildContext context);

  void Get2Named(String router) {
    Get.toNamed(router);
  }
}
