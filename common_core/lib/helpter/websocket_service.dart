import 'dart:async';
import 'package:flutter_websocket_manager/flutter_websocket_manager.dart';
import 'logger_helper.dart';

Future<void> main() async {
  // 初始化连接
  await WebSocketService.init(
    "wss://example.com/ws",
    headers: {"Authorization": "Bearer token123"},
  );
  // 动态修改 header
  WebSocketService.setHeaders({"Authorization": "Bearer newToken456"});

  // 手动发送消息
  WebSocketService.sendDataMessage({
    "type": "message",
    "content": "hello world",
  });
  WebSocketService.sendDataMessageString("你好");
  // 监听消息
  WebSocketService.onMessage = (data) {
    LoggerHelper.i("收到消息: $data");
  };
  // 手动断开
  await WebSocketService.disconnect();
  // 查看连接状态
  if (WebSocketService.isConnected) {
    LoggerHelper.d("WebSocket 正常连接中");
  }
}

/// 全局 WebSocket 管理服务
class WebSocketService {
  WebSocketService._();

  static FlutterWebSocketManager? _wsManager;
  static bool _isConnected = false;
  static bool _isConnecting = false;
  static Timer? _heartbeatTimer;
  static Timer? _reconnectTimer;

  /// WebSocket 地址 & Header
  static String? _url;
  static Map<String, dynamic>? _headers;

  /// 重连设置
  static int _reconnectAttempt = 0;
  static bool _autoReconnect = true;

  /// 消息回调
  static void Function(dynamic data)? onMessage;

  /// 初始化 WebSocket
  static Future<void> init(
    String url, {
    Map<String, dynamic>? headers,
    bool autoReconnect = true,
  }) async {
    _url = url;
    _headers = headers;
    _autoReconnect = autoReconnect;
    await _connectInternal();
  }

  /// 修改 headers（下次连接/重连时使用）
  static void setHeaders(Map<String, dynamic>? headers) {
    _headers = headers;
    LoggerHelper.i("⚙️ 更新 WebSocket headers: $_headers");
  }

  /// 内部连接方法
  static Future<void> _connectInternal() async {
    if (_isConnecting || _isConnected || _url == null) return;
    _isConnecting = true;

    LoggerHelper.i("🔌 正在连接 WebSocket... ($_url)");

    try {
      _wsManager = FlutterWebSocketManager(_url!, headers: _headers);
      _wsManager!.connect();

      _wsManager!.onConnect((_) {
        _isConnected = true;
        _isConnecting = false;
        _reconnectAttempt = 0;
        LoggerHelper.i("✅ WebSocket 已连接");
        _startHeartbeat();
      });

      _wsManager!.onMessage((msg) {
        LoggerHelper.d("📩 收到消息: $msg");
        onMessage?.call(msg);
      });

      _wsManager!.onDone((msg) {
        _isConnected = false;
        LoggerHelper.w("❌ WebSocket 已关闭: $msg");
        _stopHeartbeat();
        if (_autoReconnect) _scheduleReconnect();
      });

      _wsManager!.onError((error) {
        _isConnected = false;
        LoggerHelper.e("⚠️ WebSocket 错误: $error");
        _stopHeartbeat();
        if (_autoReconnect) _scheduleReconnect();
      });
    } catch (e, s) {
      LoggerHelper.e("💥 WebSocket 初始化失败", error: e, stackTrace: s);
      _isConnecting = false;
      if (_autoReconnect) _scheduleReconnect();
    }
  }

  /// 启动心跳检测
  static void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (_isConnected) sendPing();
    });
  }

  static void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// 定时重连
  static void _scheduleReconnect() {
    if (_isConnecting || _isConnected) return;

    _reconnectAttempt++;
    final delaySeconds = (2 << (_reconnectAttempt - 1)).clamp(2, 60);

    LoggerHelper.w("⏳ ${delaySeconds}s 后尝试第 $_reconnectAttempt 次重连...");

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      _connectInternal();
    });
  }

  /// 发送消息（Map）
  static void sendDataMessage(Map<String, dynamic> message) {
    if (_isConnected && _wsManager != null) {
      _wsManager!.sendDataMessage(message);
      LoggerHelper.d("📤 发送消息: $message");
    } else {
      LoggerHelper.w("❗ WebSocket 未连接，无法发送消息");
    }
  }

  /// 发送字符串消息
  static void sendDataMessageString(String input) {
    sendDataMessage({"chat_content": input, "chat_type": 0});
  }

  /// 发送心跳包
  static void sendPing() {
    if (_isConnected) {
      _wsManager!.sendDataMessage({"type": "ping"});
      LoggerHelper.t("💓 Heartbeat Ping");
    }
  }

  /// 主动断开
  static Future<void> disconnect({bool manual = true}) async {
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    if (manual) _autoReconnect = false;

    try {
      _wsManager?.disconnect();
    } catch (e, s) {
      LoggerHelper.e("❌ WebSocket disconnect error", error: e, stackTrace: s);
    } finally {
      _isConnected = false;
      _isConnecting = false;
      LoggerHelper.i("🧹 WebSocket 已关闭");
    }
  }

  /// 检查连接状态
  static bool get isConnected => _isConnected;

  /// 销毁
  static void dispose() {
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _wsManager = null;
    _isConnected = false;
    _isConnecting = false;
    LoggerHelper.i("🧽 WebSocketService 已销毁");
  }
}
