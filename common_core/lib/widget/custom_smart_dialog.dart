
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void showCustomToast(String msg)=>SmartDialog.showToast('',alignment: Alignment.center, builder: (_) => ToastWidget( msg: msg,));
void showCustomLoading()=>SmartDialog.showLoading( builder: (_) => LoadingWidget(msg: "loading...",));


Color smart_dialog_backgroundColor = Colors.black.withOpacity(0.6);
Color smart_dialog_textColor =  Colors.white;


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.msg}) : super(key: key);

  ///loading msg
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: smart_dialog_backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        //loading animation
        CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation(smart_dialog_textColor),
        ),

        //msg
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Text(msg, style: TextStyle(color:smart_dialog_textColor)),
        ),
      ]),
    );
  }
}

class ToastWidget extends StatelessWidget {
  const ToastWidget({Key? key, required this.msg}) : super(key: key);

  ///toast msg
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: smart_dialog_backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(msg, style: TextStyle(color: smart_dialog_textColor)),
    );
  }
}
