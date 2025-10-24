import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart'; // 引入 BoxHeightStyle 和 BoxWidthStyle

void main() {
  // 普通输入框，无边框，带前缀图标和清除按钮
  InputWidget(
    hintText: "请输入用户名",
    prefixIcon: Icon(Icons.person, color: Colors.grey),
    textStyle: TextStyle(fontSize: 16),
    border: InputBorder.none,
    height: 44,
    // 无边框模式
    onTextChanged: (text) => print("输入内容：$text"),
  );

  // 密码输入框，带密码切换
  InputWidget(
    hintText: "请输入密码",
    isPassword: true,
    prefixIcon: const Icon(Icons.lock),
    maxLength: 20,
    onTextChanged: (text) => print("密码: $text"),
  );

  InputWidget(
    hintText: "请输入用户名",
    prefixIcon: const Icon(Icons.person),
    isPassword: false,
    maxLength: 20,
    lightColors: InputWidgetColors(
      cursorColor: Colors.blue,
      selectionColor: Colors.blue.withOpacity(0.3),
      selectionHandleColor: Colors.blue,
      textColor: Colors.black,
      hintTextColor: Colors.black45,
      borderColor: Colors.grey,
      backgroundColor: Colors.white,
    ),
    darkColors: InputWidgetColors(
      cursorColor: Colors.lightBlueAccent,
      selectionColor: Colors.lightBlueAccent.withOpacity(0.3),
      selectionHandleColor: Colors.lightBlueAccent,
      textColor: Colors.white,
      hintTextColor: Colors.white60,
      borderColor: Colors.white38,
      backgroundColor: Colors.white12,
    ),
    onTextChanged: (text) {
      print("输入内容: $text");
    },
  );

  InputWidget(
    controller: TextEditingController(),
    hintText: "请输入密码",
    isPassword: true,
    lightColors: InputWidgetColors(
      cursorColor: Colors.red,
      selectionColor: Colors.red.withOpacity(0.3),
      selectionHandleColor: Colors.red,
      textColor: Colors.black,
      hintTextColor: Colors.black38,
      borderColor: Colors.grey,
      backgroundColor: Colors.white,
    ),
    darkColors: InputWidgetColors(
      cursorColor: Colors.redAccent,
      selectionColor: Colors.redAccent.withOpacity(0.3),
      selectionHandleColor: Colors.redAccent,
      textColor: Colors.white,
      hintTextColor: Colors.white54,
      borderColor: Colors.white38,
      backgroundColor: Colors.white12,
    ),
  );
}

/// ================================
/// 输入框颜色配置
/// 支持暗黑模式和浅色模式
/// ================================
class InputWidgetColors {
  final Color? cursorColor;
  final Color? selectionColor;
  final Color? selectionHandleColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? borderColor;
  final Color? backgroundColor;

  InputWidgetColors({
    this.cursorColor,
    this.selectionColor,
    this.selectionHandleColor,
    this.textColor,
    this.hintTextColor,
    this.borderColor,
    this.backgroundColor,
  });
}

/// ================================
/// 自定义输入框
/// ================================
class InputWidget extends StatefulWidget {
  final bool isPassword; // 是否密码类型
  final String hintText; // 提示文字
  final String? delIcon; // 删除按钮图标路径
  final String? showPwdIcon; // 显示密码图标路径
  final String? hidePwdIcon; // 隐藏密码图标路径
  final int maxLength; // 最大输入长度
  final double iconSize; // 图标大小
  final double? height;
  final TextInputType keyboardType; // 键盘类型

  final ValueChanged<String>? onTextChanged;
  final ValueChanged<String>? onSubmitted;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final InputBorder? border;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  final Widget? prefixIcon; // 左侧图标
  final String? errorText; // 错误提示
  final bool autoFocus; // 是否自动聚焦

  final InputWidgetColors? lightColors; // 浅色模式颜色
  final InputWidgetColors? darkColors; // 暗黑模式颜色

