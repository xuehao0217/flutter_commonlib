import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'net.dart';

/// 请求头拦截：包信息 / 设备信息在进程内缓存，仅网络类型每次刷新。
class HeaderInterceptor extends Interceptor {
  static PackageInfo? _cachedPackageInfo;
  static Map<String, String>? _cachedDeviceHeaders;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _cachedPackageInfo ??= await PackageInfo.fromPlatform();
    final packageInfo = _cachedPackageInfo!;

    if (_cachedDeviceHeaders == null) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        _cachedDeviceHeaders = {
          "appName": packageInfo.appName,
          "version": packageInfo.version,
          "buildNumber": packageInfo.buildNumber,
          "packageName": packageInfo.packageName,
          "deviceId": iosInfo.identifierForVendor ?? '',
          "model": iosInfo.utsname.machine,
          "modelName": iosInfo.model,
          "os": "iOS",
          "osVersion": iosInfo.systemVersion,
          "brand": "Apple",
          "platform": "flutter",
        };
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        _cachedDeviceHeaders = {
          "appName": packageInfo.appName,
          "version": packageInfo.version,
          "buildNumber": packageInfo.buildNumber,
          "packageName": packageInfo.packageName,
          "deviceId": androidInfo.id,
          "model": androidInfo.model,
          "brand": androidInfo.brand,
          "os": "Android",
          "osVersion": androidInfo.version.release,
          "platform": "flutter",
        };
      }
    }

    final connectivity = await Connectivity().checkConnectivity();
    final networkType = switch (connectivity.first) {
      ConnectivityResult.wifi => 'WiFi',
      ConnectivityResult.mobile => 'Mobile',
      ConnectivityResult.none => 'None',
      ConnectivityResult.vpn => 'Vpn',
      _ => 'Unknown',
    };

    if (_cachedDeviceHeaders != null) {
      options.headers.addAll({
        ..._cachedDeviceHeaders!,
        "networkType": networkType,
      });
    }
    super.onRequest(options, handler);
  }
}

/// 调试：打印请求/响应耗时与 body（默认未加入 [HttpUtils] 拦截器链）。
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
      HttpLog.d(
        'RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}',
      );
    }
    HttpLog.d('RequestMethod: ${options.method}');
    HttpLog.d('RequestHeaders:${options.headers}');
    HttpLog.d('RequestContentType: ${options.contentType}');
    HttpLog.d('RequestData: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == 200) {
      HttpLog.d('ResponseCode: ${response.statusCode}');
    } else {
      HttpLog.e('ResponseCode: ${response.statusCode}');
    }
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

/// 将字符串响应解码为 JSON，供 Chucker 展示；与 [RestoreRawDataInterceptor] 成对使用。
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

/// 将 [DecodeForChuckerInterceptor] 保存的原始字符串写回 [Response.data]，避免业务侧拿到 Map 而丢失文本。
class RestoreRawDataInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.extra.containsKey('_chucker_rawdata')) {
      response.data = response.extra['_chucker_rawdata'];
    }
    handler.next(response);
  }
}
