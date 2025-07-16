import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:common_core/helpter/logger_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'image_picker_helper.dart';

enum OutputImageFormat { png }

class ImageUtils {
  static Future<Uint8List?> createImageFromWidget(
    BuildContext context,
    Widget widget, {
    Duration? wait,
    Size? logicalSize,
    Size? imageSize,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    OutputImageFormat format = OutputImageFormat.png,
  }) async {
    final view = View.of(context);
    logicalSize ??= view.physicalSize / view.devicePixelRatio;
    imageSize ??= view.physicalSize;

    // 保护性断言
    assert(
      (logicalSize.aspectRatio - imageSize.aspectRatio).abs() < 0.01,
      'logicalSize and imageSize must have the same aspect ratio',
    );

    final repaintBoundary = RenderRepaintBoundary();

    final renderView = RenderView(
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(logicalSize),
        devicePixelRatio: view.devicePixelRatio,
      ),
      view: view,
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(textDirection: TextDirection.ltr, child: widget),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    // 自动延迟一帧或手动指定
    wait ??= const Duration(milliseconds: 20);
    await Future.delayed(wait);

    buildOwner
      ..buildScope(rootElement)
      ..finalizeTree();

    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();

    final pixelRatio = imageSize.width / logicalSize.width;

    final image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  /// 生成图片
  static Future<String?> generateImage(GlobalKey globalKey) async {
    try {
      final boundary =
          globalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('无法获取渲染边界');
      }
      final image = await boundary.toImage(pixelRatio: 2.0); // 提高分辨率
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        return await saveImage(
          imageData: byteData.buffer.asUint8List(),
        );
      } else {
        throw Exception('图片数据为空');
      }
    } catch (e) {
      rethrow;
    }
  }

  /////////////////////////////////为照片添加水印////////////////////////////////////////////
  static Future<String?> addWatermarkFromImgPath(
    BuildContext context,
    String path,
    Positioned positioned,
  ) async {
    final imageProvider = FileImage(File(path));
    final widgetToCapture = Stack(
      children: [Image(image: imageProvider, fit: BoxFit.cover), positioned],
    );
    try {
      await _getImageSize(imageProvider);
      final bytes = await ImageUtils.createImageFromWidget(
        context,
        widgetToCapture,
      );
      if (bytes != null) {
        return await saveImage(imageData: bytes);
      } else {
        throw Exception("生成图片失败");
      }
    } catch (e, st) {
      LoggerHelper.d("生成水印图片失败: $e\n$st");
    }
  }

  static Future<Size> _getImageSize(FileImage imageProvider) async {
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

  /// 修复图片颜色问题
  static Future<String?> fixColor(String imagePath) async {
    final file = File(imagePath);
    if (!file.existsSync()) return null;

    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return null;

    final fixedBytes = img.encodeJpg(image, quality: 100);
    await file.writeAsBytes(fixedBytes);
    return imagePath;
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


  /// 获取本地图片信息
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
