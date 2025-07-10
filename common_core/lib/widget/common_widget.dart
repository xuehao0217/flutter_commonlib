import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

class CommonTitleBar extends StatelessWidget {
  final String backIcon;
  final String title;
  final VoidCallback? backCallBack;
  final TextStyle? titleTextStyle;
  final Widget? rightWidget;
  final Color backgroundColor;
  final double height;
  final bool showBack, showLine;

  const CommonTitleBar({
    this.backIcon = "",
    this.title = "",
    this.backCallBack,
    this.titleTextStyle,
    this.rightWidget,
    this.backgroundColor = Colors.white,
    this.showBack = true,
    this.height = 44,
    this.showLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConstraintLayout(
      width: matchParent,
      height: height,
      children: [
        Container(
          color: backgroundColor,
        ).applyConstraint(width: matchParent, height: matchParent),
        GestureDetector(
          onTap: backCallBack,
          child: Image.asset(backIcon, width: 24, height: 24),
        ).applyConstraint(
          size: 24,
          centerLeftTo: parent,
          margin: const EdgeInsets.only(left: 15),
          visibility: showBack ? visible : gone,
        ),
        Text(
          title,
          style: titleTextStyle ?? _defaultTitleTextStyle,
        ).applyConstraint(centerTo: parent),
        Container(child: rightWidget).applyConstraint(
          centerRightTo: parent,
          margin: const EdgeInsets.only(right: 15),
        ),
        if (showLine)
          Divider(
            height: 0.5,
          ).applyConstraint(bottomCenterTo: parent, height: 0.5),
      ],
    );
  }

  TextStyle get _defaultTitleTextStyle {
    return const TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none,
    );
  }
}

class CommonButton extends StatelessWidget {
  //取消水波纹的效果这个设置成透明
  // highlightColor: Colors.transparent,
  // splashColor: Colors.transparent,

  final Widget child;
  final double circular, width, height, highlightElevation, elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final BorderSide side;
  final AlignmentGeometry? alignment;
  final Color? splashColor, highlightColor;
  final VoidCallback onPressed;
  final ShapeBorder? shape;

  const CommonButton({
    super.key,
    required this.child,
    this.circular = 0,
    required this.width,
    required this.height,
    this.padding,
    this.margin,
    this.side = const BorderSide(color: Colors.transparent, width: 2),
    this.alignment = Alignment.center,
    this.backgroundColor = Colors.white,
    this.splashColor, //水波纹颜色
    this.highlightColor, //按下去的颜色
    this.highlightElevation = 0, //按下去的阴影
    this.elevation = 0,
    required this.onPressed,
    this.shape,
  });

  @override
  Widget build(BuildContext context) => RawMaterialButton(
    onPressed: onPressed,
    fillColor: backgroundColor,
    //hoverElevation:hoverElevation,//悬停阴影
    // focusColor: Colors.indigo,//有焦点的颜色
    // hoverColor: Colors.yellow,//悬停颜色
    //\按下去的颜色
    highlightColor: highlightColor,
    //水波纹颜色
    splashColor: splashColor,
    //高亮阴影
    highlightElevation: highlightElevation,
    // focusElevation: focusElevation,
    //阴影
    elevation: elevation,
    shape:
        shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circular),
          side: side,
        ),
    child: Container(
      alignment: alignment,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      child: child,
    ),
  );
}

// CachedNetworkImage(
// imageUrl: "http://via.placeholder.com/350x150",
// placeholder: (context, url) => CircularProgressIndicator(),
// errorWidget: (context, url, error) => Icon(Icons.error),
// ),
