import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

extension ClickExt on Widget {
  Widget click(VoidCallback click) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: click,
      child: this,
    );
  }

  //带水波纹的
  Widget clickInkWell(VoidCallback click) {
    return InkWell(
      onTap: click,
      child: this,
    );
  }

  Container intoContainer({
    final Key? key,
     final AlignmentGeometry? alignment=Alignment.center,
    final EdgeInsetsGeometry? padding,
    final Color? color,
    final Decoration? decoration,
    final Decoration? foregroundDecoration,
    final double? width,
    final double? height,
    final BoxConstraints? constraints,
    final EdgeInsetsGeometry? margin,
    final Matrix4? transform,
  }) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      margin: margin,
      transform: transform,
      child: this,
    );
  }


  Widget intoPadding(EdgeInsetsGeometry padding) {
    return Padding(
        padding: padding,
         child: this,
    );
  }

 Widget intoHorizontalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  Widget intoVerticalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  
  Widget intoCenter() {
    return Center(
      child: this,
    );
  }


  Widget intoExpanded() {
    return Expanded(
      child: this,
    );
  }

  Widget intoClipRRect(double circular) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circular),
      child: this,
    );
  }
}


///https://juejin.cn/post/7498494017983676443
extension ObxWidgetExtension<T> on Rx<T> {
  Widget obsWidget(Widget Function(T value) builder) {
    return Obx(() => builder(this.value));
  }
}


