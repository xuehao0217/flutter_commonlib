import 'dart:ffi';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/entity/home_banner_entity.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api/http_api.dart';
import '../../base/mvvm/base_view_model.dart';
import '../../entity/home_list_entity.dart';
import '../../generated/assets.dart';
import '../../net/dio_utils.dart';
import '../../style/color.dart';
import '../../widget/common_widget.dart';
import '../../widget/text_style.dart';

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

  final controller = RefreshController(initialRefresh: true);
  void getHomeData({bool refresh = false}) {
    if (refresh) {
      page = 0;
    } else {
      page++;
    }
    requestNetwork<HomeListEntity>(Method.get, showLoading: true, url: '/article/list/$page/json', onSuccess: (data) {
      if (refresh) {
        homeDatas.value.clear();
        homeDatas.value = data!.datas;
        controller.refreshCompleted();
      } else {
        homeDatas.addAll(data!.datas);
        if (homeDatas.length > 90) {
          controller.loadComplete();
          controller.loadNoData();
        } else {
          controller.loadComplete();
        }
      }
    });
  }


  ///https://blog.csdn.net/LeftStrang/article/details/116354401
  var currentProgress = 0.0.obs;
  var total_obs = 0.obs;
  var received_obs = 0.obs;

  void downApkFunction(String apkUrl, String filePath) async {
    final status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      print('storage permission not granted');
    } else {
      await HttpUtils.instance.dio.download(apkUrl, filePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          ///当前下载的百分比例
          print("${(received / total * 100).toStringAsFixed(0)}%");
          // CircularProgressIndicator(value: currentProgress,) 进度 0-1
          total_obs.value = total;
          received_obs.value = received;
          currentProgress.value = (received / total * 100);

          if (received == total) {
            print("下载完成 ${filePath}");
            installApk(filePath);
          }
        }
      });
    }
  }

  void installApk(String path) {
    try {
      InstallPlugin.installApk(path).then((result) {
        print('install apk $result');
      }).catchError((error) {
        print('install apk error: $error');
      });
    } catch (e) {
      print('安装APK失败: $e');
    }
  }

  Future<String> getPhoneLocalPath() async {
    final directory = await getApplicationCacheDirectory();
    return directory!.path;
  }

  Future<void> showDownloadDialog() async {
    bool isforce = false; //是否强制更新
    var downloadUrl = "http://3g.163.com/links/4636";

    var isDownLoad = false.obs;
    String savePath = await getPhoneLocalPath();
    // String appName = "new_${ entity!.version!.replaceAll(".", "")}.apk";
    String appName = "new.apk";
    String filePath = "$savePath/$appName";
    SmartDialog.show(
      clickMaskDismiss: isforce,
      alignment: Alignment.center,
      builder: (_) => Obx(() => ConstraintLayout(
            height: wrapContent,
            children: [
              Image.asset(R.assetsIcUpgrade).applyConstraint(
                id: cId("iv_bg"),
                width: matchParent,
                height: 454,
                top: parent.top,
              ),
              Icon(Icons.clear,color: Colors.white,).click(() {
                SmartDialog.dismiss();
              }).applyConstraint(
                  size: 24,
                  topRightTo: cId("iv_bg"),
                  visibility: isforce ? gone : visible,
                  margin: EdgeInsets.only(top: 12, right: 42)),
              CommonButton(
                width: 166,
                height: 48,
                onPressed: () async {
                  var bool = await File(filePath).exists();
                  if (bool) {
                    installApk(filePath);
                  } else {
                    downApkFunction(downloadUrl, filePath);
                    isDownLoad.value = true;
                  }
                },
                circular: 6,
                backgroundColor: cl_203295,
                child: XText(currentProgress.value == 100
                      ? "立即安装"
                      : !isDownLoad.value
                          ? "有新版本啦"
                          : "正在下载",
                  textColor: Colors.white,
                  fontSize: 16,
                ),
              ).applyConstraint(
                  bottomCenterTo: parent, margin: EdgeInsets.only(bottom: 44)),
              XText("建议在wifi环境进行下载",
              ).applyConstraint(
                  bottomCenterTo: parent, margin: EdgeInsets.only(bottom: 16)),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      XText("有新版本啦",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        width: 8,
                      ),
                      XText("新版本",
                        textColor: cl_203295,
                        fontSize: 12,
                      )
                          .intoCenter()
                          .intoContainer(
                              width: 42, height: 20, color: cl_1A203295)
                          .intoClipRRect(5),
                    ],
                  ),
                  Container(
                    height: 26,
                  ),
                  SingleChildScrollView(
                    child: Text(
                      "更新了啥啥啥",
                      style: TextStyle(fontSize: 14),
                    ).intoContainer(height: 80, width: 296),
                  ),
                ],
              ).applyConstraint(
                  visibility: !isDownLoad.value ? visible : gone,
                  topCenterTo: parent,
                  margin: EdgeInsets.only(top: 190)),
              Column(
                children: [
                  XText("正在下载更新包",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  Container(
                    height: 20,
                  ),
                  XText("${currentProgress.toStringAsFixed(0)}%",
                    fontSize: 20,
                    textColor: cl_203295,
                    fontWeight: FontWeight.w600,
                  ),
                  Container(
                    height: 20,
                  ),
                  LinearProgressIndicator(
                    value: currentProgress.value / 100,
                    backgroundColor: cl_D9D9D9,
                    valueColor: AlwaysStoppedAnimation<Color>(cl_203295),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ).intoContainer(width: 296)
                ],
              ).applyConstraint(
                  visibility: isDownLoad.value ? visible : gone,
                  width: matchParent,
                  top: parent.top,
                  margin: EdgeInsets.only(top: 190)),
            ],
          )),
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
