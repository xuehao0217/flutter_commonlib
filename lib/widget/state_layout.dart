import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_commonlib/widget/text_style.dart';
import 'package:get/get.dart';

// https://juejin.cn/post/7293410163751125033

///四种视图状态
enum LoadState { State_Success, State_Error, State_Loading, State_Empty }

///根据不同状态来展示不同的视图
class LoadStateLayout extends StatefulWidget {
  final LoadState state; //页面状态
  final Widget? successWidget; //成功视图
  final VoidCallback? errorRetry; //错误事件处理
  String? errorMessage;

  LoadStateLayout(
      {Key? key,
      this.state = LoadState.State_Loading, //默认为加载状态
      this.successWidget,
      this.errorMessage,
      this.errorRetry})
      : super(key: key);

  @override
  _LoadStateLayoutState createState() => _LoadStateLayoutState();
}

class _LoadStateLayoutState extends State<LoadStateLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildWidget,
    ).intoExpanded();
  }

  ///根据不同状态来显示不同的视图
  Widget get _buildWidget {
    switch (widget.state) {
      case LoadState.State_Success:
        return widget.successWidget ?? const SizedBox();
      case LoadState.State_Error:
        return _errorView;
      case LoadState.State_Loading:
        return _loadingView;
      case LoadState.State_Empty:
        return _emptyView;
      default:
        return _loadingView;
    }
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget get _errorView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "",
            style: TextStyle(color: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              // 在按钮点击时进行重试操作
              widget?.errorRetry?.call();
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget get _emptyView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 80),
      child: Text("Empty State"),
    );
  }
}
