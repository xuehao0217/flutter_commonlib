
import 'dart:async';

import 'package:common_core/widget/webview/web_view.dart';
import 'package:flutter_commonlib/main.dart';
import 'package:flutter_commonlib/ui/msg_page.dart';
import 'package:get/get.dart';
import '../ui/blurry_page.dart';
import '../ui/camera_watermark.dart';
import '../ui/download_page.dart';
import '../ui/flutter_helper_kit.dart';
import '../ui/home_page.dart';
import '../ui/main_page.dart';
import '../ui/refresh_list_page.dart';
import '../ui/single_child_scroll.dart';

class RouterRULConfig {
  static const main = "/mian";
  static const list_refensh = "/list_refensh";
  static const home = "/home";
  static const msg = "/msg";
  static const my = "/my";
  static const camera = "/camera";
  static const watermark = "/watermark";
  static const scroll_index = "/scroll_index";
  static const blurry = "/blurry";
  static const single_child_scroll = "/single_child_scroll";
  static const webview = "/webview";
  static const download = "/download";
  static const flutter_helper_kit = "/flutter_helper_kit";
}


final List<GetPage>  pages = [
  GetPage(name: RouterRULConfig.main, page: () => MainPage(),transition: Transition.zoom),
  GetPage(name: RouterRULConfig.flutter_helper_kit, page: () => FlutterHelperKit()),
  GetPage(name: RouterRULConfig.download, page: () => DownloadPage()),
  GetPage(name: RouterRULConfig.home, page: () => HomePage() ),
  GetPage(name: RouterRULConfig.msg, page: () => MsgPage()),
  GetPage(name: RouterRULConfig.my, page: () => MyApp()),
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