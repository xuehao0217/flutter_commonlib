import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Flutter ↔️ H5 通信通道封装
/// WebViewChannel.setDefaultChannel("AncherChannel");
/// WebViewChannel.listen((msg) {
/// if (msg.startsWith('input:')) {
/// final content = msg.replaceFirst('input:', '');
/// print("收到 H5 Toast 请求: $content");
/// Get2Named(RouterRULConfig.chatAI, arguments: content);
/// }
/// });
/// - 支持多通道绑定
/// - 支持全局默认通道名配置
/// - 支持双向通信（JS → Flutter / Flutter → JS）
/// - 与 GetX 无缝结合（响应式流）
class WebViewChannel {
  /// 全局默认通道名（可以在启动时改）
  static String defaultChannelName = 'AncherChannel';

  /// 所有通道消息流缓存
  static final Map<String, RxnString> _channels = {};

  /// 设置全局默认通道名
  static void setDefaultChannel(String name) {
    defaultChannelName = name;
  }

  /// 获取通道的消息流（若不存在则创建）
  static RxnString _ensureStream(String name) {
    return _channels.putIfAbsent(name, () => RxnString());
  }

  /// 绑定通道到 WebView
  static void bind(WebViewController controller, {String? channelName}) {
    final name = channelName ?? defaultChannelName;
    final messageStream = _ensureStream(name);

    controller.addJavaScriptChannel(
      name,
      onMessageReceived: (JavaScriptMessage message) {
        if (kDebugMode) {
          print("📩 [JS→Flutter][$name]: ${message.message}");
        }
        messageStream.value = message.message;
      },
    );
  }

  /// Flutter 监听 H5 消息
  static void listen(Function(String msg) onMessage, {String? channelName}) {
    final name = channelName ?? defaultChannelName;
    final stream = _ensureStream(name);

    ever<String?>(stream, (value) {
      if (value != null) onMessage(value);
    });
  }

  /// Flutter 发送消息给 H5
  static Future<void> postMessage(
    WebViewController controller,
    String msg, {
    String? channelName,
  }) async {
    final name = channelName ?? defaultChannelName;
    if (kDebugMode) {
      print("📤 [Flutter→JS][$name]: $msg");
    }

    await controller.runJavaScript('''
      if (window.dispatchEvent) {
        window.dispatchEvent(new CustomEvent('$name', { detail: '$msg' }));
      } else {
        console.warn('No dispatchEvent support for channel $name');
      }
    ''');
  }

  /// 手动触发（从外部模拟 H5 消息）
  static void emit(String msg, {String? channelName}) {
    final name = channelName ?? defaultChannelName;
    _ensureStream(name).value = msg;
  }

  /// 判断通道是否已绑定
  static bool isBound(String? name) =>
      _channels.containsKey(name ?? defaultChannelName);
}
