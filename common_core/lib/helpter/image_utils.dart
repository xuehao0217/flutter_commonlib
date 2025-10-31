import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:common_core/helpter/logger_helper.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

enum OutputImageFormat { png, jpg }

class ImageUtils {
  /// ===========================
  /// 将 Widget 转图片（Uint8List）
  /// ===========================
  static Future<Uint8List?> createImageFromWidget(
    BuildContext context,
    Widget widget, {
    Duration wait = const Duration(milliseconds: 20),
    Size? logicalSize,
    Size? imageSize,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    OutputImageFormat format = OutputImageFormat.png,
  }) async {
    final view = View.of(context);
    logicalSize ??= view.physicalSize / view.devicePixelRatio;
    imageSize ??= view.physicalSize;

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
    final byteData = await image.toByteData(
      format:
          format == OutputImageFormat.png
              ? ui.ImageByteFormat.png
              : ui.ImageByteFormat.rawRgba,
    );

    return byteData?.buffer.asUint8List();
  }

  /// ===========================
  /// 生成 Widget 对应图片文件
  /// ===========================
  static Future<String?> generateImage(GlobalKey globalKey) async {
    try {
      final boundary =
          globalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('无法获取渲染边界');

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('图片数据为空');

      return await saveImage(imageData: byteData.buffer.asUint8List());
    } catch (e) {
      LoggerHelper.d("生成图片失败: $e");
      return null;
    }
  }

  /// ===========================
  /// 为图片添加水印
  /// ===========================
  static Future<String?> addWatermarkFromImgPath(
    BuildContext context,
    String path,
    Positioned watermark,
  ) async {
    try {
      final imageProvider = FileImage(File(path));
      final widgetToCapture = Stack(
        children: [Image(image: imageProvider, fit: BoxFit.cover), watermark],
      );

      final bytes = await createImageFromWidget(context, widgetToCapture);
      if (bytes != null) return await saveImage(imageData: bytes);

      throw Exception('生成水印图片失败');
    } catch (e, st) {
      LoggerHelper.d("生成水印图片失败: $e\n$st");
      return null;
    }
  }

  /// 获取 FileImage 的尺寸
  static Future<Size> _getFileImageSize(FileImage imageProvider) async {
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
      onError: (error, stackTrace) {
        completer.completeError(error, stackTrace);
      },
    );
    imageStream.addListener(listener);
    return completer.future;
  }

  /// ===========================
  /// 修复图片颜色问题
  /// ===========================
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

  /// ===========================
  /// 保存图片到本地
  /// ===========================
  static Future<String?> saveImage({
    required Uint8List imageData,
    String? fileName,
    String? directory,
  }) async {
    try {
      final saveDir =
          directory ?? (await getApplicationDocumentsDirectory()).path;
      final name =
          fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await File('$saveDir/$name').writeAsBytes(imageData);
      return file.path;
    } catch (e) {
      LoggerHelper.d('保存图片失败: $e');
      return null;
    }
  }

  /// ===========================
  /// 文件操作
  /// ===========================
  static bool isFileExists(String filePath) => File(filePath).existsSync();

  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      LoggerHelper.d('删除文件失败: $e');
      return false;
    }
  }

  /// ===========================
  /// 获取文件大小
  /// ===========================
  static Future<int?> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      return await file.length();
    } catch (e) {
      LoggerHelper.d('获取文件大小失败: $e');
      return null;
    }
  }

  /// ===========================
  /// 获取文件大小
  ///   file.lengthSync() 返回字节数。
  ///   toStringAsFixed(1) 保留一位小数。
  ///   大于等于 1MB 显示 MB，否则显示 KB。
  /// ===========================

  static String formatFileSize(String filePath) {
    try {
      final file = File(filePath);
      final bytes = file.lengthSync(); // 获取文件大小，单位字节
      if (bytes >= 1024 * 1024) {
        double sizeInMb = bytes / (1024 * 1024);
        return "${sizeInMb.toStringAsFixed(1)} MB";
      } else {
        double sizeInKb = bytes / 1024;
        return "${sizeInKb.toStringAsFixed(1)} KB";
      }
    } catch (e) {
      LoggerHelper.d('获取文件大小失败: $e');
      return "未知大小";
    }
  }

  static final ImagePicker _picker = ImagePicker();

  /// ===========================
  /// 拍照 / 相册
  /// ===========================
  static Future<File?> takePhoto({int? imageQuality}) async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
      );
      return file != null ? File(file.path) : null;
    } catch (e) {
      debugPrint('拍照失败: $e');
      return null;
    }
  }

  static Future<File?> pickFromGallery({int? imageQuality}) async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );
      return file != null ? File(file.path) : null;
    } catch (e) {
      debugPrint('选择图片失败: $e');
      return null;
    }
  }

  /// ===========================
  /// File <-> Uint8List
  /// ===========================
  static Future<Uint8List?> fileToBytes(File file) async {
    try {
      return await file.readAsBytes();
    } catch (e) {
      debugPrint('File 转 Uint8List 失败: $e');
      return null;
    }
  }

  static Future<File?> bytesToFile(Uint8List bytes, String fileName) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('Bytes 转 File 失败: $e');
      return null;
    }
  }

  /// ===========================
  /// Asset / Network -> Uint8List
  /// ===========================
  static Future<Uint8List?> assetToBytes(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Asset 转 Uint8List 失败: $e');
      return null;
    }
  }

  static Future<Uint8List?> networkToBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (e) {
      debugPrint('Network 转 Uint8List 失败: $e');
    }
    return null;
  }

  /// ===========================
  /// 保存图片
  /// ===========================
  static Future<String?> saveToCache(File file, {String? fileName}) async {
    try {
      final dir = await getTemporaryDirectory();
      final name = fileName ?? '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final saved = await file.copy('${dir.path}/$name');
      return saved.path;
    } catch (e) {
      debugPrint('保存图片失败: $e');
      return null;
    }
  }

  static Future<String?> saveToDocuments(File file, {String? fileName}) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final name = fileName ?? '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final saved = await file.copy('${dir.path}/$name');
      return saved.path;
    } catch (e) {
      debugPrint('保存图片失败: $e');
      return null;
    }
  }

  /// ===========================
  /// 获取图片信息
  /// ===========================
  static Future<Size?> getImageSize(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);
      return Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      );
    } catch (e) {
      LoggerHelper.d('获取图片尺寸失败: $e');
      return null;
    }
  }

  /// ===========================
  /// 截图 Widget
  /// ===========================
  static Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('截图失败: $e');
      return null;
    }
  }

  /// 拍照或从相册选择图片，并返回图片的本地路径。
  ///
  /// 这个方法会根据 [source] 来决定是拍照还是从相册选择图片。
  /// 如果选择或拍照失败，返回 `null`。
  ///
  /// [source]：选择图片的来源，默认为 [ImageSource.gallery]。
  ///   - [ImageSource.camera]：拍照获取图片
  ///   - [ImageSource.gallery]：从相册选择图片
  ///
  /// [imageQuality]：可选参数，用于压缩图片质量，取值范围 0~100。
  ///   - 值越小，图片质量越低，文件越小
  ///   - 默认为 null，表示不压缩
  ///
  /// 返回值：[String]?，图片的本地路径，如果选择失败或取消操作，返回 `null`。
  static Future<String?> pickImagePath({
    ImageSource source = ImageSource.gallery,
    int? imageQuality,
  }) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );

    return pickedFile?.path;
  }

}
