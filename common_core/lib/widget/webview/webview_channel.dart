import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebViewChannel.setDefaultChannel("AncherChannel");
/// WebViewChannel.listen((msg) {
/// if (msg.startsWith('input:')) {
/// final content = msg.replaceFirst('input:', '');
/// print("收到 H5 Toast 请求: $content");
/// }
/// });
/// Flutter ↔️ H5 通信通道封装
/// - 支持多通道绑定
/// - 支持全局默认通道名配置
/// - 支持双向通信（JS → Flutter / Flutter → JS）
/// - 与 GetX 无缝结合（响应式流）
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  // 示例用法
  WebViewChannel.setDefaultChannel("FlutterChannel");
  WebViewChannel.listen((msg) {
    if (msg.startsWith('input:')) {
      final content = msg.replaceFirst('input:', '');
      print("收到 H5 Toast 请求: $content");
    }
  });
}

/// Flutter ↔️ H5 通信通道封装
/// - 支持多通道绑定
/// - 支持全局默认通道名配置
/// - 支持双向通信（JS → Flutter / Flutter → JS）
class WebViewChannel {
  /// 默认通道名
  static String defaultChannelName = 'FlutterChannel';

  /// 已绑定的回调缓存
  static final Map<String, void Function(String)> _listeners = {};

  /// 已绑定的 controller 缓存（单例）
  static final Map<String, WebViewController> _controllers = {};

  /// 设置全局默认通道名
  static void setDefaultChannel(String name) {
    defaultChannelName = name;
  }

  /// 绑定通道到 WebView
  static void bind(WebViewController controller, {String? channelName}) {
    final name = channelName ?? defaultChannelName;

    _controllers[name] = controller; // 缓存 controller

    controller.addJavaScriptChannel(
      name,
      onMessageReceived: (JavaScriptMessage message) {
        if (kDebugMode) {
          print("📩 [JS→Flutter][$name]: ${message.message}");
        }
        // 调用已注册回调
        final callback = _listeners[name];
        if (callback != null) {
          callback(message.message);
        }
      },
    );
  }

  /// Flutter 监听 H5 消息（单独设置 callback）
  static void listen(
      void Function(String msg) onMessage, {
        String? channelName,
      }) {
    final name = channelName ?? defaultChannelName;
    _listeners[name] = onMessage;
  }

  /// Flutter 发送消息给 H5
  /// 如果未传 controller，会使用绑定时缓存的 controller
  static Future<void> postMessage(
      String msg, {
        WebViewController? controller,
        String? channelName,
      }) async {
    final name = channelName ?? defaultChannelName;
    final ctrl = controller ?? _controllers[name];

    if (ctrl == null) {
      if (kDebugMode) print("❌ WebViewChannel: controller 未绑定，无法发送消息");
      return;
    }

    if (kDebugMode) {
      print("📤 [Flutter→JS][$name]: $msg");
    }

    await ctrl.runJavaScript('''
      if (window.dispatchEvent) {
        window.dispatchEvent(new CustomEvent('$name', { detail: '$msg' }));
      } else {
        console.warn('No dispatchEvent support for channel $name');
      }
    ''');
  }
}
