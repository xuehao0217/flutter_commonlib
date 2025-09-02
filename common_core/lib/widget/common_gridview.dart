import 'package:flutter/cupertino.dart';

typedef GridViewItemBuilder<T> = Widget Function(int index, T item);

class CommonGridView<T> extends StatelessWidget {
  final List<T> items;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final int crossAxisCount;
  final double childAspectRatio, crossAxisSpacing, mainAxisSpacing;
  final GridViewItemBuilder<T> itemViewBuilder;

  const CommonGridView({
    super.key,
    required this.items,
    required this.crossAxisCount,
    required this.itemViewBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,  //true 时：physics: NeverScrollableScrollPhysics()
    this.padding = EdgeInsets.zero,
    this.physics,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return CommonGridView.builderGridView(
      items: items,
      crossAxisCount: crossAxisCount,
      itemViewBuilder: itemViewBuilder,
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      padding: padding,
      physics: physics,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
    );
  }

  /// 静态方法，支持复用：也可直接调用 CommonGridView.builderGridView(...)
  static GridView builderGridView<T>({
    required List<T> items,
    required int crossAxisCount,
    required GridViewItemBuilder<T> itemViewBuilder,
    Axis scrollDirection = Axis.vertical,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    double childAspectRatio = 1.0,
    double crossAxisSpacing = 0.0,
    double mainAxisSpacing = 0.0,
  }) {
    return GridView.builder(
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return itemViewBuilder(index, items[index]);
      },
    );
  }
}
