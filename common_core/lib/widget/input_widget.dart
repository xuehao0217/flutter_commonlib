import 'package:flutter/material.dart';

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

  final double iconSize;
  final TextInputType keyboardType;

  final FontWeight fontWeight;
  final FontWeight hintFontWeight;
  final ValueChanged<String>? onTextChanged;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;

  final InputBorder? border;
  final Color? fillColor;

  //线
  // UnderlineInputBorder(
  // borderSide: BorderSide(
  // color: widget.UnderlineColor, // 下划线颜色（焦点状态）
  // width: 0.5 // 下划线宽度
  // ),
  // )

  // OutlineInputBorder(
  // borderRadius: BorderRadius.circular(12),
  // borderSide: BorderSide(color: widget.UnderlineColor, width: 0.5),
  // )

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
    this.fontWeight = FontWeight.normal,
    this.hintFontWeight = FontWeight.normal,
    this.border,
    this.fillColor,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  var textEditingController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      //最大长度,右下角会显示一个输入数量的字符串
      maxLength: 26,
      //最大行数
      maxLines: 1,
      //是否自动更正
      autocorrect: true,
      //是否自动对焦
      autofocus: true,
      //设置密码 true：是密码 false：不是秘密
      obscureText: widget.isPassword ? _obscureText : false,
      //文本对齐样式
      textAlign: TextAlign.start,
      onChanged: (text) {
        widget.onTextChanged?.call(text); // 调用回调函数传递文本
      },
      keyboardType: widget.keyboardType,
      style: widget.textStyle,
      decoration: InputDecoration(
        labelText: '',
        counterText: '',
        filled: true,
        fillColor: widget.fillColor,
        hintStyle: widget.hintTextStyle,
        hintText: widget.hintText,
        // 设置提示文字
        // border: InputBorder.none,
        border:
            widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.UnderlineColor, width: 0.5),
            ),
        enabledBorder:
            widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.UnderlineColor, width: 0.5),
            ),
        focusedBorder:
            widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.UnderlineColor, width: 0.5),
            ),
        //去除下划线
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 24,
              icon:
                  widget.delIcon.isNotEmpty
                      ? Image.asset(widget.delIcon)
                      : const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  textEditingController.clear();
                });
              },
            ),
            if (widget.isPassword)
              IconButton(
                iconSize: 24,
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
    textEditingController.dispose();
    super.dispose();
  }
}
