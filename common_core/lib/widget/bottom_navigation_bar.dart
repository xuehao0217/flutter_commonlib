import 'package:flutter/material.dart';

/// 通用底部导航栏组件
///
/// 支持：
/// - ✅ 明暗模式自动适配（暗黑模式颜色与亮色模式分开设置）
/// - ✅ 禁用滑动切换（使用 BottomNavigationBar 点击切换）
/// - ✅ 自定义字体大小、图标大小、选中/未选中颜色
///
/// 示例：
/// ```dart
/// BottomNavigationBarWidget(
///   children: [HomePage(), MessagePage(), ProfilePage()],
///   bottomNavigationBarItems: const [
///     BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
///     BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
///     BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
///   ],
///   lightSelectedItemColor: Colors.deepPurpleAccent,
///   lightUnselectedItemColor: Colors.grey,
///   darkSelectedItemColor: Colors.white,
///   darkUnselectedItemColor: Colors.white38,
/// )
/// ```
class BottomNavigationBarWidget extends StatefulWidget {
  /// 页面内容列表，每个子项对应一个底部导航项
  final List<Widget> children;

  /// 底部导航栏的 item 列表（图标 + 文本）
  final List<BottomNavigationBarItem> bottomNavigationBarItems;

  /// 明亮模式下 —— 选中图标和文字的颜色
  final Color? lightSelectedItemColor;

  /// 明亮模式下 —— 未选中图标和文字的颜色
  final Color? lightUnselectedItemColor;

  /// 暗黑模式下 —— 选中图标和文字的颜色
  final Color? darkSelectedItemColor;

  /// 暗黑模式下 —— 未选中图标和文字的颜色
  final Color? darkUnselectedItemColor;

  /// 选中文字大小（默认 14）
  final double selectedFontSize;

  /// 未选中文字大小（默认 12）
  final double unselectedFontSize;

  /// 图标大小（默认 24）
  final double iconSize;

  /// 初始显示的页面索引（默认 0）
  final int initialPage;

  const BottomNavigationBarWidget({
    super.key,
    required this.children,
    required this.bottomNavigationBarItems,
    this.lightSelectedItemColor,
    this.lightUnselectedItemColor,
    this.darkSelectedItemColor,
    this.darkUnselectedItemColor,
    this.selectedFontSize = 14,
    this.unselectedFontSize = 12,
    this.iconSize = 24,
    this.initialPage = 0,
  });

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  /// 当前选中的导航索引
  late int currentIndex;

  /// 页面控制器，用于切换 PageView 页面
  late PageController controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialPage;
    controller = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    // 根据亮暗模式自动选择颜色
    final Color selectedColor = brightness == Brightness.dark
        ? (widget.darkSelectedItemColor ?? Colors.white)
        : (widget.lightSelectedItemColor ?? Colors.deepPurpleAccent);

    final Color unselectedColor = brightness == Brightness.dark
        ? (widget.darkUnselectedItemColor ?? Colors.white60)
        : (widget.lightUnselectedItemColor ?? Colors.blueGrey);

    return Scaffold(
      // 主体内容区
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(), // 禁止滑动切换
        onPageChanged: (index) => setState(() => currentIndex = index),
        children: widget.children,
      ),

      // 底部导航栏
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // 去掉水波纹
          highlightColor: Colors.transparent, // 去掉长按高亮
        ),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          currentIndex: currentIndex,
          selectedFontSize: widget.selectedFontSize,
          unselectedFontSize: widget.unselectedFontSize,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,

          selectedIconTheme: IconThemeData(
            color: selectedColor,
            size: widget.iconSize,
          ),
          unselectedIconTheme: IconThemeData(
            color: unselectedColor,
            size: widget.iconSize,
          ),

          items: widget.bottomNavigationBarItems,
          onTap: (index) {
            if (index == currentIndex) return; // 防止重复点击
            setState(() => currentIndex = index);
            controller.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
