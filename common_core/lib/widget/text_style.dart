import 'dart:ui';

import 'package:flutter/material.dart';

const FontWeightMedium = FontWeight.w500;
const FontWeightDEF = FontWeight.w400;
const FontWeightSemibold = FontWeight.w600;


class XText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextStyle? style;
  XText(this.text,{
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.ellipsis,
    this.style, this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style??TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
          decoration: TextDecoration.none,
          fontFamily: 'DINPRO'),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
