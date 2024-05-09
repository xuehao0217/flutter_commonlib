
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

/// 创 建 人: xueh
/// 创建日期: 2023/7/15 11:16
/// 备注：

// typedef onRefreshCallback = void Function(RefreshController refreshController);
// typedef onLoadCallback = void Function(RefreshController refreshController);

typedef VisibleIndexListCallback = void Function(List<int>);

typedef onSlideDirectionCallback = void Function(SlideDirection);

enum SlideDirection {
  SwipeUp,
  SwipeDown,
  Def,
}

class CommonListWidget extends StatelessWidget {
  final int itemCount;
  final ScrollController? scrollController;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;

  final VoidCallback? onRefresh;
  final VoidCallback? onLoad;
  final RefreshController? _controller;
  final bool enableRefresh, enableLoad, initialRefresh;

  final VisibleIndexListCallback? visibleIndexListCallback;
  final onSlideDirectionCallback? slideDirectionCallback;
  final Widget? separatorLine;

  // final onRefreshCallback? onRefresh;
  // final onLoadCallback? onLoad;

  CommonListWidget({
    this.onLoad,
    this.onRefresh,
    required this.itemBuilder,
    this.itemCount = 0,
    this.scrollController,
    this.padding,
    this.enableRefresh = false,
    this.enableLoad = false,
    this.initialRefresh = true,
    RefreshController? controller,
    this.separatorLine,
    this.visibleIndexListCallback,
    this.slideDirectionCallback,
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
      ? _buildNotificationListenerListView()
      : _buildListViewObserverView();

  Widget _buildRefresh() {
    return RefreshConfiguration(
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
          enablePullUp: enableLoad,
          enablePullDown: enableRefresh,
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
          child: _buildListView(),
        ));
  }

  Widget _buildListViewObserverView() {
    return ListViewObserver(
      child: _buildRefresh(),
      sliverListContexts: () {
        return [if (_sliverListViewContext != null) _sliverListViewContext!];
      },
      onObserveAll: (resultMap) {
        final model = resultMap[_sliverListViewContext];
        if (model == null) return;
        // debugPrint('ScrollviewObserverPage visible -- ${model.visible}');
        // debugPrint(
        //     'ScrollviewObserverPage firstChild.index -- ${model.firstChild?.index}');
        // debugPrint(
        //     'ScrollviewObserverPage displaying -- ${model.displayingChildIndexList}');
        visibleIndexs = model.displayingChildIndexList;
      },
    );
  }

  BuildContext? _sliverListViewContext;

  ListView _buildListView() {
    return ListView.separated(
      padding: padding,
      controller: scrollController,
      itemBuilder: (ctx, index) {
        // 在 builder 回调中，将 BuildContext 记录起来
        if (_sliverListViewContext != ctx) {
          _sliverListViewContext = ctx;
        }
        return itemBuilder(ctx, index);
      },
      separatorBuilder: (ctx, index) {
        return separatorLine ??
            const Divider(
              height: 16,
            );
      },
      itemCount: itemCount,
    );
  }

  List<int> visibleIndexs = [];

  double _previousPixels = 0.0;

  var slideDirection = SlideDirection.Def;

  Widget _buildNotificationListenerListView() {
    return NotificationListener(
        onNotification: (ScrollNotification notification) {
          //1.监听事件的类型
          if (notification is ScrollStartNotification) {
            // print("开始滚动...");
          } else if (notification is ScrollUpdateNotification) {
            //当前滚动的位置和总长度
            final currentPixel = notification.metrics.pixels;
            final totalPixel = notification.metrics.maxScrollExtent;
            double progress = currentPixel / totalPixel;

            final wasScrolledUp = currentPixel < _previousPixels; // 判断是否上滑
            _previousPixels = currentPixel; // 更新前一帧的滚动位置
            // 根据wasScrolledUp判断上滑还是下滑
            if (wasScrolledUp) {
              slideDirection = SlideDirection.SwipeUp;
            } else {
              slideDirection = SlideDirection.SwipeDown;
            }
            // print("正在滚动：${notification.metrics.pixels} - ${notification.metrics.maxScrollExtent}");
          } else if (notification is ScrollEndNotification) {
            // print("滚动结束....");
            visibleIndexListCallback?.call(visibleIndexs);
            slideDirectionCallback?.call(slideDirection);
          }
          return false;
        },
        child: _buildListViewObserverView());
  }
}
