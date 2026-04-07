import 'dart:io';

import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/ui/vm/watermark_vm.dart';
import 'package:get/get.dart';

class WatermarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WatermarkPage();
}

class _WatermarkPage
    extends BaseVMStatefulWidget<WatermarkPage, WatermarkViewModel> {
  static TextStyle _watermarkOverlayStyle(ColorScheme cs) {
    return TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.55),
          blurRadius: 6,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '拍照后在预览图上叠加水印，可导出带水印图片；也可走后台拍照加水印流程。',
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 22),
          _sectionHeader(context, cs, Icons.photo_camera_outlined, '拍照预览'),
          const SizedBox(height: 10),
          _buildImagePreview(context, cs),
          const SizedBox(height: 22),
          _sectionHeader(
            context,
            cs,
            Icons.branding_watermark_outlined,
            '导出结果',
          ),
          const SizedBox(height: 10),
          Text(
            '带水印导出（显示预览）',
            style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          ObxValue(
            (data) => data.value.isNotEmpty
                ? _resultImageCard(context, cs, File(data.value))
                : _emptyResultHint(cs, '尚未生成'),
            viewModel.saveImagePath1,
          ),
          const SizedBox(height: 18),
          Text(
            '后台拍照加水印（不经过上方预览）',
            style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          ObxValue(
            (data) => data.value.isNotEmpty
                ? _resultImageCard(context, cs, File(data.value))
                : _emptyResultHint(cs, '尚未生成'),
            viewModel.saveImagePath2,
          ),
          const SizedBox(height: 20),
          _buildActionButtons(context, cs),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    ColorScheme cs,
    IconData icon,
    String label,
  ) {
    return Row(
      children: [
        Icon(icon, size: 22, color: cs.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _emptyResultHint(ColorScheme cs, String text) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: cs.onSurfaceVariant),
      ),
    );
  }

  Widget _resultImageCard(BuildContext context, ColorScheme cs, File file) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, ColorScheme cs) {
    return Obx(() {
      if (viewModel.pickImage.value.isEmpty) {
        return Container(
          height: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                size: 40,
                color: cs.outline,
              ),
              const SizedBox(height: 10),
              Text(
                '点击下方「拍照」开始',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      }

      return Material(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: RepaintBoundary(
          key: viewModel.globalKey,
          child: Stack(
            children: [
              Image.file(
                File(viewModel.pickImage.value),
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Text(
                  '我是水印',
                  style: _watermarkOverlayStyle(cs),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme cs) {
    return Obx(
      () {
        final busy = viewModel.isLoading.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: busy ? null : () => _handleTakePhoto(),
              icon: busy
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.onPrimary,
                      ),
                    )
                  : const Icon(Icons.camera_alt_rounded),
              label: Text(busy ? '处理中…' : '拍照'),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: busy ? null : () => _handleAddWatermark(),
              icon: const Icon(Icons.layers_outlined),
              label: Text(busy ? '处理中…' : '添加水印并保存'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: busy ? null : () => _handleAddWatermarkWithoutDisplay(),
              icon: const Icon(Icons.offline_bolt_outlined),
              label: Text(busy ? '处理中…' : '不显示预览 · 直接加水印'),
            ),
            if (viewModel.hasImage) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: cs.error,
                  side: BorderSide(color: cs.error.withValues(alpha: 0.6)),
                ),
                onPressed: busy ? null : () => _handleClearImage(),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('清除预览与已导出图'),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _handleTakePhoto() async {
    try {
      await viewModel.getImage();
    } catch (e) {
      _showErrorToast('拍照失败: $e');
    }
  }

  void _handleAddWatermark() {
    if (viewModel.pickImage.value.isEmpty) {
      _showErrorToast('请先拍照');
      return;
    }

    try {
      viewModel.generateImage();
    } catch (e) {
      _showErrorToast('添加水印失败: $e');
    }
  }

  void _handleAddWatermarkWithoutDisplay() {
    try {
      viewModel.getImageToImage(context);
    } catch (e) {
      _showErrorToast('处理失败: $e');
    }
  }

  void _handleClearImage() {
    viewModel.clearImage();
    _showErrorToast('图片已清除');
  }

  void _showErrorToast(String message) {
    showToast(message);
  }

  @override
  WatermarkViewModel createViewModel() => WatermarkViewModel();

  @override
  void initData() {}
}
