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
    int? imageQuality ,
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
    int? imageQuality ,
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
} 