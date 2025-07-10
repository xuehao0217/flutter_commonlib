import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:common_core/helpter/logger_helper.dart';
import 'package:common_core/net/dio_utils.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class DownloadViewModel extends BaseViewModel {
  var progress = 0.0.obs;
  var isDownloading = false.obs;

  Future<void> downloadApk(String url) async {
    // 权限申请
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      Get.snackbar("权限不足", "需要存储权限下载");
      return;
    }

    isDownloading.value = true;

    try {
      var cacheDirectory = await getApplicationCacheDirectory();
      String appName = "new.apk";
      String filePath = "${cacheDirectory.path}/$appName";

      var bool = await File(filePath).exists();

      await Dio().download(
        url,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
            LoggerHelper.d("下载进度: ${progress.value * 100}%");
          }
        },
      );

      isDownloading.value = false;
      Get.snackbar("下载完成", "点击安装", snackPosition: SnackPosition.BOTTOM);
      installApk(filePath);
    } catch (e) {
      isDownloading.value = false;
      Get.snackbar("下载失败", e.toString());
    }
  }


  /// 安装 APK（需要依赖 open_filex）
  void installApk(String path) {
    OpenFilex.open(path);
  }
}
