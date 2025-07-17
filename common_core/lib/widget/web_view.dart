
import 'package:common_core/common_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../base/base_stateful_widget.dart';
import 'common_widget.dart';

class WebViewPage extends StatefulWidget {
  static String Url = "url";
  static String Title = "title";
  final String url = Get.arguments as String? ?? Get.parameters[Url] ?? "";
  final String title = Get.parameters[Title] ?? "";

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends BaseStatefulWidget<WebViewPage> {
  late WebViewController controller;
  String _pageTitle = "Loading..."; // 默认标题
  double _progress = 0.0;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  _progress = progress / 100; // 计算进度值
                });
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) async {
                var title =
                    widget.title.isEmpty
                        ? widget.title
                        : await controller.getTitle() ?? "";
                setState(() {
                  _pageTitle = title;
                });
              },
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));

    controller.setOnScrollPositionChange((ScrollPositionChange change) {
      setState(() {
        opacity = (change.y / 150).clamp(0.0, 1.0);
      });
    });
  }

  @override
  String setTitle() {
    return _pageTitle;
  }

  @override
  bool showTitleBar() {
    return !(Uri.parse(widget.url).queryParameters['hideTitle'] ?? "")
        .isNotEmpty;
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      children: [
        if (_progress < 1)
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey[200], // 进度条的背景颜色
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // 进度条的颜色
          ),
        Stack(
          children: [
            WebViewWidget(controller: controller),
            if(!showTitleBar())
              Opacity(
                opacity: opacity,
                child: getCommonTitleBarWidget(context),
              ),
          ],
        ).intoExpanded(),
      ],
    );
  }
}
