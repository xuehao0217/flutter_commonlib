import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() {
  // Obx 扩展
  RxInt count = 0.obs;
  count.obxWidget((v) => Text("Count: $v"));
  count.obxIfNotNull((v) => Text("Not null: $v"));

  // RxList 扩展
  RxList<String> items = <String>[].obs;
  items.obxIfNotEmpty(
    (list) => ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) => Text(list[i]),
    ),
  );

  // GetBuilderWidget
  // GetBuilderWidget<MyController>(
  //   controller: MyController(),
  //   builder: (ctrl) => Text("Value: ${ctrl.value}"),
  // );

  // 路由跳转
  GetXRoute.to("/home");
  GetXRoute.off("/login");
  GetXRoute.offAll("/main");
}

/// ==========================
/// Rx 扩展
/// ==========================
extension RxWidgetExtension<T> on Rx<T> {
  /// 通用 Obx 构建器
  Widget obxWidget(Widget Function(T value) builder) =>
      Obx(() => builder(value));

  /// 如果值不为 null，则构建 builder，否则显示 emptyWidget
  Widget obxIfNotNull(
    Widget Function(T value) builder, {
    Widget emptyWidget = const SizedBox.shrink(),
  }) {
    return Obx(() {
      final v = value;
      return v != null ? builder(v) : emptyWidget;
    });
  }
}

extension RxListWidgetExtension<T> on RxList<T> {
  /// Obx 构建器
  Widget obxWidget(Widget Function(List<T> list) builder) =>
      Obx(() => builder(this));

  /// 非空时构建 builder，否则显示 emptyWidget
  Widget obxIfNotEmpty(
    Widget Function(List<T> list) builder, {
    Widget emptyWidget = const SizedBox.shrink(),
  }) {
    return Obx(() => isNotEmpty ? builder(this) : emptyWidget);
  }
}

/// ==========================
/// GetBuilder 封装
/// ==========================
class GetBuilderWidget<T extends GetxController> extends StatelessWidget {
  final T? controller;
  final Widget Function(T controller) builder;

  const GetBuilderWidget({Key? key, this.controller, required this.builder})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(init: controller, builder: (ctrl) => builder(ctrl));
  }
}

/// ==========================
/// GetX 路由封装
/// ==========================
class GetXRoute {
  /// 普通跳转
  static void to(
    String route, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    Get.toNamed(route, arguments: arguments, parameters: parameters);
  }

  /// 替换当前页面
  static void off(
    String route, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    Get.offNamed(route, arguments: arguments, parameters: parameters);
  }

  /// 清空所有路由并跳转
  static void offAll(
    String route, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    Get.offAllNamed(route, arguments: arguments, parameters: parameters);
  }
}
