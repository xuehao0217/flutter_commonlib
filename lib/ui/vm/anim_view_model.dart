
import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AnimViewModel extends BaseViewModel {

  var ZoomIn=true.obs;

  var FadeOut=true.obs;


  var FadeAll=true.obs;
  Widget getContainer()=>Container(
  width: 50,
  height: 50,
  color: Colors.blueAccent,
  );
}