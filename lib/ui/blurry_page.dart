import 'dart:ui';

import 'package:common_core/base/base_stateful_widget.dart';
import 'package:common_core/helpter/widget_ext_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../generated/assets.dart';


class BlurryPage extends StatefulWidget {
  @override
  _BlurryState createState() => _BlurryState();
}

class _BlurryState extends BaseStatefulWidget<BlurryPage> {
  late AnimationController controller;
  late AnimationController controller1;
  @override
  Widget buildPageContent(BuildContext context) {
    return Stack(
      children: [
        Container(
                width: double.infinity,
                height: double.infinity,
                child: Hero(tag: "Hero",
                  child: Image.asset(R.assetsIcLogo).withClick(() {
                    controller.forward();
                    // controller1.forward();
                  }),))
            .animate(
                autoPlay: false,
                onInit: (c) {
                  controller = c;
                  controller.stop();
                },
                onComplete: (c) {
                  Get.back();
                })
            .effect(duration: 300.ms)
            .blurXY(begin: 0, end: 16)
            .scaleXY(begin: 1, end: 2.5),
      ],
    );

    //     .animate(autoPlay: false,onInit: (c){
    //   controller1=c;
    //   controller1.stop();
    // }).slideY(begin: 1,end: -1);
  }
}
