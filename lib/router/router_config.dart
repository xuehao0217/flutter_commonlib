
import 'dart:async';

import 'package:common_core/widget/webview/web_view.dart';
import 'package:get/get.dart';
import '../ui/blurry_page.dart';
import '../ui/camera_watermark.dart';
import '../ui/download_page.dart';
import '../ui/flutter_helper_kit.dart';
import '../ui/gridview_page.dart';
import '../ui/home_page.dart';
import '../ui/main_page.dart';
import '../ui/msg_page.dart';
import '../ui/my_page.dart';
import '../ui/refresh_list_page.dart';
import '../ui/scroll_demo_page.dart';
import '../ui/single_child_scroll.dart';

/// 应用内路由名常量（与 [pages] 中 [GetPage.name] 一致）。
class RouterUrlConfig {
  static const main = "/main";
  static const list_refresh = "/list_refresh";
  static const home = "/home";
  static const msg = "/msg";
  static const my = "/my";
  static const watermark = "/watermark";
  static const blurry = "/blurry";
  static const single_child_scroll = "/single_child_scroll";
  static const webview = "/webview";
  static const download = "/download";
  static const flutter_helper_kit = "/flutter_helper_kit";
  static const scroll_demo = "/scroll_demo";
  static const grid_view = "/grid_view";
}

final List<GetPage>  pages = [
  GetPage(name: RouterUrlConfig.main, page: () => const MainPage(),transition: Transition.zoom),
  GetPage(name: RouterUrlConfig.flutter_helper_kit, page: () => FlutterHelperKit()),
  GetPage(name: RouterUrlConfig.download, page: () => DownloadPage()),
  GetPage(name: RouterUrlConfig.scroll_demo, page: () => BindShowOnScrollDemoPage()),
  GetPage(name: RouterUrlConfig.home, page: () => HomePage() ),
  GetPage(name: RouterUrlConfig.msg, page: () => MsgPage()),
  GetPage(name: RouterUrlConfig.my, page: () => MyPage()),
  GetPage(name: RouterUrlConfig.watermark, page: () => WatermarkPage()),
  GetPage(name: RouterUrlConfig.list_refresh, page: () => RefreshListPage()),
  GetPage(name: RouterUrlConfig.blurry, page: () => BlurryPage(),transitionDuration: Duration(milliseconds: 1000)),
  GetPage(name: RouterUrlConfig.single_child_scroll, page: () => SingleChildScrollViewPage()),
  GetPage(name: RouterUrlConfig.webview, page: () => WebViewPage()),
  GetPage(name: RouterUrlConfig.grid_view, page: () => GridviewPage()),

];


final StreamController<String> currentRouterController = StreamController<String>.broadcast();
