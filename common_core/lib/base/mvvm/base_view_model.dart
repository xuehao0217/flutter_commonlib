import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../net/dio_utils.dart';
import '../../net/net.dart';
import 'base_view_abs.dart';

abstract class BaseViewModel<V extends AbsBaseView> extends GetxController {
  late V view;
  late CancelToken cancelToken;

  BaseViewModel() {
    cancelToken = CancelToken();
  }

  @override
  void onClose() {
    super.onClose();
    dispose();
  }

  void showToast(string) => view.showToast(string);

  void dispose() {
    /// 销毁时，将请求取消
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  void asyncRequestNetwork<T>(
    Method method,
    String url, {
    bool showLoading = true,
    Function(T data)? onSuccess,
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
    HttpUtils.asyncRequestNetwork(
      method,
      url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? cancelToken,
      onSuccess: onSuccess,
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
      onFinally: () {
        view.hideLoading();
        onFinally?.call();
      },
    );
  }

  void _onError(int code, String msg, NetErrorCallback? onError) {
    /// 异常时直接关闭加载圈，不受isClose影响
    view.hideLoading();
    if(code!=NetExceptionHandle.net_cancel){
      view.showToast(msg);
    }

    /// 页面如果dispose，则不回调onError
    if (onError != null) {
      onError(code, msg);
    }
  }
}
