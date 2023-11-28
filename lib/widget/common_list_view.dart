import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 创 建 人: xueh
/// 创建日期: 2023/7/15 11:16
/// 备注：

// typedef onRefreshCallback = void Function(RefreshController refreshController);
// typedef onLoadCallback = void Function(RefreshController refreshController);

class CommonListWidget extends StatelessWidget {
  final List<Widget>? header;
  final List<Widget>? footer;
  final int itemCount;
  final ScrollController? scrollController;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;

  final VoidCallback? onRefresh;
  final VoidCallback? onLoad;
  final RefreshController? _controller;
  final bool enableRefresh, enableLoad, initialRefresh;

  // final onRefreshCallback? onRefresh;
  // final onLoadCallback? onLoad;

  CommonListWidget({
    this.onLoad,
    this.onRefresh,
    required this.itemBuilder,
    this.header,
    this.footer,
    this.itemCount = 0,
    this.scrollController,
    this.padding,
    this.enableRefresh = false,
    this.enableLoad = false,
    this.initialRefresh = true,
    RefreshController? controller,
  }) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return ConstraintLayout(
      children: [
        getListWidget().applyConstraint(
          height: matchParent,
          width: matchParent,
        ),
        Container(
            height: 60,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00EFF1F2),
                  Color(0xffEFF1F2),
                ],
              ),
            )).applyConstraint(
          width: matchParent,
          bottom: parent.bottom,
        )
      ],
    );
  }

  Widget getListWidget() => enableRefresh || enableLoad
      ? RefreshConfiguration(
          // 配置默认底部指示器
          headerTriggerDistance: 80.0,
          // 头部触发刷新的越界距离
          springDescription:
              const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
          // 自定义回弹动画,三个属性值意义请查询flutter api
          maxOverScrollExtent: 100,
          //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
          maxUnderScrollExtent: 0,
          // 底部最大可以拖动的范围
          enableScrollWhenRefreshCompleted: true,
          //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
          enableLoadingWhenFailed: true,
          //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
          hideFooterWhenNotFull: false,
          // Viewport不满一屏时,禁用上拉加载更多功能
          enableBallisticLoad: true,
          // 可以通过惯性滑动触发加载更多
          child: SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            header: const ClassicHeader(
              refreshingText: "加载中...",
              releaseText: "放开刷新",
              completeText: "刷新完成",
              idleText: "下拉刷新",
            ),
            footer: const ClassicFooter(
              loadingText: "加载中...",
              noDataText: "到底了~",
              idleText: "加载完成",
              failedText: "加载失败",
              // canLoadingText: "canLoadingText",
            ),
            controller: _controller ?? RefreshController(initialRefresh: true),
            onLoading: onLoad,
            onRefresh: onRefresh,
            // onRefresh: () {
            //   onRefresh?.call(_controller);
            // },
            // onLoading: () {
            //   onLoad?.call(_controller);
            // },
            child: getListView(),
          ))
      : getListView();

  int getHeaderCount() {
    return header?.length ?? 0;
  }

  int getFooterCount() {
    return footer?.length ?? 0;
  }

  Widget getListView() => ListView.separated(
        itemCount: getHeaderCount() + itemCount + getFooterCount(),
        padding: padding,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index < getHeaderCount()) {
            return header?[index];
          } else if (index > getHeaderCount() + itemCount - 1) {
            return footer?[index - getHeaderCount() - itemCount];
          } else {
            return itemBuilder(context, index - getHeaderCount());
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 16,
          );
        },
      );
}
