import 'package:common_core/base/base_stateful_widget.dart';
import 'package:common_core/core_exports.dart';
import 'package:common_core/widget/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'msg_page.dart';
import 'my_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends BaseStatefulWidget with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    initialization();
    WidgetsBinding.instance.addObserver(this);
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget buildPageContent(BuildContext context) => BottomNavigationBarWidget(
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    bottomNavigationBarItems: const [
      // 导航子项
      BottomNavigationBarItem(
        // 图标
        icon: Icon(Icons.home),
        // 文字内容
        label: '首页',
        backgroundColor: Colors.blue,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message_rounded),
        label: '消息',
        backgroundColor: Colors.orange,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: '我的',
        backgroundColor: Colors.red,
      ),
    ],
    children: [
      HomePage(),
      MsgPage(),
      MyPage(),
    ],
  );

  @override
  bool showTitleBar() => false;

  @override
  bool showStatusBar() => false;

  @override
  bool showBottomNavigationBar() =>false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      // 处理应用恢复到前台的逻辑
        print("didChangeAppLifecycleState  处理应用恢复到前台的逻辑");
        break;
      case AppLifecycleState.inactive:
      // 处理应用即将进入后台的逻辑
        print("didChangeAppLifecycleState  处理应用即将进入后台的逻辑");
        break;
      case AppLifecycleState.paused:
      // 处理应用进入后台的逻辑，如保存数据、暂停定时任务等
        print("didChangeAppLifecycleState 处理应用进入后台的逻辑，如保存数据、暂停定时任务等");
        break;
      case AppLifecycleState.detached:
      // 处理应用终止或关闭的逻辑
        print("didChangeAppLifecycleState 处理应用终止或关闭的逻辑");
        break;
      case AppLifecycleState.hidden:
    }
  }
}
