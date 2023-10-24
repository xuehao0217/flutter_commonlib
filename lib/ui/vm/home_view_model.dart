import 'dart:ffi';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/entity/home_banner_entity.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/http_api.dart';
import '../../base/mvvm/base_view_model.dart';
import '../../entity/home_list_entity.dart';
import '../../net/dio_utils.dart';

class HomeViewModel extends BaseViewModel {
  var banner = <HomeBannerEntity>[].obs;

  var rxBanner = Rx<List<HomeBannerEntity>?>(null);

  void getBannerData() {
    asyncRequestNetwork<List<HomeBannerEntity>>(Method.get,
        showLoading: true, url: HttpApi.banner, onSuccess: (data) {
      banner.value = data!;
      rxBanner.value = data;
    });
  }

  var page = 0;
  var homeDatas = <HomeListDatas>[].obs;

  void getHomeData(VoidCallback? onfinally, {bool refresh = false}) {
    if (refresh) {
      page = 0;
    } else {
      page++;
    }
    requestNetwork<HomeListEntity>(Method.get,
        showLoading: true, url: '/article/list/$page/json', onSuccess: (data) {
      if (refresh) {
        homeDatas.value.clear();
        homeDatas.value = data!.datas;
      } else {
        homeDatas.value.addAll(data!.datas);
      }
    }, onfinally: onfinally);
  }


  void downApkFunction(String apkUrl) async {
    final status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      print('storage permission not granted');
    } else {
      String savePath = await getPhoneLocalPath();
      String appName = "dw.apk";
      await HttpUtils.instance.dio.download(apkUrl, "$savePath$appName",
          onReceiveProgress: (received, total) {
        if (total != -1) {
          ///当前下载的百分比例
          print("${(received / total * 100).toStringAsFixed(0)}%");
          // CircularProgressIndicator(value: currentProgress,) 进度 0-1
          var currentProgress = received / total;
          if (received == total) {
            print("下载完成 ${savePath}");
          }
        }
      });
    }
  }

  Future<String> getPhoneLocalPath() async {
    final directory = await getApplicationCacheDirectory();
    return directory!.path;
  }
}
