import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_helper_kit/widgets/sharp_corners/sharp_border_radius.dart';
import 'package:flutter_helper_kit/widgets/sharp_corners/sharp_rectangle_border.dart';
import 'package:get/get.dart';

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
    return InkWell(onTap: click, child: this);
  }

  Container intoContainer({
    final Key? key,
    final AlignmentGeometry? alignment = Alignment.center,
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

  Widget intoPadding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  Widget intoAlign([AlignmentGeometry alignment = Alignment.centerLeft]) {
    return Align(alignment: alignment, child: this);
  }

  Widget intoCenter() {
    return Center(child: this);
  }

  //top =false 就代表忽略top
  Widget intoSafeArea({bool bottom = true, bool top = true}) {
    return SafeArea(bottom: bottom, top: top, child: this);
  }

  Widget intoExpanded({int flex = 1}) {
    return Expanded(child: this, flex: flex);
  }

  Widget intoFlexible() {
    return Flexible(child: this);
  }

  Widget intoClipRRect(double circular) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circular),
      child: this,
    );
  }

  // itemBuilder: (index, item) => FeedListItem(data: item).withContext((context) {
  // // 这里的 context 就是当前 item 的 context
  // // 你可以做曝光统计、弹窗、Theme.of(context)等
  // }),
  Widget intoBuilder(void Function(BuildContext context) onBuild) {
    return Builder(
      builder: (context) {
        onBuild(context);
        return this;
      },
    );
  }

  Widget intoSelection({ValueChanged<SelectedContent?>? onSelectionChanged}) {
    return SelectionArea(child: this, onSelectionChanged: onSelectionChanged);
  }

  Widget intoIntrinsicHeight() {
    return IntrinsicHeight(child: this);
  }

  Widget intoIntrinsicWidth() {
    return IntrinsicWidth(child: this);
  }

  Widget intoSizedBoxExpand() {
    return SizedBox.expand(child: this);
  }


  Widget intoSizedBox({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  Widget intoShapeClip({
    double borderRadius = 0,
    Color? backgroundColor,
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    double? width,
    double? height,
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: SharpRectangleBorder(
          side: BorderSide(
            color: borderColor, // 边框颜色
            width: borderWidth, // 边框宽度
          ),
          borderRadius: SharpBorderRadius(cornerRadius: borderRadius),
        ),
      ),
      child: this,
    );
  }
}


