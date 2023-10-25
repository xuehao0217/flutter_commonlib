import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_commonlib/widget/common_widget.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../generated/assets.dart';
import '../helpter/status_utils.dart';

abstract class BasePageStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StatusBarUtils.changeStatusColor(Colors.transparent,true);
    //为了显示水波纹
    return  Ink(
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
            child: buildContent(context).intoContainer(color:  setPageBgColor()),
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

  Color setTitleBgColor()=>Colors.white;

  Color setStatusBarColor()=>Colors.white;

  Color setPageBgColor()=>Colors.white;

  Widget? setRightTitleContent() => null;

  Widget buildContent(BuildContext context);

  void Get2Named(String router){
    Get.toNamed(router);
  }
}
