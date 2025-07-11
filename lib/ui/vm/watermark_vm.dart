import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:common_core/helpter/image_utils.dart';
import 'package:common_core/helpter/image_picker_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WatermarkViewModel extends BaseViewModel {
  // 实例化
  final picker = ImagePicker();
  var pickImage = "".obs;
  final GlobalKey globalKey = GlobalKey();
  var isLoading = false.obs;

  /// 获取图片（拍照）
  Future<void> getImage() async {
    try {
      isLoading.value = true;
      final path = await ImagePickerHelper.takePhoto(
        source: ImageSource.camera,
        imageQuality: 80, // 添加图片质量设置
      );
      if (path != null) {
        pickImage.value = path;
        view.showToast('拍照成功');
      } else {
        view.showToast('没有选择任何图片');
      }
    } catch (e) {
      showToast('拍照失败: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  var saveImagePath1 = "".obs;
  /// 生成带水印的图片
  Future<void> generateImage() async {
    isLoading.value = true;
    var savePath= await ImageUtils.generateImage(globalKey);
    saveImagePath1.value = savePath??"";
    showToast('图片已保存到 $savePath');
    isLoading.value = false;
  }

  /// 拍照并直接添加水印（不显示预览）
  Future<void> getImageToImage(BuildContext context) async {
    try {
      isLoading.value = true;
      final path = await ImagePickerHelper.takePhoto(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (path != null) {
        await _captureWidgetToImage(context, path);
      } else {
        showToast('没有选择任何图片');
      }
    } catch (e) {
      showToast('处理失败: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  var saveImagePath2 = "".obs;
  /// 捕获Widget并生成图片
  Future<void> _captureWidgetToImage(BuildContext context, String path) async {
    final imageProvider = FileImage(File(path));
    final widgetToCapture = Stack(
      children: [
        Image(image: imageProvider),
        Positioned(
          bottom: 15,
          right: 15,
          child: Text(
            "我是水印",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );

    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    imageStream.addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) async {
        try {
          final imageUint8List =
              await ImageUtils.createImageFromWidget(
                context,
                widgetToCapture,
              );
          if (imageUint8List != null) {
            var savePath = await ImagePickerHelper.saveImage(imageData: imageUint8List);
            saveImagePath2.value = savePath!;
          } else {
            throw Exception('图片生成失败');
          }
        } catch (e) {
          view.hideLoading();
          print('图片生成失败: $e');
        }
      }),
    );
  }



  /// 清除当前图片
  void clearImage() {
    pickImage.value = "";
    saveImagePath1.value = "";
    saveImagePath2.value = "";
  }

  /// 检查是否有图片
  bool get hasImage => pickImage.value.isNotEmpty;
}
