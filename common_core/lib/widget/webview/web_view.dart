
import 'package:common_core/common_core.dart';
import 'package:common_core/helpter/logger_helper.dart';
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
            "将要跳转到: ${request.url}".logI;
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
  bool isNotEmpty(String key) {
    final value = Uri.parse(widget.url).queryParameters[key];
    return value != null && value.isNotEmpty;
  }

  @override
  bool showTitleBar() => !isNotEmpty('hideTitle');

  @override
  bool showNavigationBar() => !isNotEmpty('hideNav');

  @override
  bool showBackIcon() {
    return !isNotEmpty('hideBack');
  }

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
          ).withExpanded(),
        ],
      ),
    );
  }

  @override
  Widget? setRightTitleContent() {
    // 使用单例配置，通过当前 WebView 的 url 获取对应的 Widget
    return WebBuildConfig().buildRightTitleContent(context, widget.url);
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


void main(){
  // 配置 WebView 右侧标题内容
  WebBuildConfig().setRightTitleBuilder((context, url) {
    if (url.contains("baidu")) {
     return Row();
    }
    return Row(); // 默认空
  });
}

/// 单例 WebBuildConfig
class WebBuildConfig {
  WebBuildConfig._privateConstructor();

  static final WebBuildConfig _instance = WebBuildConfig._privateConstructor();

  factory WebBuildConfig() => _instance;

  /// 回调类型：传入 context 和当前 url，返回 Widget
  Widget Function(BuildContext context, String url)? rightTitleBuilder;

  /// 设置右侧标题内容回调
  void setRightTitleBuilder(Widget Function(BuildContext context, String url) builder) {
    rightTitleBuilder = builder;
  }

  /// 获取右侧标题 Widget
  Widget buildRightTitleContent(BuildContext context, String url) {
    if (rightTitleBuilder != null) {
      return rightTitleBuilder!(context, url);
    }
    return Row(); // 默认空
  }
}

