library flutter_client_sse;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../net/base_entity.dart';

/// SSE 数据模型
class SSEModel {
  String? data;
  String? id;
  String? event;
  BaseEntity? baseEntity;
  SSEModel({this.data, this.id, this.event,this.baseEntity});
}
enum SSERequestType { GET, POST }

/// A client for subscribing to Server-Sent Events (SSE).
class SSEClient {
  static http.Client _client = http.Client();

  /// Retry the SSE connection after a delay
  static void _retryConnection({
    required SSERequestType method,
    required String url,
    required Map<String, String> header,
    required StreamController<SSEModel> streamController,
    Map<String, dynamic>? body,
  }) {
    print('---RETRY CONNECTION IN 5s---');
    Future.delayed(const Duration(seconds: 5), () {
      subscribeToSSE(
        method: method,
        url: url,
        header: header,
        body: body,
        oldStreamController: streamController,
      );
    });
  }

  /// Subscribe to SSE
  static Stream<SSEModel> subscribeToSSE({
    required SSERequestType method,
    required String url,
    required Map<String, String> header,
    StreamController<SSEModel>? oldStreamController,
    Map<String, dynamic>? body,
  }) {
    final streamController = oldStreamController ?? StreamController<SSEModel>();
    final lineRegex = RegExp(r'^([^:]*)(?::)?(?: )?(.*)?$');
    var currentSSEModel = SSEModel(data: '', id: '', event: '');

    try {
      _client = http.Client();
      final request = http.Request(
        method == SSERequestType.GET ? 'GET' : 'POST',
        Uri.parse(url),
      );

      // 添加 headers
      header.forEach((k, v) => request.headers[k] = v);
      if (method == SSERequestType.POST && body != null) {
        request.body = jsonEncode(body);
        request.headers['Content-Type'] = 'application/json';
      }

      final streamedResponse = _client.send(request);

      // 监听响应流
      streamedResponse.asStream().listen(
            (response) {
          response.stream
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .listen(
                (line) {
              if (line.isEmpty) {
                // SSE 完整事件结束，触发 stream
                streamController.add(currentSSEModel);
                currentSSEModel = SSEModel(data: '', id: '', event: '');
                return;
              }

              final match = lineRegex.firstMatch(line);
              if (match == null) return;
              final field = match.group(1);
              final value = (field == 'data') ? line.substring(5) : match.group(2) ?? '';

              switch (field) {
                case 'event':
                  currentSSEModel.event = value;
                  break;
                case 'data':
                  currentSSEModel.data = '${currentSSEModel.data ?? ''}$value\n';
                  break;
                case 'id':
                  currentSSEModel.id = value;
                  break;
                case 'retry':
                // 可处理重试时间
                  break;
                default:
                  try {
                    final jsonMap = jsonDecode(line);
                    final entity = BaseEntity.fromJson(jsonMap);
                    streamController.add(SSEModel(data: line, id: '', event: 'business_error',baseEntity:entity ));
                  } catch (_) {
                    print('未知字段: $line');
                  }
              }
            },
            onError: (e, s) {
              print('SSE解析错误: $e');
              _retryConnection(
                method: method,
                url: url,
                header: header,
                body: body,
                streamController: streamController,
              );
            },
          );
        },
        onError: (e, s) {
          print('HTTP请求错误: $e');
          _retryConnection(
            method: method,
            url: url,
            header: header,
            body: body,
            streamController: streamController,
          );
        },
      );
    } catch (e) {
      print('SSE连接异常: $e');
      _retryConnection(
        method: method,
        url: url,
        header: header,
        body: body,
        streamController: streamController,
      );
    }

    return streamController.stream;
  }


  /// 关闭 SSE 连接
  static void unsubscribeFromSSE() {
    _client.close();
  }
}
