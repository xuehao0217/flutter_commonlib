import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../base_stateless_widget.dart';
import 'base_view_abs.dart';
import 'base_view_model.dart';

/// 无状态外观 + ViewModel：实际在 [_BaseVMStatelessHost] 的 [State.initState]/[dispose] 中注册与释放 GetX。
abstract class BaseVMStatelessWidget<VM extends BaseViewModel>
    extends BaseStatelessWidget implements AbsBaseView {
  late VM viewModel;

  /// 与 [BaseVMStatefulWidget.viewModelTag] 相同语义。
  String? get viewModelTag => null;

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

  /// 供 [_BaseVMStatelessHost] 调用，等价于原 [BaseStatelessWidget.build] 链。
  Widget buildInner(BuildContext context) => super.build(context);

  @override
  Widget build(BuildContext context) {
    return _BaseVMStatelessHost<VM>(owner: this);
  }
}

class _BaseVMStatelessHost<VM extends BaseViewModel> extends StatefulWidget {
  const _BaseVMStatelessHost({required this.owner});

  final BaseVMStatelessWidget<VM> owner;

  @override
  State<_BaseVMStatelessHost<VM>> createState() => _BaseVMStatelessHostState<VM>();
}

class _BaseVMStatelessHostState<VM extends BaseViewModel>
    extends State<_BaseVMStatelessHost<VM>> {
  @override
  void initState() {
    super.initState();
    final o = widget.owner;
    o.viewModel = Get.put(o.createViewModel(), tag: o.viewModelTag);
    o.viewModel.attachView(o);
    WidgetsBinding.instance.addPostFrameCallback((_) => o.initData());
  }

  @override
  void dispose() {
    final o = widget.owner;
    final tag = o.viewModelTag;
    if (Get.isRegistered<VM>(tag: tag)) {
      Get.delete<VM>(tag: tag);
    } else {
      o.viewModel.onDispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.owner.buildInner(context);
}
