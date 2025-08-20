import 'package:flutter_websocket_manager/flutter_websocket_manager.dart';
import 'logger_helper.dart';

class WebSocketService {
  // 私有构造，禁止实例化
  WebSocketService._();

  // WebSocket 管理器实例（全局共享）
  static FlutterWebSocketManager? _wsManager;

  // 获取 wsManager（带空值检查）
  static FlutterWebSocketManager get wsManager {
    return _wsManager!;
  }

  static var isSocketConnected = false;

  // 初始化方法
  static Future<void> init(String url) async {
    _wsManager = FlutterWebSocketManager(
      url,
      headers: {
        "Connection": "Upgrade",
        "Upgrade": "Websocket",
      },
    );

    _wsManager!.connect();

    _wsManager!.onConnect((msg) {
      isSocketConnected=true;
      LoggerHelper.d("✅ WebSocket connected");
    });

    _wsManager!.onDone((msg) {
      LoggerHelper.d("❌ WebSocket closed: $msg");
      _wsManager!.connect();
    });

    _wsManager!.onError((error) {
      LoggerHelper.d("⚠️ WebSocket error: $error");
    });
  }

  // 发送 JSON 消息
  static void sendDataMessage(Map<String, dynamic> message) {
    if (_wsManager != null) {
      _wsManager!.sendDataMessage(message);
    } else {
      LoggerHelper.d("❗ WebSocket 未连接，无法发送消息");
    }
  }

  // 快捷发送字符串内容
  static void sendDataMessageString(String input) {
    sendDataMessage({"chat_content": input, "chat_type": 0});
  }

  // 关闭连接
  static void disconnect() {
    _wsManager?.disconnect();
    isSocketConnected=false;
    LoggerHelper.d("🧹 WebSocket disconnected");
  }

  // 可选：检查连接状态
  static bool get isConnected => isSocketConnected;
}
