
import 'package:common_core/common_core.dart';
import 'package:common_core/helpter/talker_helper.dart';
import 'package:common_core/widget/webview/web_build_config.dart';
import 'package:common_core/widget/webview/webview_channel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            final title = widget.title.isNotEmpty
                ? widget.title
                : (await controller.getTitle() ?? '');
            if (!mounted) return;
            setState(() {
              _pageTitle = title.isEmpty ? '网页' : title;
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
                // 不透明叠层，保证返回/关闭始终可点（不再用滚动 opacity，避免初始全透明）
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
                    child: getCommonTitleBarWidget(context),
                  ),
                ),
            ],
          ).withExpanded(),
        ],
      ),
    );
  }

  @override
  Widget? setRightTitleContent() {
    final extra = WebBuildConfig().buildRightTitleContent(context, widget.url);
    // hideTitle=1 时标题栏叠在 WebView 上；原先用滚动透明度导致初始不可见、无法点返回。
    // 右侧「关闭」始终退出当前页（不受站内 history 影响）。
    if (!showTitleBar()) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          extra,
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: '关闭',
            onPressed: () => Get.back(),
          ),
        ],
      );
    }
    return extra;
  }

  @override
  Future<void> onBackPressed() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    } else {
      super.onBackPressed();
    }
  }
}


