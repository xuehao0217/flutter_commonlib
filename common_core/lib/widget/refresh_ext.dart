import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import '../base/mvvm/base_list_view_model.dart';
import 'common_listview.dart';
import 'package:easy_refresh/easy_refresh.dart' as easy;
import 'package:smart_scroll/smart_scroll.dart' as pull;

extension EasyRefreshExt<T> on Widget {
  EasyRefresh intoEasyRefresh({
    Future<void> Function()? onRefresh,
    Future<bool> Function()? onLoad,
    Header? header,
    Footer? footer,
    EasyRefreshController? controller,
    ScrollController? scrollController,
    bool refreshOnStart = false,
  }) {
    final _controller =
        controller ??
        EasyRefreshController(
          controlFinishRefresh: true,
          controlFinishLoad: true,
        );
    return EasyRefresh(
      refreshOnStart: refreshOnStart,
      controller: _controller,
      header: header,
      footer: footer,
      scrollController: scrollController,
      onRefresh:
          onRefresh != null
              ? () async {
                await onRefresh();
                _controller.finishRefresh();
                _controller.resetFooter();
              }
              : null,
      // ✅ 不传则完全禁用
      onLoad: () async {
        if (onLoad != null) {
          var hasMore = await onLoad();
          if (!hasMore) {
            _controller.finishLoad(IndicatorResult.noMore);
          } else {
            _controller.finishLoad();
          }
        }
      },
      child: this,
    );
  }


  EasyRefresh intoEasyRefreshList(BaseListViewModel viewModel, {
    Header? header,
    Footer? footer,
    EasyRefreshController? controller,
    ScrollController? scrollController,
    bool refreshOnStart = false,
  }) => intoEasyRefresh(onRefresh: () => viewModel.getRefreshData(),
        onLoad: () async {
          return await viewModel.getLoadData();
        },
        header: header,
        footer: footer, controller: controller,
        scrollController: scrollController,
        refreshOnStart: refreshOnStart);
}

/////////////////////////////////////////////////////////////////////////////////////////////////

extension RefreshControllerExt on pull.RefreshController {
  /// 完成下拉刷新
  void finishRefresh({bool success = true, bool noMore = false}) {
    if (success) {
      if (noMore) {
        loadNoData();
      }
      refreshCompleted(resetFooterState: !noMore);
    } else {
      refreshFailed();
    }
  }

  /// 完成上拉加载
  void finishLoad({bool success = true, bool noMore = false}) {
    if (success) {
      if (noMore) {
        loadComplete();
        loadNoData();
      } else {
        loadComplete();
      }
    } else {
      loadFailed();
    }
  }
}

extension SmartRefresherExt<T> on Widget {
  /// 和 intoEasyRefreshList 对齐的封装
  pull.RefreshConfiguration intoRefreshList(
      BaseListViewModel viewModel, {
        pull.RefreshController? controller,
        ScrollController? scrollController,
        bool enableRefresh = true,
        bool enablePullUp = true,
        Widget? header,
        Widget? footer,
      }) {
    return intoRefresh(
      onRefresh: () => viewModel.getRefreshData(),
      onLoad: () async => await viewModel.getLoadData(),
      controller: controller,
      scrollController: scrollController,
      enableRefresh: enableRefresh,
      enablePullUp: enablePullUp,
      header: header,
      footer: footer,
    );
  }


  pull.RefreshConfiguration intoRefresh({
    required Future<bool> Function()? onLoad,
    required Future<void> Function()? onRefresh,
    pull.RefreshController? controller,
    ScrollController? scrollController,
    bool enableRefresh = true,
    bool enablePullUp = true,
    Widget? header,
    Widget? footer,
  }) {
    pull.RefreshController _controller =
        controller ?? pull.RefreshController(initialRefresh: false);

    return pull.RefreshConfiguration(
      headerTriggerDistance: 80.0,
      springDescription: const SpringDescription(
        stiffness: 170,
        damping: 16,
        mass: 1.9,
      ),
      maxOverScrollExtent: 100,
      maxUnderScrollExtent: 0,
      enableScrollWhenRefreshCompleted: true,
      enableLoadingWhenFailed: true,
      hideFooterWhenNotFull: false,
      enableBallisticLoad: true,
      child: pull.SmartScroll(
        scrollController: scrollController,
        enablePullUp: enablePullUp,
        enablePullDown: enableRefresh,
        header:
        header ??
            const pull.ClassicHeader(
              // refreshingText: "加载中...",
              // releaseText: "放开刷新",
              // completeText: "刷新完成",
              // idleText: "下拉刷新",
            ),
        footer:
        footer ??
            const pull.ClassicFooter(
              // loadingText: "加载中...",
              // noDataText: "到底了~",
              // idleText: "加载完成",
              // failedText: "加载失败",
            ),
        controller: _controller,
        onRefresh: () async {
          if (onRefresh != null) {
            await onRefresh();
            _controller.finishRefresh();
          }
        },
        onLoading: () async {
          if (onLoad != null) {
            var hasMore = await onLoad();
            if (!hasMore) {
              _controller.finishLoad(noMore: true);
            } else {
              _controller.finishLoad();
            }
          }
        },
        child: this,
      ),
    );
  }
}