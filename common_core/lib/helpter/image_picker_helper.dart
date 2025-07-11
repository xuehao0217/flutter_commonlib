import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();
  /// 拍照获取图片
  static Future<String?> takePhoto({
    ImageSource source = ImageSource.camera,
    int imageQuality = 80,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );
      return pickedFile?.path;
    } catch (e) {
      print('拍照失败: $e');
      return null;
    }
  }

  /// 从相册选择图片
  static Future<String?> pickImageFromGallery({
    int imageQuality = 80,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );
      return pickedFile?.path;
    } catch (e) {
      print('选择图片失败: $e');
      return null;
    }
  }


  /// 保存图片到本地
  static Future<String?> saveImage({
    required Uint8List imageData,
    String? fileName,
    String? directory,
  }) async {
    try {
      final saveDirectory = directory ?? (await getApplicationDocumentsDirectory()).path;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final saveFileName = fileName ?? 'watermark_$timestamp.png';
      
      final file = await File('$saveDirectory/$saveFileName').writeAsBytes(imageData);
      return file.path;
    } catch (e) {
      print('保存图片失败: $e');
      return null;
    }
  }


  /// 获取图片信息
  static Future<Size?> getImageSize(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final decodedImage = await decodeImageFromList(imageBytes);
      return Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    } catch (e) {
      print('获取图片尺寸失败: $e');
      return null;
    }
  }

  /// 检查文件是否存在
  static bool isFileExists(String filePath) {
    return File(filePath).existsSync();
  }

  /// 删除文件
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('删除文件失败: $e');
      return false;
    }
  }
} 