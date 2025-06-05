import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'dio_utils.dart';
import 'error_handle.dart';
import 'net.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var p =await  PackageInfo.fromPlatform();
    options.headers["version"] ="${p.version}";
    options.headers["deviceId"] = "deviceId";
    options.headers["os"] = "os";
    options.headers["osVersion"] = "os";
    super.onRequest(options, handler);
  }
}


class LoggingInterceptor extends Interceptor {
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    HttpLog.d('----------Start----------');
    if (options.queryParameters.isEmpty) {
      HttpLog.d('RequestUrl: ${options.baseUrl}${options.path}');
    } else {
      HttpLog.d('RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}');
    }
    HttpLog.d('RequestMethod: ${options.method}');
    HttpLog.d('RequestHeaders:${options.headers}');
    HttpLog.d('RequestContentType: ${options.contentType}');
    HttpLog.d('RequestData: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      HttpLog.d('ResponseCode: ${response.statusCode}');
    } else {
      HttpLog.e('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    HttpLog.json(response.data.toString());
    HttpLog.d('----------End: $duration 毫秒----------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    HttpLog.d('----------Error-----------');
    super.onError(err, handler);
  }
}




// 解码给Chucker看
class DecodeForChuckerInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.extra['_chucker_rawdata'] = response.data;
    if (response.data is String) {
      try {
        response.data = jsonDecode(response.data);
      } catch (e) {}
    }
    handler.next(response);
  }
}

// 还原原始data给业务
class RestoreRawDataInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.extra.containsKey('_chucker_rawdata')) {
      response.data = response.extra['_chucker_rawdata'];
    }
    handler.next(response);
  }
}
