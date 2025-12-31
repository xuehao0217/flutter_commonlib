import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:get/get.dart';
import '../base/mvvm/base_list_view_model.dart';
import 'package:smart_scroll/smart_scroll.dart' as pull;

// --- Existing Extensions (Untouched) ---

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

  EasyRefresh intoEasyRefreshList(
    BaseListViewModel viewModel, {
    Header? header,
    Footer? footer,
    EasyRefreshController? controller,
    ScrollController? scrollController,
    bool refreshOnStart = false,
  }) => intoEasyRefresh(
    onRefresh: () => viewModel.getRefreshData(),
    onLoad: () async {
      return await viewModel.getLoadData();
    },
    header: header,
    footer: footer,
    controller: controller,
    scrollController: scrollController,
    refreshOnStart: refreshOnStart,
  );
}

extension RefreshControllerExt on pull.RefreshController {
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

  void finishLoad({bool success = true, bool noMore = false}) {
    if (success) {
      if (noMore) {
        loadNoData();
      } else {
        loadComplete();
      }
    } else {
      loadFailed();
    }
  }
}


extension SmartRefresherExt<T> on ListView {
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
      onLoad: () async {
        return await viewModel.getLoadData();
      },
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
        controller ?? pull.RefreshController(initialRefresh: true);
    return pull.RefreshConfiguration(
      headerTriggerDistance: 80.0,
      maxOverScrollExtent: 100,
      maxUnderScrollExtent: 0,
      child: pull.SmartScroll(
        scrollController: scrollController,
        enablePullUp: enablePullUp,
        enablePullDown: enableRefresh,
        header: header ?? const pull.ClassicHeader(),
        footer: footer ?? const pull.ClassicFooter(),
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


class SmartRefresherListView<T> extends StatefulWidget {
  final BaseListViewModel<T> viewModel;
  final bool enableRefresh;
  final bool enablePullUp;
  final Widget? header;
  final Widget? footer;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final ListView listView;

  const SmartRefresherListView({
    super.key,
    required this.viewModel,
    this.enableRefresh = true,
    this.enablePullUp = true,
    this.header,
    this.footer,
    this.emptyWidget,
    this.loadingWidget,
    required this.listView,
  });

  @override
  State<SmartRefresherListView<T>> createState() => _SmartRefresherListViewState<T>();
}

class _SmartRefresherListViewState<T> extends State<SmartRefresherListView<T>> {
  late final pull.RefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = pull.RefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await widget.viewModel.getRefreshData();
    _controller.finishRefresh();
  }

  Future<void> _onLoading() async {
    final hasMore = await widget.viewModel.getLoadData();
    if (!hasMore) {
      _controller.finishLoad(noMore: true);
    } else {
      _controller.finishLoad();
    }
  }

  @override
  Widget build(BuildContext context) {
    return pull.SmartScroll(
      controller: _controller,
      enablePullDown: widget.enableRefresh,
      enablePullUp: widget.enablePullUp,
      header: widget.header ?? const pull.ClassicHeader(),
      footer: widget.footer ?? pull.ClassicFooter(),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: widget.listView,
    );
  }
}
