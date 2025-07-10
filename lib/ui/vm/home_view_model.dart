import 'dart:io';

import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:common_core/helpter/widget_ext_helper.dart';
import 'package:common_core/net/dio_utils.dart';
import 'package:common_core/widget/common_widget.dart';
import 'package:common_core/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/entity/home_banner_entity.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/http_api.dart';
import '../../generated/assets.dart';
import '../../style/color.dart';

class HomeViewModel extends BaseViewModel {
  var banner = <HomeBannerData>[].obs;
  var rxBanner = Rx<List<HomeBannerData>?>(null);

  void getAsyncBannerData() {
    asyncRequestNetwork<List<HomeBannerData>>(
      Method.get,
      HttpApi.banner,
      onSuccess: (data) {
        print("object===${data.length}");
      },
    );
  }

  void getRequestBannerData() {
    asyncRequestNetwork<List<HomeBannerData>>(
      Method.get,
      HttpApi.banner,
      onSuccess: (data) {
        print("object===${data}");
      },
    );
  }



  var cacheSize = "0M".obs;

  void getCacheSizeAsync() {
    _getCacheSize().then((value) => {cacheSize.value = "${value}M"});
  }

  Future<int> _getCacheSize() async {
    Directory cacheDir = await getTemporaryDirectory();
    int cacheSize = 0;
    try {
      List<FileSystemEntity> fileList = cacheDir.listSync(recursive: true);
      for (FileSystemEntity file in fileList) {
        if (file is File) {
          cacheSize += file.lengthSync();
          debugPrint(file.path);
        }
      }
    } catch (e) {
      print('Error calculating cache size: $e');
    }
    return cacheSize ~/ (1024 * 1024);
  }

  void clearCache() async {
    Directory cacheDir = await getTemporaryDirectory();
    // 列出目录中的文件
    List<FileSystemEntity> files = cacheDir.listSync(recursive: true);
    for (FileSystemEntity file in files) {
      if (file is File) {
        // 删除文件
        file.deleteSync();
      }
    }
    getCacheSizeAsync();
  }
}
