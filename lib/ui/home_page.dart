import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/helpter/get_ext_helper.dart';
import 'package:common_core/helpter/notification_helper.dart';
import 'package:common_core/helpter/widget_ext_helper.dart';
import 'package:common_core/style/theme.dart';
import 'package:common_core/widget/common_widget.dart';
import 'package:common_core/widget/webview/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_commonlib/ui/permission_widget.dart';
import 'package:flutter_helper_kit/extensions/context/build_context_extension.dart';
import 'package:get/get.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import '../generated/assets.dart';
import '../router/router_config.dart';
import 'vm/home_view_model.dart';
import 'package:permission_handler/permission_handler.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends BaseVMStatefulWidget<HomePage, HomeViewModel> {
  @override
  void onPageShow() {
    super.onPageShow();
    viewModel.getCacheSizeAsync();
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

  @override
  Widget buildPageContent(BuildContext context) {
    return ListView(
      children: [
        ChuckerFlutter.chuckerButton.intoPadding(EdgeInsets.all(15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: context.primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () {
            Get.changeThemeMode(
              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
            );
          },
          child: Text(
            "主题切换 当前:${Get.isDarkMode ? "暗色" : "亮色"}",
            style: TextStyle(
              color: BuildContextExension(context).textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: context.primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () {
            Get2Named(RouterRULConfig.list_refensh);
          },
          child: Text(
            "下拉刷新使用",
            style: TextStyle(
              color: BuildContextExension(context).textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        // CommonButton(
        //   elevation: 2,
        //   circular: 10,
        //   backgroundColor: context.primaryColor,
        //   width: double.infinity,
        //   height: 50,
        //   onPressed: () {
        //
        //   },
        //   child: Text(
        //     "Permission 使用",
        //     style: TextStyle(
        //       color: getThemeTextTheme().bodyMedium?.color,
        //       fontSize: 16,
        //     ),
        //   ),
        // ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
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
        // CommonButton(
        //   elevation: 2,
        //   circular: 10,
        //   backgroundColor: context.primaryColor,
        //   width: double.infinity,
        //   height: 50,
        //   onPressed: () {
        //     Get2Named(RouterRULConfig.single_child_scroll);
        //   },
        //   child: Text(
        //     "SingleChildScrollViewPage 使用",
        //     style: TextStyle(
        //       color: getThemeTextTheme().bodyMedium?.color,
        //       fontSize: 16,
        //     ),
        //   ),
        // ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: context.primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            Get2Named(RouterRULConfig.watermark);
          },
          child: Text(
            "拍照打水印",
            style: TextStyle(
              color: getThemeTextTheme().bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: context.primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            Get2Named(
              RouterRULConfig.webview,
              parameters: {
                WebViewPage.Url: "https://www.baidu.com?hideTitle=1",
                WebViewPage.Title: "Title",
              },
            );
            // Get2Named(RouterRULConfig.webview,arguments: "https://pub.dev/packages/webview_flutter");
          },
          child: Text(
            "WebView",
            style: TextStyle(
              color: getThemeTextTheme().bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: context.primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: ()  {
           Get2Named(RouterRULConfig.download);
          },
          child: Text(
            "版本更新",
            style: TextStyle(
              color: getThemeTextTheme().bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: context.primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: () async {
            await NotificationHelper.instance.showLocalNotification("title", "message");
          },
          child: Text(
            "推送",
            style: TextStyle(
              color: getThemeTextTheme().bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: context.primaryColor,
          width: double.infinity,
          height: 50,
          onPressed: ()  {
            Get2Named(RouterRULConfig.flutter_helper_kit);
          },
          child: Text(
            "Flutter Helper Kit",
            style: TextStyle(
              color: getThemeTextTheme().bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),


        Obx(() => CommonButton(
            elevation: 2,
            circular: 10,
            backgroundColor: context.primaryColor,
            width: double.infinity,
            height: 50,
            onPressed: () async {
              viewModel.clearCache();
            },
            child: Text(
              "当前缓存 ${viewModel.cacheSize}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
        ),
        Hero(
          tag: "Hero",
          child: Image.asset(R.assetsIcLogo, width: 200, height: 100).click(() {
            Get2Named(RouterRULConfig.blurry);
          }),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),
      ],
    );
  }
}
