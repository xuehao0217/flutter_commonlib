import 'dart:async';
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
    var savePath = await ImageUtils.generateImage(globalKey);
    saveImagePath1.value = savePath ?? "";
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

  Future<void> _captureWidgetToImage(BuildContext context, String path) async {
    final imageProvider = FileImage(File(path));
    final widgetToCapture = Stack(
      children: [
        Image(image: imageProvider, fit: BoxFit.cover),
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
    try {
      await getImageSize(imageProvider);
      final bytes = await ImageUtils.createImageFromWidget(
        context,
        widgetToCapture,
      );
      if (bytes != null) {
        final savePath = await ImagePickerHelper.saveImage(imageData: bytes);
        print("保存成功: $savePath");
        saveImagePath2.value = savePath!;
      } else {
        throw Exception("生成图片失败");
      }
    } catch (e, st) {
      print("生成水印图片失败: $e\n$st");
    }
  }


  Future<Size> getImageSize(FileImage imageProvider) async {
    final completer = Completer<Size>();
    final imageStream = imageProvider.resolve(const ImageConfiguration());
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, _) {
        imageStream.removeListener(listener);
        completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()),
        );
      },
      onError: (dynamic error, StackTrace? stackTrace) {
        completer.completeError(error, stackTrace);
      },
    );
    imageStream.addListener(listener);
    return completer.future;
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
