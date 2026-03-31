import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../net/dio_utils.dart';
import '../../net/net.dart';
import 'base_view_abs.dart';

/// 页面级 [GetxController]：持有 [AbsBaseView] 引用，统一 [CancelToken] 与 [asyncRequestNetwork] 错误 Toast。
abstract class BaseViewModel<V extends AbsBaseView> extends GetxController {
  V? view;

  final CancelToken cancelToken = CancelToken();

  /// 由页面在初始化时注入，供 [showToast] / [showLoading] 等回调视图。
  void attachView(V view) => this.view = view;

  @override
  void onClose() {
    super.onClose();
    onDispose();
  }

  void showToast(String msg) => view?.showToast(msg);

  void onDispose() {
    if (!cancelToken.isCancelled) cancelToken.cancel();
    view = null;
  }

  /// 基于 [HttpUtils.asyncRequestNetwork]；业务错误码会走 [_onError] 并默认 Toast（取消请求除外）。
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
    if (code != NetExceptionHandle.net_cancel) {
      view?.showToast(msg);
    }
    onError?.call(code, msg);
  }
}
