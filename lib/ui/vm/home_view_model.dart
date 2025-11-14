import 'dart:io';

import 'package:common_core/base/mvvm/base_view_model.dart';
import 'package:common_core/helpter/talker_helper.dart';
import 'package:common_core/net/dio_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/entity/home_banner_entity.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:path_provider/path_provider.dart';
import '../../api/http_api.dart';

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
    try {
      final cacheDir = await getTemporaryDirectory();
      int cacheSize = 0;
      await for (var entity in cacheDir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          cacheSize += await entity.length();
        }
      }
      return cacheSize ~/ (1024 * 1024);
    } catch (e) {
      debugPrint('Error calculating cache size: $e');
      return 0;
    }
  }


  Future<void> clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      await for (var entity in cacheDir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          await entity.delete();
        }
      }
       getCacheSizeAsync();
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }


  @override
  void onReady() {
    super.onReady();
    "onReady".logI(tag: "log");
  }
  @override
  void onInit() {
    super.onInit();
    "onInit".logI(tag: "log");
  }
}
