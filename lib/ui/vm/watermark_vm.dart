import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:common_core/helpter/image_loader_utils.dart';
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
  var saveImagePath = "".obs;
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

  /// 生成带水印的图片
  Future<void> generateImage(BuildContext context) async {
    try {
      isLoading.value = true;

      final boundary =
          globalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('无法获取渲染边界');
      }

      final image = await boundary.toImage(pixelRatio: 2.0); // 提高分辨率
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      if (byteData != null) {
        await _saveImage(byteData.buffer.asUint8List());
      } else {
        throw Exception('图片数据为空');
      }
    } catch (e) {
      showToast('生成水印失败: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
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
              await ImageLoaderUtils.createImageFromWidgetPlus(
                context,
                widgetToCapture,
              );
          if (imageUint8List != null) {
            await _saveImage(imageUint8List);
            print('图片生成成功');
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

  /// 保存图片到本地
  Future<void> _saveImage(Uint8List generatedImage) async {
    var savePath = await ImagePickerHelper.saveImage(imageData: generatedImage);
    if (savePath != null) {
      saveImagePath.value = savePath;
      view.showToast('图片已保存到 $savePath');
    } else {
      view.showToast('保存图片失败');
    }
  }

  /// 清除当前图片
  void clearImage() {
    pickImage.value = "";
    saveImagePath.value = "";
  }

  /// 检查是否有图片
  bool get hasImage => pickImage.value.isNotEmpty;
}
