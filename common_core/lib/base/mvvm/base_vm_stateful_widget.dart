
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../base_stateful_widget.dart';
import 'base_view_abs.dart';
import 'base_view_model.dart';


abstract class BaseVMStatefulWidget<W extends StatefulWidget,VM extends BaseViewModel> extends BaseStatefulWidget<W> implements AbsBaseView {
  VM createViewModel();

  late VM viewModel;

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
    viewModel= Get.put(createViewModel());
    viewModel.view = this;
    initData();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}