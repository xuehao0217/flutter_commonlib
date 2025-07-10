import 'package:common_core/common_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

const Color cl_divider= Color(0xffE0E0E0);
const Color cl_666666= Color(0xff666666);
const Color cl_right= Color(0xff7153FF);

void showTwoBtContentDialog(String content,{left="Cancel", right="OK", VoidCallback? onLeftTap,onRightTap,}) {
  SmartDialog.show(
    alignment: Alignment.center,
    builder: (_) => Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TwoBtContentDialog(
            desc: content,
            left: left,
            right: right,
            onLeftTap: (){
              SmartDialog.dismiss();
              onLeftTap?.call();
            },
            onRightTap: (){
              SmartDialog.dismiss();
              onRightTap?.call();
            },
          ),
        ),
      ),
    ),
  );
}

class TwoBtContentDialog extends StatelessWidget {
  final String desc, left, right;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  const TwoBtContentDialog({
    super.key,
    required this.desc,
    required this.left,
    required this.right,
    this.onLeftTap,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min, // ⬅️ 关键：让 Column 高度自适应内容
        children: [
          SizedBox(height: 28),
          Text(
            desc,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff333333),
            ),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 34),
          SizedBox(height: 28),
          Divider(height: 0.5, color: cl_divider).paddingSymmetric(horizontal: 18),
          SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  left,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: cl_666666),
                  textAlign: TextAlign.center,
                ).click((){
                  onLeftTap?.call();
                }),
              ),
              Container(width: 0.5, height: 42, color: cl_divider),
              Expanded(
                child: Text(
                  right,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: cl_right),
                  textAlign: TextAlign.center,
                ).click((){
                  onRightTap?.call();
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
