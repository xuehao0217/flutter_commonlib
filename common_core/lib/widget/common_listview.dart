import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

typedef onSlideDirectionCallback = void Function(SlideDirection);
typedef VisibleItemListCallback<T> = void Function(List<T> items);
typedef TypedListViewBuilder<T> = Widget Function(int index, T item);

enum SlideDirection { SwipeUp, SwipeDown, Def }

class CommonListView<T> extends StatelessWidget {
  final ScrollController? controller;
  final TypedListViewBuilder<T> itemBuilder;
  final EdgeInsetsGeometry? padding;

  final VisibleItemListCallback<T>? visibleListCallback;
  final onSlideDirectionCallback? slideDirectionCallback;

  final List<T> items;
  final IndexedWidgetBuilder separatorBuilder;

  final Widget? paginationWidget;
  final Widget? header;
  final Widget? footer;

  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ListObserverController? listObserverController;

  CommonListView({
    required this.itemBuilder,
    required this.items,
    required this.separatorBuilder,
    this.controller,
    this.padding = EdgeInsets.zero,
    this.visibleListCallback,
    this.slideDirectionCallback,
    this.paginationWidget,
    this.header,
    this.footer,
    this.physics,
    this.shrinkWrap = false,
    this.listObserverController,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    if(visibleListCallback==null){
      return _buildListView();
    }else{
      return _buildNotificationListenerListView();
    }
  }

  BuildContext? _sliverListViewContext;
  List<int> visibleIndexs = [];
  double _previousPixels = 0.0;
  var slideDirection = SlideDirection.Def;

  Widget _buildNotificationListenerListView() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: _buildListViewObserverView(),
    );
  }

  Widget _buildListViewObserverView() =>ListViewObserver(
    controller: listObserverController,
    child: _buildListView(),
    sliverListContexts: () => [_sliverListViewContext!],
    onObserveAll: (resultMap) {
      final model = resultMap[_sliverListViewContext];
      if (model == null) return;
      visibleIndexs = model.displayingChildIndexList;
      debugPrint('Visible indexes updated: $visibleIndexs');
    },
  );

  ListView _buildListView() {
    final hasHeader = header != null;
    final hasFooter = footer != null;
    final itemTotal = items.length + (hasHeader ? 1 : 0) + (hasFooter ? 1 : 0);

    return ListView.separated(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      scrollDirection: scrollDirection,
      itemCount: itemTotal,
      separatorBuilder: (context, index) {
        if (hasHeader && index == 0) return const SizedBox.shrink();
        if (hasFooter && index == itemTotal - 1) return const SizedBox.shrink();
        final realIndex = hasHeader ? index - 1 : index;
        return separatorBuilder(context, realIndex);
      },
      itemBuilder: (ctx, index) {
        if (_sliverListViewContext != ctx) {
          _sliverListViewContext = ctx;
        }

        if (hasHeader && index == 0) return header!;
        if (hasFooter && index == itemTotal - 1) return footer!;
        final realIndex = index - (hasHeader ? 1 : 0);
        return itemBuilder(realIndex, items[realIndex]);
      },
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _onScrollStart();
    } else if (notification is ScrollUpdateNotification) {
      _onScrollUpdate(notification);
    } else if (notification is ScrollEndNotification) {
      _onScrollEnd();
    }
    return false;
  }

  void _onScrollStart() {}

  void _onScrollUpdate(ScrollUpdateNotification notification) {
    final currentPixel = notification.metrics.pixels;
    final wasScrolledUp = currentPixel < _previousPixels;
    slideDirection = wasScrolledUp ? SlideDirection.SwipeUp : SlideDirection.SwipeDown;
    if (slideDirectionCallback != null) {
      debugPrint("滑动方向: ${slideDirection == SlideDirection.SwipeUp ? "⬆️" : "⬇️"}");
    }
    _previousPixels = currentPixel;
  }

  void _onScrollEnd() {
    if (visibleListCallback != null) {
      debugPrint("滚动结束... 可见索引: $visibleIndexs");
      final visibleItems = visibleIndexs
          .where((i) => i >= 0 && i < items.length)
          .map((i) => items[i])
          .toList();
      visibleListCallback?.call(visibleItems);
    }
    slideDirectionCallback?.call(slideDirection);
  }



  ////////////////////////////////////////////////////////////////////////////////
  static ListView buildListView<T>({
    required List<T> items,
    required TypedListViewBuilder<T> itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    EdgeInsetsGeometry? padding,
    Widget? header,
    Widget? footer,
    Axis scrollDirection = Axis.vertical,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool shrinkWrap = false,
  }) {
    final hasHeader = header != null;
    final hasFooter = footer != null;
    final itemTotal = items.length + (hasHeader ? 1 : 0) + (hasFooter ? 1 : 0);
    return ListView.separated(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding ?? EdgeInsets.zero,
      scrollDirection: scrollDirection,
      itemCount: itemTotal,
      separatorBuilder: (context, index) {
        if (hasHeader && index == 0) return const SizedBox.shrink();
        if (hasFooter && index == itemTotal - 1) return const SizedBox.shrink();
        final realIndex = hasHeader ? index - 1 : index;
        return separatorBuilder(context, realIndex);
      },
      itemBuilder: (ctx, index) {
        if (hasHeader && index == 0) return header!;
        if (hasFooter && index == itemTotal - 1) return footer!;
        final realIndex = index - (hasHeader ? 1 : 0);
        return itemBuilder(realIndex, items[realIndex]);
      },
    );
  }

}
