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

import '../base/base_page_stateful_widget.dart';
import '../base/mvvm/base_stateful_widget.dart';
import '../helpter/image_loader_utils.dart';
import '../widget/common_widget.dart';
import 'package:image/image.dart' as img;
class WatermarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WatermarkPage();
}

class _WatermarkPage extends BaseStatefulWidget<WatermarkViewModel> {
  // 实例化
  final picker = ImagePicker();
  var _image = "".obs;
  final GlobalKey _widgetKey = GlobalKey();

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      children: [

         ConstraintLayout(
            key: _widgetKey,
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
            "拍照打水印",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: Colors.blue,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            _generatePicWidget();
          },
          child: const Text(
            "拍照打水印1111",
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
    setState(() async {
      if (pickedFile != null) {
        _image.value = pickedFile.path;
        _generatePicWidget();
      } else {
        SmartDialog.showToast('没有选择任何图片');
      }
    });
  }

  @override
  WatermarkViewModel createViewModel() =>WatermarkViewModel();

  @override
  void initData() {
  }


  /// 通过 RenderRepaintBoundary 生成图片
  void _generatePicWidget() async {
    //根据Globalkey获取RenderObject对象
    final boundary = _widgetKey.currentContext?.findRenderObject();
    if (boundary != null && boundary is RenderRepaintBoundary) {
      final image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        //获取当前文件目录
        Directory fileDirectory = await getApplicationDocumentsDirectory();
        String filePath = fileDirectory.path;
        Directory directory;
        directory = await Directory(
            '$filePath${Platform.pathSeparator}picuser')
            .create(recursive: true);
        assert(await directory.exists() == true);
        //将字节流数据转Unit8编码
        Uint8List imageData = byteData.buffer.asUint8List();
        //将数据写入目录下的文件
        File("${directory.absolute.path}/temp.png").writeAsBytes(imageData);
        SmartDialog.showToast(filePath+"--------");
      }
    }
  }
}
