import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * 创 建 人: xueh
 * 创建日期: 2023/10/13
 * 备注：
 */
class InputWidget extends StatefulWidget {
  final bool isPassword;
  final String hintText;

  final Color UnderlineColor;
  final String delIcon;
  final String showPwdIcon;
  final String hidePwdIcon;
  final int maxLength;
  final double iconSize;
  final TextInputType keyboardType;

  final ValueChanged<String>? onTextChanged;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;

  final InputBorder? border;
  final Color? fillColor;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  final TextEditingController? controller;
  final double contentHorizontalPadding;
  //线
  //border: UnderlineInputBorder(
  // borderSide: BorderSide(
  // color: widget.UnderlineColor, // 下划线颜色（焦点状态）
  // width: 0.5 // 下划线宽度
  // ),
  // )

  //border: OutlineInputBorder(
  // borderRadius: BorderRadius.circular(12),
  // borderSide: BorderSide(color: widget.UnderlineColor, width: 0.5),
  // )


  // border: OutlineInputBorder(
  // borderRadius: BorderRadius.circular(12),
  // borderSide: const BorderSide(
  // color: Colors.grey, // 边框颜色
  // width: 1,           // 边框宽度
  // ),
  // ),

  InputWidget({
    Key? key,
    this.isPassword = true,
    this.hintText = "",
    this.hintTextStyle,
    this.textStyle,
    this.onTextChanged,
    this.delIcon = "",
    this.showPwdIcon = "",
    this.hidePwdIcon = "",
    this.iconSize = 24,
    this.UnderlineColor = Colors.grey,
    this.keyboardType = TextInputType.number,
    this.border,
    this.fillColor,
    this.textInputAction,
    this.onSubmitted,
    this.controller, this.maxLength=32,  this.contentHorizontalPadding=12,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: widget.UnderlineColor, width: 0.5),
    );
    return TextField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // 彻底禁止输入空格
      ],
      textAlignVertical: TextAlignVertical.center,
      focusNode: _focusNode,
      controller: widget.controller,
      //最大长度,右下角会显示一个输入数量的字符串
      maxLength: widget.maxLength,
      //最大行数
      maxLines: 1,
      //是否自动更正
      autocorrect: true,
      //是否自动对焦
      autofocus: false,
      //设置密码 true：是密码 false：不是秘密
      obscureText: widget.isPassword ? _obscureText : false,
      //文本对齐样式
      textAlign: TextAlign.start,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      onChanged: (text) {
        widget.onTextChanged?.call(text);
      },
      keyboardType: widget.keyboardType,
      style: widget.textStyle,
      decoration: InputDecoration(
        // labelText: '',
        counterText: '',
        filled: true,
        fillColor: widget.fillColor,
        hintStyle: widget.hintTextStyle,
        hintText: widget.hintText,
        // 设置提示文字
        // border: InputBorder.none,
        border: widget.border ?? outlineBorder,
        enabledBorder: widget.border ?? outlineBorder,
        focusedBorder: widget.border ?? outlineBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: widget.contentHorizontalPadding),
        //去除下划线
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.delIcon.isNotEmpty
                ? IconButton(
                  iconSize: widget.iconSize,
                  icon: Image.asset(widget.delIcon),
                  onPressed: () {
                    setState(() {
                      widget.controller?.clear();
                    });
                  },
                )
                : SizedBox(),

            if (widget.isPassword)
              IconButton(
                iconSize: widget.iconSize,
                icon:
                    widget.showPwdIcon.isNotEmpty &&
                            widget.hidePwdIcon.isNotEmpty
                        ? Image.asset(
                          _obscureText
                              ? widget.showPwdIcon
                              : widget.hidePwdIcon,
                        )
                        : Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
