import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
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