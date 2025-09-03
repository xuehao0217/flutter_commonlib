import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_listview.dart';

///////////////////////////////////DEMO////////////////////////////////////////////////////
class HorizontalScrollProgressWidgetDemoPage extends StatelessWidget {
  const HorizontalScrollProgressWidgetDemoPage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(20, (index) => 'Item $index');
    return HorizontalScrollProgressWidget<String>(
      items: items,
      spacing: 12,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      thumbWidth: 80,
      progressHeight: 6,
      trackColor: Colors.grey.shade300,
      thumbColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(3),
      itemBuilder: (context, item, index) {
        return Container(
          width: 120,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            item,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      },
      progress: 0, // 初始进度，由组件内部自动更新
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////

class HorizontalScrollProgressWidget<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final ScrollController? controller;

  /// 滑动进度 0~1
  final double progress;

  /// 总宽度（默认屏幕宽度）
  final double? progressWidth;

  /// 高度（默认 4）
  final double progressHeight;

  /// 滑块宽度（默认 60）
  final double thumbWidth;

  /// 背景条颜色（默认灰色）
  final Color trackColor;

  /// 滑块颜色（默认黑色）
  final Color thumbColor;

  /// 圆角（默认 2）
  final BorderRadiusGeometry borderRadius;


  /// Tab 与  Scroll 的间距
  final double spacingBetweenBarAndScroll;

  const HorizontalScrollProgressWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.spacing = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.progress = 0.0,
    this.thumbWidth = 60.0,
    this.progressHeight = 4.0,
    this.trackColor = const Color(0xFFE0E0E0),
    this.thumbColor = Colors.black,
    this.borderRadius = const BorderRadius.all(Radius.circular(2)),
    this.controller,
    this.progressWidth, this.spacingBetweenBarAndScroll = 12,
  });

  @override
  _HorizontalScrollProgressWidgetState<T> createState() => _HorizontalScrollProgressWidgetState<T>();
}

class _HorizontalScrollProgressWidgetState<T> extends State<HorizontalScrollProgressWidget<T>> {
  late final ScrollController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(() {
      final maxScroll = _controller.position.maxScrollExtent;
      final currentScroll = _controller.offset;
      setState(() {
        _progress = (currentScroll / (maxScroll == 0 ? 1 : maxScroll)).clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ScrollProgressBar(
          progress: _progress,
          width: widget.progressWidth ?? screenWidth,
          thumbWidth: widget.thumbWidth,
          height: widget.progressHeight,
          trackColor: widget.trackColor,
          thumbColor: widget.thumbColor,
          borderRadius: widget.borderRadius,
        ),
        SizedBox(height: widget.spacingBetweenBarAndScroll),
        Expanded(
          child: HorizontalWrapList<T>(
            items: widget.items,
            itemBuilder: widget.itemBuilder,
            controller: _controller,
            spacing: widget.spacing,
            padding: widget.padding,
          ),
        ),
      ],
    );
  }
}

/// 通用可自定义滚动进度条
class ScrollProgressBar extends StatelessWidget {
  /// 滑动进度 0~1
  final double progress;

  /// 总宽度（默认屏幕宽度）
  final double width;

  /// 滑块宽度（默认 60）
  final double thumbWidth;

  /// 高度（默认 4）
  final double height;

  /// 背景条颜色（默认灰色）
  final Color trackColor;

  /// 滑块颜色（默认黑色）
  final Color thumbColor;

  /// 圆角（默认 2）
  final BorderRadiusGeometry borderRadius;

  const ScrollProgressBar({
    super.key,
    required this.progress,
    required this.width,
    this.thumbWidth = 60.0,
    this.height = 4.0,
    this.trackColor = const Color(0xFFE0E0E0),
    this.thumbColor = Colors.black,
    this.borderRadius = const BorderRadius.all(Radius.circular(2)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: trackColor, borderRadius: borderRadius),
      child: Stack(
        children: [
          Positioned(
            left: progress * (width - thumbWidth),
            child: Container(
              width: thumbWidth,
              height: height,
              decoration: BoxDecoration(
                color: thumbColor,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
