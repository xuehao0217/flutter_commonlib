import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'base_entity.dart';
import 'error_handle.dart';
import 'intercept.dart';
import 'net.dart';

/// 默认dio配置
String _baseUrl = '';
List<Interceptor> _interceptors = [
  HeaderInterceptor(),
  // LoggingInterceptor(),

  DecodeForChuckerInterceptor(),
  ChuckerDioInterceptor(),
  TalkerDioLogger(
    settings: const TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseHeaders: true,
      printResponseMessage: true,
    ),
  ),
  RestoreRawDataInterceptor(),
];

typedef NetSuccessListCallback<T> = Function(List<T> data);
typedef NetSuccessCallback<T> = Function(T data);
typedef NetErrorCallback = Function(int code, String msg);

class HttpUtils {
  static late Dio _dio;

  static Dio get dio => _dio;

  static void init(
    String? baseUrl, [
    List<Interceptor> interceptors = const [],
  ]) {
    _baseUrl = baseUrl ?? _baseUrl;

    _dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 15),
        receiveTimeout: Duration(seconds: 15),
        sendTimeout: Duration(seconds: 15),
        responseType: ResponseType.plain,
        validateStatus: (_) {
          return true;
        },
        baseUrl: _baseUrl,
      ),
    );

    _interceptors.addAll(interceptors);

    _interceptors.forEach((interceptor) {
      _dio.interceptors.add(interceptor);
    });
  }

  static Future<BaseEntity> _request(
    String method,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
    try {
      final String data = response.data.toString();
      final Map<String, dynamic> map = parseData(data);
      return BaseEntity.fromJson(map);
    } catch (e) {
      debugPrint(e.toString());
      return BaseEntity(
        code: ExceptionHandle.parse_error,
        msg: '数据解析错误！',
        data: null,
      );
    }
  }

  static Options _checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  static Future<dynamic> requestNetwork(
    Method method,
    String url, {
    Function(dynamic data)? onSuccess, // 修改回调类型
    NetErrorCallback? onError,
    VoidCallback? onFinally,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _request(
          method.value,
          url,
          data: params,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        )
        .then<void>(
          (BaseEntity result) {
            if (result.isSuccess()) {
              onSuccess?.call(result.data);
            } else {
              _onError(result.code, result.msg, onError);
            }
          },
          onError: (dynamic e) {
            _cancelLogPrint(e, url);
            _onError(e.code, e.msg, onError);
          },
        )
        .whenComplete(() => onFinally?.call());
  }

  static void asyncRequestNetwork(
    Method method,
    String url, {
    Function(dynamic data)? onSuccess,
    NetErrorCallback? onError,
    VoidCallback? onFinally,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    Stream.fromFuture(
      _request(
        method.value,
        url,
        data: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    ).asBroadcastStream().listen(
      (result) {
        if (result.isSuccess()) {
          onSuccess?.call(result.data);
        } else {
          _onError(result.code, result.msg, onError);
        }
      },
      onError: (dynamic e) {
        _cancelLogPrint(e, url);
        _onError(e.code, e.msg, onError);
      },
      onDone: onFinally,
    );
  }

  static void _cancelLogPrint(dynamic e, String url) {
    if (e is DioException && CancelToken.isCancel(e)) {
      HttpLog.e('取消请求接口： $url');
    }
  }

  static void _onError(int code, String msg, NetErrorCallback? onError) {
    HttpLog.e('接口请求异常： code: $code, mag: $msg');
    onError?.call(code, msg);
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

enum Method { get, post, put, patch, delete, head }

/// 使用拓展枚举替代 switch判断取值
extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}
