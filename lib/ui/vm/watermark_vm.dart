import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:common_core/helpter/image_loader_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class WatermarkViewModel extends BaseViewModel {
  // 实例化
  final picker = ImagePicker();
  var pickImage = "".obs;
  final GlobalKey globalKey = GlobalKey();
  var saveImagePath = "".obs;



  Future getImage() async {
    final pickedFile = await picker.pickImage(
      // 拍照获取图片
      source: ImageSource.camera,
      // 手机选择图库
      //   source: ImageSource.gallery,
    );
    // 更新状态
    if (pickedFile != null) {
      pickImage.value = pickedFile.path;

    } else {
     view.showToast('没有选择任何图片');
    }
  }





  // var isImageGenerated = Rx<bool>(false);
  // var generatedImage = Rx<Uint8List?>(null);
  Future generateImage(BuildContext context) async {
    final boundary =
    globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1); // 调整分辨率
    image
        .toByteData(format: ImageByteFormat.png)
        .then((value) => {_saveImage(value!.buffer.asUint8List())});
  }





  Future getImageToImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(
      // 拍照获取图片
      source: ImageSource.camera,
      // 手机选择图库
      //   source: ImageSource.gallery,
    );
    if (pickedFile != null) {
     view.showLoading();
      final image = File(pickedFile.path);
      final imageBytes = await image.readAsBytes();
      final decodedImage = await decodeImageFromList(imageBytes);
      var imageWidth = decodedImage.width.toDouble();
      var imageHeight = decodedImage.height.toDouble();
      // showToast("imageWidth==${imageWidth}   imageHeight=${imageHeight} ");
      captureWidgetToImage(context, pickedFile.path, imageWidth, imageHeight);
    } else {
      SmartDialog.showToast('没有选择任何图片');
    }
  }

  //widget不能在页面展示，需要在后台构建指定的UI，获取widget的截图并生成图片保存起来。
  void captureWidgetToImage(BuildContext context, String path,
      double imageWidth, double imageHeight) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double aspectRatio = imageWidth / imageHeight; // 图片宽高比
    double containerHeight = screenWidth / aspectRatio;

    final imageProvider = FileImage(File(path));
    final widgetToCapture = ConstraintLayout(
      children: [
        // Image.file(File(path)).applyConstraint(
        //   id: cId("img"),
        //   top: parent.top,
        //   width: matchParent,
        // ),
        Image(
          image: imageProvider,
        ).applyConstraint(
          id: cId("img"),
          top: parent.top,
          width: matchParent,
        ),
        const Text(
          "我是水印",
          style: TextStyle(color: Colors.red, fontSize: 15),
        ).applyConstraint(
            right: cId("img").right,
            bottom: cId("img").bottom,
            margin: EdgeInsets.only(bottom: 20, right: 20))
      ],
    );

    //_imageStream.removeListener(listener) 记得removeListener
    var _imageStream = imageProvider.resolve(ImageConfiguration.empty);
    _imageStream.addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) async {
          final Uint8List? imageUint8List =
          await ImageLoaderUtils.createImageFromWidget(context, widgetToCapture,
              imageSize: Size(imageWidth * 0.5, imageHeight * 0.5),
              // imageSize: Size(screenWidth * 2, containerHeight * 2),
              logicalSize: Size(screenWidth, containerHeight));
          if (imageUint8List != null) {
            _saveImage(imageUint8List);
            print('Image captured successfully.');
          } else {
            print('Image capture failed.');
          }
        }));

  }

  Future _saveImage(Uint8List generatedImage) async {
    final directory = await getApplicationDocumentsDirectory();
    var file = await File(
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png')
        .writeAsBytes(generatedImage);
    view.showToast(file.path);
      saveImagePath.value = file.path;
      view.hideLoading();
  }
}
