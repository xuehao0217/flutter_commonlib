import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

extension ObxWidgetExtension<T> on Rx<T> {
  /// 通用的 Obx 构建器
  Widget obsWidget(Widget Function(T value) builder) {
    return Obx(() => builder(this.value));
  }

  /// 如果值不为 null，则构建 builder，否则返回 emptyWidget
  Widget obsWidgetIfNotNull(
      Widget Function(T value) builder, {
        Widget emptyWidget = const SizedBox.shrink(),
      }) {
    return Obx(() {
      final value = this.value;
      if (value == null) {
        return emptyWidget;
      }
      return builder(value);
    });
  }
}

extension ObxWidgetRxListExtension<T> on RxList<T> {
  /// 简单的 Obx 包裹构建器
  Widget obsWidget(Widget Function(List<T> list) builder) {
    return Obx(() => builder(this));
  }

  /// 非空时显示 builder，否则显示 emptyWidget（默认空容器）
  Widget obsWidgetIfNotEmpty(Widget Function(List<T> list) builder, {
        Widget emptyWidget = const SizedBox.shrink(),
      }) {
    return Obx(() {
      return this.isNotEmpty ? builder(this) : emptyWidget;
    });
  }
}



class GetBuilderWidget<T extends GetxController> extends StatelessWidget {
  final T controller;
  final Widget Function(T) builder;

  const GetBuilderWidget({
    Key? key,
    required this.controller,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: controller,
      builder: (value) => builder(value),
    );
  }
}






////////////////////////////////Route//////////////////////////////////////////////////

void Get2Named(
    String route, {
      dynamic arguments,
      Map<String, String>? parameters,
    }) {
  Get.toNamed(route, arguments: arguments, parameters: parameters);
}

//替换当前页面（即关闭当前页面并打开新页面）。
void GetOffNamed(
    String route, {dynamic arguments = "",
      Map<String, String>? parameters,
    }) {
  Get.offNamed(route, arguments: arguments, parameters: parameters);
}
