import 'package:flutter/material.dart';
import 'package:flutter_commonlib/router/router_config.dart';
import 'package:flutter_commonlib/ui/home_page.dart';
import 'package:flutter_commonlib/ui/msg_page.dart';
import 'package:flutter_commonlib/ui/my_page.dart';
import 'package:flutter_commonlib/widget/bottom_navigation_bar.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'api/http_api.dart';
import 'base/base_page_stateful_widget.dart';
import 'helpter/log_utils.dart';
import 'net/dio_utils.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    Log.init();
    configDio(
      baseUrl: HttpApi.baseUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouterRULConfig.main,
      builder: FlutterSmartDialog.init(),
      // 注册路由观察者
      navigatorObservers: <NavigatorObserver>[routeObserver],
      routingCallback: (routing) {
        currentRouterController.add("${routing?.current}");
      },
      // 定义路由表
      getPages:pages,
    );
  }
}


//////////////////////////////////////////////////////////////////////////////////
class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends BasePgaeStatefulWidget{
  @override
  void initState() {
    super.initState();
    initialization();
  }
  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget buildPageContent(BuildContext context) =>BottomNavigationBarWidget(
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey ,
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
  bool showTitleBar() =>false;
  @override
  bool showStatusBar() =>false;
}


