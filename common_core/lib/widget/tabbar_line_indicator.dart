import 'package:common_core/common_core.dart';
import 'package:flutter/material.dart';

class TabBarLineIndicatorPageDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarLineIndicatorPage<String>(
      items: ['Tab1', 'Tab2', 'Tab3'],
      indicatorHeight: 10,
      indicatorColor: Colors.black,
      indicatorRadius: 5,
      backgroundColor: Colors.yellow,
      pageBuilder: (item, index) {
        return Center(
          child: Text(
            'Page ${index + 1}',
            style: const TextStyle(fontSize: 24, color: Colors.deepPurple),
          ),
        );
      },
    );
  }
}


class TabBarLineIndicatorPage<T> extends StatefulWidget {
  final Widget Function(T item, int index) pageBuilder; // 泛型 ItemBuilder
  final List<T> items;

  /// 指示器高度
  final double indicatorHeight;

  /// 指示器颜色
  final Color indicatorColor;

  /// 指示器圆角
  final double indicatorRadius;

  /// 背景条颜色
  final Color backgroundColor;

  /// 背景条间距
  final double spacing;

  /// tabBar 两边的边距
  final double tabBarHorizontalPadding;

  const TabBarLineIndicatorPage({
    super.key,
    required this.items,
    required this.pageBuilder,
    this.indicatorHeight = 8,
    this.indicatorColor = Colors.blue,
    this.indicatorRadius = 4,
    this.backgroundColor = const Color(0xFFD9D9D9), // 默认灰色
    this.spacing = 7,
    this.tabBarHorizontalPadding=21,
  });

  @override
  State<TabBarLineIndicatorPage<T>> createState() =>
      _TabBarLineIndicatorPageState<T>();
}

class _TabBarLineIndicatorPageState<T>
    extends State<TabBarLineIndicatorPage<T>> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width-widget.tabBarHorizontalPadding*2;
    final int tabCount = widget.items.length;
    final double barWidth =
        (screenWidth - (tabCount - 1) * widget.spacing) / tabCount;

    return Column(
      children: [
        SizedBox(
          height: widget.indicatorHeight,
          child: Stack(
            children: [
              // 背景条
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(tabCount, (index) {
                  return GestureDetector(
                    onTap: () => _onTabTap(index),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == tabCount - 1 ? 0 : widget.spacing,
                      ),
                      width: barWidth,
                      height: widget.indicatorHeight,
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(
                          widget.indicatorRadius,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              // 滑动的指示器
              AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double page = 0;
                  if (_pageController.hasClients &&
                      _pageController.page != null) {
                    page = _pageController.page!;
                  }
                  return Transform.translate(
                    offset: Offset((barWidth + widget.spacing) * page, 0),
                    child: Container(
                      width: barWidth,
                      height: widget.indicatorHeight,
                      decoration: BoxDecoration(
                        color: widget.indicatorColor,
                        borderRadius: BorderRadius.circular(
                          widget.indicatorRadius,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ).intoHorizontalPadding(widget.tabBarHorizontalPadding),
        const SizedBox(height: 16),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: tabCount,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return widget.pageBuilder(item, index);
            },
          ),
        ),
      ],
    );
  }
}
