import 'dart:convert';
import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import '../helpter/talker_helper.dart';
import 'base_entity.dart';
import 'intercept.dart';
import 'net.dart';

typedef JsonConvertAsT = T? Function<T>(dynamic data);

typedef NetErrorCallback = Function(int code, String msg);

/// ============================
/// 拦截器列表（仅初始化一次）
/// ============================
List<Interceptor> _interceptors = [
  HeaderInterceptor(),
  // LoggingInterceptor(),
  DecodeForChuckerInterceptor(),
  ChuckerDioInterceptor(),
  TalkerDioLogger(
    talker: talker,
    settings: TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseHeaders: true,
      printResponseMessage: true,
      requestPen: AnsiPen()..blue(),
      // Green http responses logs in console
      responsePen: AnsiPen()..green(),
      // Error http logs in console
      errorPen: AnsiPen()..red(),
    ),
  ),
  RestoreRawDataInterceptor(),
];
/// ============================
/// HttpUtils 核心类
/// ============================
class HttpUtils {
  static late Dio _dio;

  static Dio get dio => _dio;

  static late JsonConvertAsT _jsonConvertAsT;

  static void init(
    String baseUrl,
    JsonConvertAsT jsonConvertAsT, {
    List<Interceptor> interceptors = const [],
    Map<String, dynamic>? headers,
  }) {
    _jsonConvertAsT = jsonConvertAsT;

    _dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 15),
        receiveTimeout: Duration(seconds: 15),
        sendTimeout: Duration(seconds: 15),
        responseType: ResponseType.plain,
        validateStatus: (_) {
          return true;
        },
        baseUrl: baseUrl,
        headers: headers,
      ),
    );

    if (interceptors.isNotEmpty) {
      _interceptors.addAll(interceptors);
    }
    _interceptors.forEach((interceptor) {
      _dio.interceptors.add(interceptor);
    });
  }
  /// 内部请求
  static Future<BaseEntity> _request(
    String method,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
    try {
      final String data = response.data.toString();
      final Map<String, dynamic> map = parseData(data);
      return BaseEntity.fromJson(map);
    } catch (e) {
      debugPrint(e.toString());
      return BaseEntity(
        errorCode: NetExceptionHandle.net_parse_error,
        errorMsg: '数据解析错误！',
        data: null,
      );
    }
  }

  static Options _checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  /// ============================
  /// 统一请求方法
  /// ============================
  static Future<T> requestNetwork<T>(
    Method method,
    String url, {
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      final BaseEntity result = await _request(
        method.value,
        url,
        data: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      if (result.isSuccess()) {
        var resultData = _jsonConvertAsT<T>(result.data);
        if (resultData != null) {
          return resultData;
        } else {
          return Future.error(result);
        }
      } else {
        _onError(result.errorCode, result.errorMsg, null);
        return Future.error(result);
      }
    } catch (e, stack) {
      HttpLog.e("请求异常：$e\n$stack");
      return Future.error(e);
    }
  }

  static void asyncRequestNetwork<T>(
    Method method,
    String url, {
    Function(T data)? onSuccess,
    NetErrorCallback? onError,
    VoidCallback? onFinally,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    _request(
          method.value,
          url,
          data: params,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        )
        .then((result) {
          if (result.isSuccess()) {
            final resultData = _jsonConvertAsT<T>(result.data);
            if (resultData != null) {
              onSuccess?.call(resultData);
            } else {
              _onError(result.errorCode, result.errorMsg, onError);
            }
          } else {
            _onError(result.errorCode, result.errorMsg, onError);
          }
        })
        .catchError((error) {
          if (CancelToken.isCancel(error)) {
            _onError(NetExceptionHandle.net_cancel, '请求已取消', onError);
          } else {
            _onError(NetExceptionHandle.net_error, error.toString(), onError);
          }
        })
        .whenComplete(() => onFinally?.call());
  }

  /// 上传文件
  /// [url] 接口地址
  /// [file] 本地文件
  /// [field] 文件表单字段名，默认 "file"
  /// [extraData] 额外表单参数
  /// [onSendProgress] 上传进度回调
  /// [cancelToken] 取消 token
  /// [options] dio options
  /// 上传文件并返回泛型 T
  static Future<T> postFile<T>({
    required String url,
    required File file,
    String field = "file",
    Map<String, dynamic>? extraData,
    ProgressCallback? onSendProgress,
    NetErrorCallback? onError,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    FormData formData = FormData.fromMap({
      field: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      if (extraData != null) ...extraData,
    });
    options ??= Options(method: 'POST', contentType: 'multipart/form-data');

    final BaseEntity result = await _request(
      'POST',
      url,
      data: formData,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
    );
    if (result.isSuccess()) {
      var resultData = _jsonConvertAsT<T>(result.data);
      if (resultData != null) {
        return resultData;
      } else {
        return Future.error(result);
      }
    } else {
      _onError(result.errorCode, result.errorMsg, onError);
      return Future.error(result);
    }
  }
  /// ============================
  /// 错误处理
  /// ============================
  static void _onError(int code, String msg, NetErrorCallback? onError) {
    HttpLog.e('接口请求异常： code: $code, msg: $msg');
    onError?.call(code, msg);
  }
  /// ============================
  /// 动态 Header 管理
  /// ============================
  static void setHeaders(Map<String, dynamic> map) {
    map.forEach((k, v) => setHeader(k, v));
  }

  static void setHeader(String key, String v) {
    HttpUtils.dio.options.headers[key] = v;
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
