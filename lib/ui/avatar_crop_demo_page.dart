import 'dart:io';

import 'package:common_core/base/base_stateful_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// 从相册选图 → 正方形/圆形裁剪 → 回到本页展示裁剪结果（仅移动端）。
class AvatarCropDemoPage extends StatefulWidget {
  const AvatarCropDemoPage({super.key});

  @override
  State<StatefulWidget> createState() => _AvatarCropDemoPageState();
}

class _AvatarCropDemoPageState extends BaseStatefulWidget<AvatarCropDemoPage> {
  final ImagePicker _picker = ImagePicker();
  File? _avatarFile;

  @override
  String setTitle() => '头像裁剪';

  Future<void> _pickAndCrop() async {
    if (kIsWeb) {
      SmartDialog.showToast('请在 Android / iOS 真机或模拟器上试用');
      return;
    }

    try {
      final xfile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
      );
      if (!mounted) return;
      if (xfile == null) {
        SmartDialog.showToast('已取消选图');
        return;
      }

      final cs = Theme.of(context).colorScheme;
      final cropped = await ImageCropper().cropImage(
        sourcePath: xfile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '裁剪头像',
            toolbarColor: cs.primary,
            toolbarWidgetColor: cs.onPrimary,
            backgroundColor: cs.surface,
            activeControlsWidgetColor: cs.primary,
            dimmedLayerColor: cs.shadow.withValues(alpha: 0.52),
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: const [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            title: '裁剪头像',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: const [CropAspectRatioPreset.square],
          ),
        ],
      );
      if (!mounted) return;
      if (cropped == null) {
        SmartDialog.showToast('已取消裁剪');
        return;
      }
      setState(() {
        _avatarFile = File(cropped.path);
      });
      SmartDialog.showToast('头像已更新');
    } catch (e, st) {
      debugPrint('AvatarCropDemo: $e\n$st');
      if (!mounted) return;
      SmartDialog.showToast('处理失败：$e');
    }
  }

  void _clear() {
    setState(() => _avatarFile = null);
    SmartDialog.showToast('已清除预览');
  }

  @override
  Widget buildPageContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      children: [
        Text(
          '从相册选择图片，在裁剪界面调整区域后保存，下方显示裁剪结果（圆形头像）。',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 28),
        Center(
          child: CircleAvatar(
            radius: 72,
            backgroundColor: cs.surfaceContainerHighest,
            foregroundImage:
                _avatarFile != null ? FileImage(_avatarFile!) : null,
            child: _avatarFile == null
                ? Icon(
                    Icons.person_outline_rounded,
                    size: 64,
                    color: cs.outline,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: _pickAndCrop,
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('选择并裁剪'),
        ),
        if (_avatarFile != null) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _clear,
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('清除预览'),
          ),
        ],
      ],
    );
  }
}
