import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
enum OutputImageFormat { png }

class ImageLoaderUtils {
  static Future<Uint8List?> createImageFromWidgetPlus(
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
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
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
}
