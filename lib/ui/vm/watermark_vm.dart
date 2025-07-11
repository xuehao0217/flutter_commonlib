import 'dart:async';
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
    var savePath = await ImageUtils.generateImage(globalKey);
    saveImagePath1.value = savePath ?? "";
    showToast('图片已保存到 $savePath');
    isLoading.value = false;
  }

  var saveImagePath2 = "".obs;

  /// 拍照并直接添加水印（不显示预览）
  Future<void> getImageToImage(BuildContext context) async {
    try {
      isLoading.value = true;
      final takePhotoPath = await ImagePickerHelper.takePhoto(
        source: ImageSource.camera,
      );
      if (takePhotoPath != null) {
        var path = await ImageUtils.addWatermarkFromImgPath(
          context,
          takePhotoPath,
          Positioned(
            bottom: 25,
            right: 25,
            child: Text(
              "拍照并直接添加水印（不显示预览）",
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        );
        saveImagePath2.value = path!;
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

  /// 清除当前图片
  void clearImage() {
    pickImage.value = "";
    saveImagePath1.value = "";
    saveImagePath2.value = "";
  }

  /// 检查是否有图片
  bool get hasImage => pickImage.value.isNotEmpty;
}
