import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/helpter/widget_ext_helper.dart';
import 'package:common_core/widget/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_commonlib/ui/vm/watermark_vm.dart';
import 'package:get/get.dart';

class WatermarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WatermarkPage();
}

class _WatermarkPage
    extends BaseVMStatefulWidget<WatermarkPage, WatermarkViewModel> {
  // 提取常量
  static const double _buttonHeight = 50.0;
  static const double _buttonRadius = 10.0;
  static const double _buttonElevation = 2.0;
  static const EdgeInsets _buttonPadding = EdgeInsets.only(
    bottom: 15,
    left: 15,
    right: 15,
  );
  static const TextStyle _buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
  static const TextStyle _watermarkTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 15,
  );

  @override
  Widget buildPageContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildImagePreview(),
          SizedBox(height: 15),
          Text(
            "拍照打水印成功后的预览：",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ).paddingSymmetric(horizontal: 16),
          Text(
            "生成的图片：",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ).paddingSymmetric(horizontal: 16),
          SizedBox(height: 10),
          ObxValue(
            (data) => data.value.isNotEmpty
                ? Image.file(File(data.value)).paddingSymmetric(horizontal: 16)
                : SizedBox.shrink(),
            viewModel.saveImagePath1,
          ),
          SizedBox(height: 15),
          _buildActionButtons(),
          ObxValue(
                (data) => data.value.isNotEmpty
                ? Image.file(File(data.value)).paddingSymmetric(horizontal: 16)
                : SizedBox.shrink(),
            viewModel.saveImagePath2,
          ),
        ],
      ),
    );
  }

  /// 构建图片预览区域
  Widget _buildImagePreview() {
    return Column(
      children: [
        Text(
          "拍照预览：",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ).paddingSymmetric(horizontal: 16),
        SizedBox(height: 15),
        Obx(() {
          if (viewModel.pickImage.value.isEmpty) return SizedBox();
          return RepaintBoundary(
            key: viewModel.globalKey,
            child: Stack(
              children: [
                Image.file(File(viewModel.pickImage.value)),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Text("我是水印", style: _watermarkTextStyle),
                ),
              ],
            ),
          );
        }),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  /// 构建操作按钮
  Widget _buildActionButtons() {
    return Obx(
      () => Column(
        children: [
          _buildButton(
            text: viewModel.isLoading.value ? "处理中..." : "拍照",
            onPressed: () => _handleTakePhoto(),
          ),
          _buildButton(
            text: viewModel.isLoading.value ? "处理中..." : "添加水印",
            onPressed: () => _handleAddWatermark(),
          ),
          _buildButton(
            text: viewModel.isLoading.value ? "处理中..." : "不显示照片打水印",
            onPressed: () => _handleAddWatermarkWithoutDisplay(),
          ),
          if (viewModel.hasImage)
            _buildButton(
              text: "清除图片",
              onPressed: () => _handleClearImage(),
              backgroundColor: Colors.red,
            ),
        ],
      ),
    );
  }

  /// 构建通用按钮
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return CommonButton(
      elevation: _buttonElevation,
      circular: _buttonRadius,
      backgroundColor: backgroundColor ?? Colors.blue,
      width: double.infinity,
      height: _buttonHeight,
      onPressed: onPressed,
      child: Text(
        text,
        style: _buttonTextStyle.copyWith(color: _buttonTextStyle.color),
      ),
    ).intoPadding(_buttonPadding);
  }

  /// 处理拍照
  Future<void> _handleTakePhoto() async {
    try {
      await viewModel.getImage();
    } catch (e) {
      _showErrorToast("拍照失败: $e");
    }
  }

  /// 处理添加水印
  void _handleAddWatermark() {
    if (viewModel.pickImage.value.isEmpty) {
      _showErrorToast("请先拍照");
      return;
    }

    try {
      viewModel.generateImage();
    } catch (e) {
      _showErrorToast("添加水印失败: $e");
    }
  }

  /// 处理不显示照片添加水印
  void _handleAddWatermarkWithoutDisplay() {
    try {
      viewModel.getImageToImage(context);
    } catch (e) {
      _showErrorToast("处理失败: $e");
    }
  }

  /// 处理清除图片
  void _handleClearImage() {
    viewModel.clearImage();
    _showErrorToast("图片已清除");
  }

  /// 显示错误提示
  void _showErrorToast(String message) {
    showToast(message);
  }

  @override
  WatermarkViewModel createViewModel() => WatermarkViewModel();

  @override
  void initData() {}
}
