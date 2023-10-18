import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_commonlib/ui/vm/watermark_vm.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../base/mvvm/base_stateful_widget.dart';
import '../widget/common_widget.dart';

class WatermarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WatermarkPage();
}

class _WatermarkPage extends BaseStatefulWidget<WatermarkViewModel> {
  // 实例化
  final picker = ImagePicker();
  var _image = "".obs;
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget buildPageContent(BuildContext context) {
    return ListView(
      children: [
        if (_image.value.isNotEmpty)
          RepaintBoundary(
            key: globalKey,
            child: ConstraintLayout(
              children: [
                Obx(() => Image.file(File(_image.value)).applyConstraint(
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
            getImage();
          },
          child: const Text(
            "拍照",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        if (saveImagePath.value.isNotEmpty)
          Image.file(File(saveImagePath.value)),
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
            generateImage();
          },
          child: const Text(
            "打水印",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
      ],
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(
      // 拍照获取图片
      source: ImageSource.camera,
      // 手机选择图库
      //   source: ImageSource.gallery,
    );
    // 更新状态
    setState(() {
      if (pickedFile != null) {
        _image.value = pickedFile.path;
      } else {
        SmartDialog.showToast('没有选择任何图片');
      }
    });
  }

  @override
  WatermarkViewModel createViewModel() => WatermarkViewModel();

  @override
  void initData() {}

  var saveImagePath = "".obs;

  Future _saveImage(Uint8List generatedImage) async {
    final directory = await getApplicationDocumentsDirectory();
    var file = await File('${directory.path}/my_image.png')
        .writeAsBytes(generatedImage);
    setState(() {
      showToast(file.path);
      saveImagePath.value = file.path;
    });
  }

  // var isImageGenerated = Rx<bool>(false);
  // var generatedImage = Rx<Uint8List?>(null);
  Future generateImage() async {
    final boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3); // 调整分辨率
    image
        .toByteData(format: ImageByteFormat.png)
        .then((value) => {_saveImage(value!.buffer.asUint8List())});
  }
}