  InputWidget({
    Key? key,
    this.isPassword = false,
    this.hintText = "",
    this.hintTextStyle,
    this.textStyle,
    this.onTextChanged,
    this.onSubmitted,
    this.delIcon,
    this.showPwdIcon,
    this.hidePwdIcon,
    this.iconSize = 24,
    this.maxLength = 32,
    this.keyboardType = TextInputType.text,
    this.border,
    this.textInputAction,
    this.focusNode,
    this.controller,
    this.prefixIcon,
    this.errorText,
    this.autoFocus = false,
    this.lightColors,
    this.darkColors,
    this.height,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool _obscureText = true; // 密码隐藏/显示状态
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 判断是否暗黑模式
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // 根据模式获取颜色
    final colors = isDark ? widget.darkColors : widget.lightColors;

    final Color cursorColor =
        colors?.cursorColor ?? (isDark ? Colors.white : Colors.black);
    final Color selectionColor =
        colors?.selectionColor ??
        (isDark ? Colors.white30 : Colors.blue.withOpacity(0.3));
    final Color selectionHandleColor =
        colors?.selectionHandleColor ?? (isDark ? Colors.white : Colors.blue);
    final Color textColor =
        colors?.textColor ?? (isDark ? Colors.white : Colors.black);
    final Color hintColor =
        colors?.hintTextColor ?? (isDark ? Colors.white54 : Colors.black45);
    final Color borderColor =
        colors?.borderColor ?? (isDark ? Colors.white38 : Colors.grey);
    final Color backgroundColor = colors?.backgroundColor ?? Colors.transparent;

    // 统一圆角和边框
    final BorderRadius borderRadius =
        widget.border is OutlineInputBorder
            ? (widget.border as OutlineInputBorder).borderRadius
            : BorderRadius.circular(12);

    final BoxBorder boxBorder =
        widget.border is OutlineInputBorder
            ? Border.fromBorderSide(
              (widget.border as OutlineInputBorder).borderSide,
            )
            : Border.all(color: borderColor, width: 0.5);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: boxBorder,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // 左侧图标
          if (widget.prefixIcon != null) ...[
            widget.prefixIcon!,
            const SizedBox(width: 8),
          ],
          // ⚠️ 使用 Theme 包裹 TextField 来设置选中颜色
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: cursorColor,
                  selectionColor: selectionColor,
                  selectionHandleColor: selectionHandleColor,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                autofocus: widget.autoFocus,
                obscureText: widget.isPassword ? _obscureText : false,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                maxLength: widget.maxLength,
                maxLines: 1,
                style:
                    widget.textStyle?.copyWith(color: textColor) ??
                    TextStyle(color: textColor),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r' ')),
                ],
                onChanged: widget.onTextChanged,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle:
                      widget.hintTextStyle?.copyWith(color: hintColor) ??
                      TextStyle(color: hintColor),
                  border: InputBorder.none,
                  counterText: '',
                  errorText: widget.errorText,
                  isCollapsed: true,
                  filled:
                      false, //filled: true 会让 TextField 使用 默认的填充颜色，如果你没有显式指定 fillColor，Flutter 会使用主题中 InputDecorationTheme.fillColor 或者默认的灰色。
                ),
              ),
            ),
          ),
          // 右侧图标
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 删除按钮
              if (widget.delIcon != null &&
                  (widget.controller?.text.isNotEmpty ?? false))
                IconButton(
                  iconSize: widget.iconSize,
                  icon: Image.asset(widget.delIcon!),
                  onPressed: () => widget.controller?.clear(),
                ),
              // 密码切换
              if (widget.isPassword)
                IconButton(
                  iconSize: widget.iconSize,
                  icon:
                      widget.showPwdIcon != null && widget.hidePwdIcon != null
                          ? Image.asset(
                            _obscureText
                                ? widget.showPwdIcon!
                                : widget.hidePwdIcon!,
                          )
                          : Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: textColor,
                          ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
