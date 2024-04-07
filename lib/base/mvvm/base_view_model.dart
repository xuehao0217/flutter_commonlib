import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../net/dio_utils.dart';
import '../../net/error_handle.dart';
import 'base_view_abs.dart';

abstract class BaseViewModel<V extends AbsBaseView> extends GetxController {
  late V view;

  BaseViewModel() {
    _cancelToken = CancelToken();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    dispose();
  }

  late CancelToken _cancelToken;

  void dispose() {
    /// 销毁时，将请求取消
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }

  /// 返回Future 适用于刷新，加载更多
  Future<dynamic> requestNetwork<T>(
    Method method, {
    required String url,
    bool showLoading = false,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    VoidCallback? onFinally,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    if (showLoading) {
      view.showLoading();
    }
    return HttpUtils.instance.requestNetwork<T>(method, url,
        params: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken, onSuccess: (data) {
      if (showLoading) {
        view.hideLoading();
      }
      onSuccess?.call(data);
    }, onError: (code, msg) {
      _onError(code, msg, onError);
    }, onFinally: onFinally);
  }

  void asyncRequestNetwork<T>(
    Method method, {
    required String url,
    bool showLoading = false,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    VoidCallback? onFinally,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    if (showLoading) {
      view.showLoading();
    }
    HttpUtils.instance.asyncRequestNetwork<T>(
      method,
      url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
      onSuccess: (data) {
        if (showLoading) {
          view.hideLoading();
        }
        onSuccess?.call(data);
      },
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
      onFinally: onFinally,
    );
  }

  void _onError(int code, String msg, NetErrorCallback? onError) {
    /// 异常时直接关闭加载圈，不受isClose影响
    view.hideLoading();
    if (code != ExceptionHandle.cancel_error) {
      view.showToast(msg);
    }

    /// 页面如果dispose，则不回调onError
    if (onError != null) {
      onError(code, msg);
    }
  }
}
