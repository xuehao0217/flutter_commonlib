import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/base/base_page_stateless_widget.dart';
import 'package:flutter_commonlib/base/mvvm/base_stateless_widget.dart';
import 'package:flutter_commonlib/base/mvvm/base_view_abs.dart';
import 'package:flutter_commonlib/base/mvvm/base_view_model.dart';

class MyPage extends BasePageStatelessWidget {
  @override
  Widget buildContent(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent,
    );
  }
  @override
  Color setStatusBarColor()=>Colors.deepPurpleAccent;

  @override
  String setTitle() => "我的";

  @override
  bool showTitleBar()=>false;
}
