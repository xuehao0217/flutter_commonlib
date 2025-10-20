
import 'package:common_core/common_core.dart';
import 'package:common_core/widget/webview/webview_channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../base/base_stateful_widget.dart';
class WebViewPage extends StatefulWidget {
  static String Url = "url";
  static String Title = "title";


  final String url;
  final String title;

  /// 构造函数兼容直接传参和 GetX 参数
  WebViewPage({
    super.key,
    String? url,
    String? title,
  })  : url = url ?? Get.arguments as String? ?? Get.parameters['url'] ?? "",
        title = title ?? Get.parameters['title'] ?? "";

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
    controller = WebViewController()
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
            return NavigationDecision.navigate; // 永远允许跳转
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    controller.setOnScrollPositionChange((ScrollPositionChange change) {
      setState(() {
        opacity = (change.y / 150).clamp(0.0, 1.0);
      });
    });

    WebViewChannel.bind(controller);
  }

  @override
  String setTitle() {
    return _pageTitle;
  }

  /// 从 url 查询参数中判断是否隐藏某个元素
  bool _isHidden(String key) {
    final value = Uri.parse(widget.url).queryParameters[key];
    return value != null && value.isNotEmpty;
  }

  @override
  bool showTitleBar() => !_isHidden('hideTitle');

  @override
  bool showNavigationBar() => !_isHidden('hideNav');

  @override
  Widget buildPageContent(BuildContext context) {
    return PopScope(
      canPop: false, // 禁止系统直接 pop，我们手动控制
      onPopInvokedWithResult: (didPop, result) async {
        await onBackPressed();
      },
      child: Column(
        children: [
          if (_progress < 1)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          Stack(
            children: [
              WebViewWidget(controller: controller),
              if (!showTitleBar())
                Opacity(
                  opacity: opacity,
                  child: getCommonTitleBarWidget(context),
                ),
            ],
          ).intoExpanded(),
        ],
      ),
    );
  }


  @override
  Future<void> onBackPressed() async {
    if (await controller.canGoBack()) {
      controller.goBack();
    } else {
      super.onBackPressed();
    }
  }
}



