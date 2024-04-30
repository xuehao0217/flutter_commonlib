import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/base_page_stateful_widget.dart';
import '../base/base_page_stateless_widget.dart';
import '../generated/assets.dart';
import '../style/theme.dart';
import '../widget/common_widget.dart';

// https://github.com/peng8350/flutter_pulltorefresh/blob/master/example/lib/ui/example/useStage/twolevel_refresh.dart
class TwoLevelExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TwoLevelExampleState();
  }
}

class _TwoLevelExampleState extends BasePgaeStatefulWidget<TwoLevelExample> {
  final RefreshController _refreshController = RefreshController();

  @override
  bool showTitleBar() => false;

  @override
  bool showStatusBar() => false;

  @override
  Widget buildPageContent(BuildContext context) {
    return SmartRefresher(
      header: TwoLevelHeader(
        textStyle: const TextStyle(color: Colors.white),
        displayAlignment: TwoLevelDisplayAlignment.fromTop,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(R.assetsIcLogo),
              fit: BoxFit.cover,
              // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果
              alignment: Alignment.topCenter),
        ),
        twoLevelWidget: TwoLevelWidget(),
      ),
      controller: _refreshController,
      enableTwoLevel: true,
      enablePullDown: true,
      enablePullUp: true,
      onLoading: () async {
        await Future.delayed(const Duration(milliseconds: 2000));
        _refreshController.loadComplete();
      },
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 2000));
        _refreshController.refreshCompleted();
      },
      onTwoLevel: (bool isOpen) {
        SmartDialog.showToast("twoLevel opening:$isOpen");
      },
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SizedBox(
              height: 500.0,
              child: Column(
                children: <Widget>[
                  getStatusBarWidget(),
                  getCommonTitleBarWidget(),
                  Column(
                    children: [
                      CommonButton(
                        elevation: 2,
                        circular: 10,
                        backgroundColor: getThemeData().primaryColor,
                        width: double.infinity,
                        height: 50,
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "点击这里返回上一页",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ).intoPadding(const EdgeInsets.all(15)),
                      CommonButton(
                        elevation: 2,
                        circular: 10,
                        backgroundColor: getThemeData().primaryColor,
                        width: double.infinity,
                        height: 50,
                        onPressed: () {
                          _refreshController.requestTwoLevel();
                        },
                        child: const Text(
                          "打开二楼",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ).intoPadding(const EdgeInsets.all(15))
                    ],
                  ).intoExpanded(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TwoLevelWidget extends BasePageStatelessWidget {
  @override
  bool showStatusBar() => false;

  @override
  bool showTitleBar() => false;

  @override
  Color? setStatusBarColor() => Colors.transparent;

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(R.assetsIcLogo),
// 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果,关联到TwoLevelHeader,如果背景一致的情况,请设置相同
            alignment: Alignment.topCenter,
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          // getStatusBarWidget(context),
          //getCommonTitleBarWidget(context),
          CommonButton(
            elevation: 2,
            circular: 10,
            backgroundColor: getThemeData().primaryColor,
            width: double.infinity,
            height: 50,
            onPressed: () {
              SmartRefresher.of(context)?.controller.twoLevelComplete();
            },
            child: const Text(
              "关闭二楼",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
              .intoCenter()
              .intoPadding(const EdgeInsets.symmetric(horizontal: 20)),
        ],
      ),
    );
  }
}
