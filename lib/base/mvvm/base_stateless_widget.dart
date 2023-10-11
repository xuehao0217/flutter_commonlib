import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:rxdart/rxdart.dart';

import '../base_page_stateless_widget.dart';
import 'base_stateful_widget.dart';
import 'base_view_abs.dart';
import 'base_view_model.dart';

abstract class BaseStatelessWidget<VM extends BaseViewModel> extends BasePageStatelessWidget implements AbsBaseView {
  late VM viewModel;

  VM createViewModel();

  @override
  void showLoading() {
    SmartDialog.showLoading();
  }

  @override
  void hideLoading() {
    SmartDialog.dismiss();
  }

  @override
  void showToast(String string) {
    SmartDialog.showToast(string);
  }

  @override
  Widget build(BuildContext context) {
    // 构建完成后触发的操作
    viewModel = createViewModel();
    viewModel.view = this;
    Get.put(viewModel);
    Future.delayed(const Duration(milliseconds: 100), () {
      initData();
    });
    return super.build(context);
  }
}
