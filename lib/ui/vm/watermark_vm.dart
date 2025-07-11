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
  static const double _imageScale = 0.5;
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
      
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // 添加图片质量设置
      );
      
      if (pickedFile != null) {
        pickImage.value = pickedFile.path;
        view.showToast('拍照成功');
      } else {
        view.showToast('没有选择任何图片');
      }
    } catch (e) {
      view.showToast('拍照失败: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// 生成带水印的图片
  Future<void> generateImage(BuildContext context) async {
    try {
      isLoading.value = true;
      
      final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
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
      view.showToast('生成水印失败: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// 拍照并直接添加水印（不显示预览）
  Future<void> getImageToImage(BuildContext context) async {
    try {
      isLoading.value = true;
      
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        await _processImageWithWatermark(context, pickedFile.path);
      } else {
        SmartDialog.showToast('没有选择任何图片');
      }
    } catch (e) {
      SmartDialog.showToast('处理失败: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// 处理图片并添加水印
  Future<void> _processImageWithWatermark(BuildContext context, String imagePath) async {
    try {
      view.showLoading();
      
      final image = File(imagePath);
      final imageBytes = await image.readAsBytes();
      final decodedImage = await decodeImageFromList(imageBytes);
      
      final imageWidth = decodedImage.width.toDouble();
      final imageHeight = decodedImage.height.toDouble();
      
      await _captureWidgetToImage(context, imagePath, imageWidth, imageHeight);
    } catch (e) {
      view.hideLoading();
      throw Exception('处理图片失败: $e');
    }
  }

  /// 捕获Widget并生成图片
  Future<void> _captureWidgetToImage(
    BuildContext context,
    String path,
    double imageWidth,
    double imageHeight,
  ) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final aspectRatio = imageWidth / imageHeight;
    final containerHeight = screenWidth / aspectRatio;

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
    imageStream.addListener(ImageStreamListener((ImageInfo info, bool synchronousCall) async {
        try {
          final imageUint8List = await ImageLoaderUtils.createImageFromWidget(
            context,
            widgetToCapture,
            imageSize: Size(
              imageWidth * _imageScale, 
              imageHeight * _imageScale
            ),
            logicalSize: Size(screenWidth, containerHeight),
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
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'watermark_$timestamp.png';
      
      final file = await File('${directory.path}/$fileName').writeAsBytes(generatedImage);
      
      saveImagePath.value = file.path;
      view.showToast('图片已保存到: ${file.path}');
      view.hideLoading();
    } catch (e) {
      view.hideLoading();
      throw Exception('保存图片失败: $e');
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
