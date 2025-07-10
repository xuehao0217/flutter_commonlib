
import 'dart:async';

import 'package:common_core/widget/web_view.dart';
import 'package:flutter_commonlib/main.dart';
import 'package:flutter_commonlib/ui/msg_page.dart';
import 'package:get/get.dart';
import '../ui/blurry_page.dart';
import '../ui/camera_watermark.dart';
import '../ui/home_page.dart';
import '../ui/main_page.dart';
import '../ui/permission_widget.dart';
import '../ui/refresh_list_page.dart';
import '../ui/single_child_scroll.dart';

class RouterRULConfig {
  static const main = "/mian";
  static const list_refensh = "/list_refensh";
  static const home = "/home";
  static const msg = "/msg";
  static const my = "/my";
  static const permission = "/permission";
  static const camera = "/camera";
  static const watermark = "/watermark";

  static const loading_state = "/loading_state";

  static const scroll_index = "/scroll_index";
  static const scrollview_observe = "/scrollview_observe";

  static const two_level = "/two_level";

  static const blurry = "/blurry";

  static const single_child_scroll = "/single_child_scroll";

  static const webview = "/webview";
}


final List<GetPage>  pages = [
  GetPage(name: RouterRULConfig.main, page: () => MainPage(),transition: Transition.zoom),
  GetPage(name: RouterRULConfig.home, page: () => HomePage() ),
  GetPage(name: RouterRULConfig.msg, page: () => MsgPage()),
  GetPage(name: RouterRULConfig.my, page: () => MyApp()),
  GetPage(name: RouterRULConfig.permission, page: () => PermissionHandlerWidget()),
  GetPage(name: RouterRULConfig.watermark, page: () => WatermarkPage()),
  GetPage(name: RouterRULConfig.list_refensh, page: () => RefreshListPage()),
  GetPage(name: RouterRULConfig.blurry, page: () => BlurryPage(),transitionDuration: Duration(milliseconds: 1000)),
  GetPage(name: RouterRULConfig.single_child_scroll, page: () => SingleChildScrollViewPage()),
  GetPage(name: RouterRULConfig.webview, page: () => WebViewPage()),
];


final StreamController<String> currentRouterController = StreamController<String>.broadcast();

// addStream(currentRouterController.stream.listen((event) {
// if (event == RouterRULConfig.HOME)
// {
// viewModel.getData();
// }
// }));