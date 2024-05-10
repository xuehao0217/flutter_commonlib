import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_commonlib/base/mvvm/base_stateful_widget.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_commonlib/router/router_config.dart';
import 'package:flutter_commonlib/widget/common_list_view.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../generated/assets.dart';
import '../helpter/status_utils.dart';
import '../style/theme.dart';
import '../widget/common_widget.dart';
import '../widget/input_widget.dart';
import 'cameras_page.dart';
import 'vm/home_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends BaseStatefulWidget<HomePage, HomeViewModel> {
  @override
  void onPageShow() {
    super.onPageShow();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    viewModel.getCacheSizeAsync();
    // });
  }

  @override
  void initData() {}

  @override
  bool showTitleBar() => false;

  @override
  createViewModel() => HomeViewModel();

  @override
  void dispose() {
    super.dispose();
  }

  var imageList = [
    "https://picx.zhimg.com/v2-3b4fc7e3a1195a081d0259246c38debc_720w.jpg?source=172ae18b",
    "https://static-cse.canva.cn/blob/239388/e1604019539295.jpg",
    "https://p.upyun.com/demo/webp/jpg/0.jpg"
  ];

  @override
  Widget buildPageContent(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 15,
        ),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () {
            //手动切换主题
            Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
          },
          child: const Text(
            "主题切换",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () {
            changeStatusBarColor(
                color: Colors.orange, iconBrightness: Brightness.dark);
          },
          child: const Text(
            "修改状态栏颜色",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () {
            Get2Named(RouterRULConfig.list_refensh);
          },
          child: const Text(
            "ListRefensh 使用",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () {
            Get2Named(RouterRULConfig.permission);
          },
          child: const Text(
            "Permission 使用",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            Get2Named(RouterRULConfig.two_level);
          },
          child: Text(
            "二楼使用",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        // CommonButton(
        //   elevation: 2,
        //   circular: 10,
        //   backgroundColor: Colors.blue,
        //   width: double.infinity,
        //   height: 50,
        //   onPressed: () async {
        //     WidgetsFlutterBinding.ensureInitialized();
        //     final cameras = await availableCameras();
        //     final firstCamera = cameras.first;
        //     Get.to(TakePictureScreen(camera: firstCamera));
        //   },
        //   child: const Text(
        //     "Camera 使用",
        //     style: TextStyle(color: Colors.white, fontSize: 16),
        //   ),
        // ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () {
            Get2Named(RouterRULConfig.single_child_scroll);
          },
          child: const Text(
            "SingleChildScrollViewPage 使用",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            Get2Named(RouterRULConfig.watermark);
          },
          child: const Text(
            "拍照打水印",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        Hero(
          tag: "Hero",
          child: Image.asset(R.assetsIcLogo,width: 200,height: 100,).click(() {
            Get2Named(RouterRULConfig.blurry);
          }),
        ),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            viewModel.showDownloadDialog();
          },
          child: const Text(
            "版本更新",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            Get2Named(RouterRULConfig.loading_state);
          },
          child: const Text(
            "Loading State",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            Get2Named(RouterRULConfig.scroll_index);
          },
          child: const Text(
            "监听列表滑动",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: getThemeData().primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            Get2Named(RouterRULConfig.scrollview_observe);
          },
          child: const Text(
            "监听列表滑动 ListViewObserver",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        Obx(() => CommonButton(
              elevation: 2,
              circular: 10,
              backgroundColor: getThemeData().primaryColor,
              width: double.infinity,
              height: 50,
              onPressed: () async {
                viewModel.clearCache();
              },
              child: Text(
                "当前缓存 ${viewModel.cacheSize}",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ).intoPadding(
                const EdgeInsets.only(bottom: 15, left: 15, right: 15))),

        Swiper(
          viewportFraction: 0.8,
          scale: 0.9,
          itemBuilder: (BuildContext context, int index) {
            return CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: imageList[index],
            ).intoClipRRect(16);
          },
          itemCount: imageList.length,
          pagination: SwiperPagination(),
          control: SwiperControl(),
        ).intoContainer(width: double.infinity, height: 250),
      ],
    );
  }
}
