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
        return await ImagePickerHelper.saveImage(
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
        return await ImagePickerHelper.saveImage(imageData: bytes);
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
}
