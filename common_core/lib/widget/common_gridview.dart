import 'package:flutter/cupertino.dart';

class CommonGridView<T> extends StatelessWidget {
  final List<T> items;
  final int crossAxisCount;
  final double childAspectRatio, crossAxisSpacing, mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget Function(T, int) itemViewBuilder;

  final Widget? header;
  final Widget? footer;
  final Widget? emptyView;

  const CommonGridView({
    super.key,
    required this.items,
    required this.crossAxisCount,
    required this.itemViewBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.header,
    this.footer,
    this.emptyView,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && emptyView != null) {
      return emptyView!;
    }

    final grid = GridView.builder(
      itemCount: items.length,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : physics,
      scrollDirection: scrollDirection,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return KeyedSubtree(
          key: ValueKey(item.hashCode),
          child: itemViewBuilder(item, index),
        );
      },
    );

    if (header == null && footer == null) return grid;

    return CustomScrollView(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      slivers: [
        if (header != null) SliverToBoxAdapter(child: header),
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              return KeyedSubtree(
                key: ValueKey(item.hashCode),
                child: itemViewBuilder(item, index),
              );
            }, childCount: items.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
          ),
        ),
        if (footer != null) SliverToBoxAdapter(child: footer),
      ],
    );
  }

  /// 通用静态构建方法，可直接调用 CommonGridView.builderGridView(...)
  static GridView builderGridView<T>({
    required List<T> items,
    required int crossAxisCount,
    required Widget Function(BuildContext context, T item, int index)
    itemViewBuilder,
    Axis scrollDirection = Axis.vertical,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    double childAspectRatio = 1.0,
    double crossAxisSpacing = 0.0,
    double mainAxisSpacing = 0.0,
  }) {
    return GridView.builder(
      itemCount: items.length,
      padding: padding ?? EdgeInsets.zero,
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : physics,
      scrollDirection: scrollDirection,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return KeyedSubtree(
          key: ValueKey(item.hashCode),
          child: itemViewBuilder(context, item, index),
        );
      },
    );
  }
}
