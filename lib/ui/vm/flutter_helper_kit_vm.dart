import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';

class FlutterHelperKitVM extends BaseViewModel with StateMixin<String> {
  void getData() async {
    change(null, status: RxStatus.loading()); // 显示加载中
    try {
      await Future.delayed(const Duration(seconds: 2));
      change("Hello, Flutter Helper Kit!", status: RxStatus.success()); // 请求成功
    } catch (e) {
      change(null, status: RxStatus.error(e.toString())); // 出错
    }
  }

  @override
  void onReady() {
    super.onReady();
    getData();
  }
}
