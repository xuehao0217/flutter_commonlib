import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/base/mvvm/base_vm_stateless_widget.dart';
import 'package:common_core/common_core.dart';
import 'package:common_core/style/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/style/color.dart';
import 'package:flutter_commonlib/ui/vm/download_view_model.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/get_utils.dart';

class DownloadPage extends BaseVMStatelessWidget<DownloadViewModel> {
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Obx(() {
        return viewModel.isDownloading.value
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value:  viewModel.progress.value,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(getThemeData().primaryColor),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ).paddingSymmetric(horizontal: 16),
            SizedBox(height: 15),
            Text(
              "下载中 ${(viewModel.progress.value * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 16,
                color: getThemeData().primaryColor,)
            ),
          ],
        )
            : ElevatedButton(
          onPressed: () {
            viewModel.downloadApk("http://3g.163.com/links/4636");
          },
          child: Text("下载 APK"),
        );
      }),
    );
  }

  @override
  String setTitle() =>"Download";
  @override
  DownloadViewModel createViewModel() => DownloadViewModel();

  @override
  void initData() {}
}
