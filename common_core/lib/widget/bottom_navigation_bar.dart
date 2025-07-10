import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/theme.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidget createState() => _BottomNavigationBarWidget();

  final List<Widget> children;
  final List<BottomNavigationBarItem> bottomNavigationBarItems;
  final Color selectedItemColor, unselectedItemColor;
  final double selectedFontSize, unselectedFontSize,iconSize;
  final int initialPage=0;

  BottomNavigationBarWidget({
    super.key,
    required this.children,
    required this.bottomNavigationBarItems,
    this.selectedItemColor = Colors.deepPurpleAccent,
    this.unselectedItemColor = Colors.blue,
    this.selectedFontSize = 14,
    this.unselectedFontSize = 14,  this.iconSize=24,
  });
}

class _BottomNavigationBarWidget extends State<BottomNavigationBarWidget> {
  // 当前子项索引
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: widget.initialPage);
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(), // 禁用滑动
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          children: widget.children,
        ),
        // 底部导航栏
        bottomNavigationBar: Theme(
          data: ThemeData(
            // 去掉水波纹效果
            splashColor: Colors.transparent,
            // 去掉长按效果
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: getThemeData().scaffoldBackgroundColor,
            // 当前页面索引
            currentIndex: currentIndex,
            // 设置文字大小
            selectedFontSize: widget.selectedFontSize,
            unselectedFontSize: widget.unselectedFontSize,
            // 背景颜色
            // backgroundColor: Colors.black,
            // 选中颜色
            selectedItemColor: widget.selectedItemColor,
            // 未选中颜色
            unselectedItemColor: widget.unselectedItemColor,
            // fixedColor: Colors.red,
            // 显示选中的文字 动画
            // type: BottomNavigationBarType.shifting,
            // 显示选中的文字
            showSelectedLabels: true,
            // 显示不选中时文字
            showUnselectedLabels: true,
            // 选中图标主题
            selectedIconTheme: IconThemeData(
              // 图标颜色
              color: widget.selectedItemColor,
              // 图标大小
              size: widget.iconSize,
              // 图标透明度
              opacity: 1.0,
            ),

            // // 未选中图标主题
            unselectedIconTheme: IconThemeData(
              color: widget.unselectedItemColor,
              size: widget.iconSize,
              opacity: 0.5,
            ),
            items: widget.bottomNavigationBarItems,
            // 导航子项集
            // items: const [
            //   // 导航子项
            //   BottomNavigationBarItem(
            //     // 图标
            //     icon: Icon(Icons.home),
            //     // 文字内容
            //     label: '首页',
            //type: BottomNavigationBarType.shifting 和这个配合
            //     backgroundColor: Colors.blue,
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.message_rounded),
            //     label: '消息',
            //type: BottomNavigationBarType.shifting 和这个配合
            //     backgroundColor: Colors.orange,
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.people),
            //     label: '我的',
            //type: BottomNavigationBarType.shifting 和这个配合
            //     backgroundColor: Colors.red,
            //   ),
            // ],
            onTap: (int index) {
              setState(() {
                currentIndex = index;
                controller.jumpToPage(currentIndex);
              });
            },
          ),
        ));
  }
}
