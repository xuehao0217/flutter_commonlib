import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../base_stateless_widget.dart';
import 'base_view_abs.dart';
import 'base_view_model.dart';

abstract class BaseVMStatelessWidget<VM extends BaseViewModel> extends BaseStatelessWidget implements AbsBaseView {
  late VM viewModel;

  VM createViewModel();

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
  Widget build(BuildContext context) {
    // 构建完成后触发的操作
    viewModel =Get.put(createViewModel());
    viewModel.view = this;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    return super.build(context);
  }
}
