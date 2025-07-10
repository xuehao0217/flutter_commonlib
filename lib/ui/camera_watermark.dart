import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui';

import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/helpter/widget_ext_helper.dart';
import 'package:common_core/widget/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_commonlib/ui/vm/watermark_vm.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:get/get.dart';

class WatermarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WatermarkPage();
}

class _WatermarkPage extends BaseVMStatefulWidget<WatermarkPage,WatermarkViewModel> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() => ListView(
          children: [
            if (viewModel.pickImage.value.isNotEmpty)
              RepaintBoundary(
                key: viewModel.globalKey,
                child: ConstraintLayout(
                  children: [
                    Obx(() => Image.file(File(viewModel.pickImage.value))
                            .applyConstraint(
                          id: cId("img"),
                          top: parent.top,
                          width: matchParent,
                        )),
                    const Text(
                      "我是水印",
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ).applyConstraint(
                      right: cId("img").right,
                      bottom: cId("img").bottom,
                    )
                  ],
                ),
              ),
            CommonButton(
              elevation: 2,
              circular: 10,
              backgroundColor: Colors.blue,
              width: double.infinity,
              height: 50,
              onPressed: () async {
                viewModel.getImage();
              },
              child: const Text(
                "拍照",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ).intoPadding(
                const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
            if (viewModel.saveImagePath.value.isNotEmpty)
              Image.file(File(viewModel.saveImagePath.value)),
            // Image.memory(
            //   generatedImage.value!!,
            // ),

            CommonButton(
              elevation: 2,
              circular: 10,
              backgroundColor: Colors.blue,
              width: double.infinity,
              height: 50,
              onPressed: () {
                if(viewModel.pickImage.value.isNotEmpty){
                  viewModel.generateImage(context);
                }else{
                  showToast("请先拍照");
                }
              },
              child: const Text(
                "打水印",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ).intoPadding(
                const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

            CommonButton(
              elevation: 2,
              circular: 10,
              backgroundColor: Colors.blue,
              width: double.infinity,
              height: 50,
              onPressed: () {
                viewModel.getImageToImage(context);
              },
              child: const Text(
                "不显示照片打水印",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ).intoPadding(
                const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
          ],
        ));
  }

  @override
  WatermarkViewModel createViewModel() => WatermarkViewModel();

  @override
  void initData() {}
}
