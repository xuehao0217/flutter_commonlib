import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../net/dio_utils.dart';
import '../../net/net.dart';
import 'base_view_abs.dart';

abstract class BaseViewModel<V extends AbsBaseView> extends GetxController {
  V? view;

  final CancelToken cancelToken = CancelToken();

  void attachView(V view) => this.view = view;

  @override
  void onClose() {
    super.onClose();
    dispose();
  }

  void showToast(String msg) => view?.showToast(msg);

  void dispose() {
    if (!cancelToken.isCancelled) cancelToken.cancel();
    view = null;
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
    if (showLoading) view?.showLoading();
    HttpUtils.asyncRequestNetwork(
      method,
      url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSuccess: onSuccess,
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
      onFinally: () {
        view?.hideLoading();
        onFinally?.call();
      },
    );
  }

  void _onError(int code, String msg, NetErrorCallback? onError) {
    view?.hideLoading();
    if (code != NetExceptionHandle.net_cancel) {
      view?.showToast(msg);
    }
    onError?.call(code, msg);
  }
}
