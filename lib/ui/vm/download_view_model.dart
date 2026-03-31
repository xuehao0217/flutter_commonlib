import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:common_core/helpter/logger_helper.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class DownloadViewModel extends BaseViewModel {
  var progress = 0.0.obs;
  var isDownloading = false.obs;

  /// 下载 APK 并调起安装。
  ///
  /// - 文件写在应用 [getApplicationCacheDirectory]，**不需要**读写外部存储权限。
  /// - Android 8+ 安装 APK 需 [Permission.requestInstallPackages]（Manifest 已声明）。
  Future<void> downloadApk(String url) async {
    if (kIsWeb) {
      Get.snackbar('提示', '请在 Android 真机或模拟器上使用版本更新');
      return;
    }
    if (!Platform.isAndroid) {
      Get.snackbar('提示', 'APK 下载与安装仅适用于 Android 设备');
      return;
    }

    final install = await Permission.requestInstallPackages.request();
    if (!install.isGranted) {
      Get.snackbar(
        '需要安装权限',
        install.isPermanentlyDenied
            ? '请在系统设置中为本应用开启「安装未知应用」'
            : '安装 APK 需要授权「安装未知应用」',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        mainButton: install.isPermanentlyDenied
            ? TextButton(
                onPressed: openAppSettings,
                child: const Text('去设置'),
              )
            : null,
      );
      return;
    }

    isDownloading.value = true;
    progress.value = 0;

    try {
      final cacheDirectory = await getApplicationCacheDirectory();
      const appName = 'update_demo.apk';
      final filePath = '${cacheDirectory.path}/$appName';

      if (await File(filePath).exists()) {
        await File(filePath).delete();
      }

      await Dio().download(
        url,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
            LoggerHelper.d('下载进度: ${(progress.value * 100).toStringAsFixed(1)}%');
          }
        },
      );

      isDownloading.value = false;
      Get.snackbar(
        '下载完成',
        '正在打开安装界面…',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      installApk(filePath);
    } catch (e) {
      isDownloading.value = false;
      Get.snackbar('下载失败', e.toString());
    }
  }

  void installApk(String path) {
    OpenFilex.open(path);
  }
}
