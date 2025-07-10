import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ImageLoaderUtils {
  static Future<Uint8List?> createImageFromWidget(
      BuildContext context, Widget widget,
      {Duration? wait, Size? logicalSize, Size? imageSize}) async {
    final repaintBoundary = RenderRepaintBoundary();

    logicalSize ??=
        View.of(context).physicalSize / View.of(context).devicePixelRatio;
    imageSize ??= View.of(context).physicalSize;

    assert(logicalSize.aspectRatio == imageSize.aspectRatio,
        'logicalSize and imageSize must not be the same');

    final renderView = RenderView(
        child: RenderPositionedBox(
            alignment: Alignment.center, child: repaintBoundary),
        configuration: ViewConfiguration(
          // physicalConstraints: BoxConstraints(maxHeight: logicalSize.height, maxWidth: logicalSize.width),
          logicalConstraints: BoxConstraints(
            maxHeight: logicalSize.height,
            maxWidth: logicalSize.width,
          ),
          // size: logicalSize,
          devicePixelRatio: 1,
        ),
        view: View.of(context) //PlatformDispatcher.instance.views.first,
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
        )).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    if (wait != null) {
      await Future.delayed(wait);
    }

    buildOwner
      ..buildScope(rootElement)
      ..finalizeTree();

    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();

    final image = await repaintBoundary.toImage(
        pixelRatio: imageSize.width / logicalSize.width);
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }
}
