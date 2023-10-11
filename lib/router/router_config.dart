import 'dart:async';

import 'package:flutter_commonlib/main.dart';
import 'package:flutter_commonlib/ui/list_page.dart';
import 'package:flutter_commonlib/ui/msg_page.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/camera_watermark.dart';
import '../ui/cameras_page.dart';
import '../ui/home_page.dart';
import '../ui/permission_widget.dart';

class RouterRULConfig {
  static const main = "/mian";
  static const list = "/list";
  static const home = "/home";
  static const msg = "/msg";
  static const my = "/my";
  static const permission = "/permission";
  static const camera = "/camera";
  static const watermark = "/watermark";
}


final List<GetPage>  pages = [
  GetPage(name: RouterRULConfig.main, page: () => MainPage(),transition: Transition.zoom),
  GetPage(name: RouterRULConfig.home, page: () => HomePage() ),
  GetPage(name: RouterRULConfig.msg, page: () => MsgPage()),
  GetPage(name: RouterRULConfig.my, page: () => MyApp()),
  GetPage(name: RouterRULConfig.list, page: () => CommonListPage(),transition: Transition.zoom),
  GetPage(name: RouterRULConfig.permission, page: () => PermissionHandlerWidget()),
  GetPage(name: RouterRULConfig.watermark, page: () => WatermarkPage()),
];


final StreamController<String> currentRouterController = StreamController<String>.broadcast();

// addStream(currentRouterController.stream.listen((event) {
// if (event == RouterRULConfig.HOME)
// {
// viewModel.getData();
// }
// }));