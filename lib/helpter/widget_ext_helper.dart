import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

extension ClickExt on Widget {
  Widget click(VoidCallback click) {
    return GestureDetector(
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
    final AlignmentGeometry? alignment,
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
