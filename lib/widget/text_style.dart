import 'dart:ui';

import 'package:flutter/material.dart';

const FontWeightMedium = FontWeight.w500;
const FontWeightDEF = FontWeight.w400;
const FontWeightSemibold = FontWeight.w600;


class XText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  XText(this.text,{
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
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
