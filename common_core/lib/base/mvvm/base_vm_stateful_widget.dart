import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../base_stateful_widget.dart';
import 'base_view_abs.dart';
import 'base_view_model.dart';

/// MVVM 页面（Stateful）：在 [initState] 内 [Get.put] 创建 [VM]，[dispose] 时 [Get.delete]（可带 [viewModelTag]）。
///
/// 加载与 Toast 走 [SmartDialog]；子类需实现 [createViewModel] 与 [initData]。
abstract class BaseVMStatefulWidget<W extends StatefulWidget, VM extends BaseViewModel>
    extends BaseStatefulWidget<W> implements AbsBaseView {
  /// 由页面创建对应 [VM]，勿在 [build] 中重复创建。
  VM createViewModel();

  /// 同类型 [VM] 多页并存时覆写为不同 tag，与 [Get.put]/[Get.delete] 一致。
  String? get viewModelTag => null;

  late VM viewModel;

  @override
  void initData();

  @override
  void showLoading() {
    SmartDialog.showLoading();
  }

  @override
  void hideLoading() {
    SmartDialog.dismiss(status: SmartStatus.loading);
  }

  @override
  void showToast(String string) {
    SmartDialog.showToast(string);
  }

  @override
  void initState() {
    super.initState();
    viewModel = Get.put(createViewModel(), tag: viewModelTag);
    viewModel.attachView(this);
    initData();
  }

  @override
  void dispose() {
    // 由 GetX 触发 GetxController.onClose → BaseViewModel.onDispose，勿再手动 viewModel.onDispose()
    if (Get.isRegistered<VM>(tag: viewModelTag)) {
      Get.delete<VM>(tag: viewModelTag);
    } else {
      viewModel.onDispose();
    }
    super.dispose();
  }
}
