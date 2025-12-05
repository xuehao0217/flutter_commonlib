import 'dart:async';
import 'package:flutter/material.dart';

/// ============================
/// KeyboardListenerWidget
/// ============================
/// 用于在 Widget 树中监听键盘状态变化（显示/隐藏）
/// 使用示例：
/// KeyboardListenerWidget(
///   onChange: (open, height) {
///     print("键盘状态：$open, 高度：$height");
///   },
///   child: YourPageWidget(),
/// );
class KeyboardListenerWidget extends StatefulWidget {
  /// 子 Widget
  final Widget child;

  /// 键盘状态变化回调
  final void Function(bool isOpen, double height)? onChange;

  const KeyboardListenerWidget({super.key, required this.child, this.onChange});

  @override
  State<KeyboardListenerWidget> createState() => _KeyboardListenerState();
}

class _KeyboardListenerState extends State<KeyboardListenerWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 添加系统窗口变化监听（如键盘弹出/收起）
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 移除监听
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 当系统窗口发生变化（键盘弹出/收起、屏幕旋转等）会回调
  @override
  void didChangeMetrics() {
    // 获取底部插入高度（键盘高度）
    final bottom = WidgetsBinding.instance.window.viewInsets.bottom;

    // 键盘是否打开
    final open = bottom > 0;

    // 回调给使用者
    widget.onChange?.call(open, bottom);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// ============================
/// KeyboardService
/// ============================
/// 全局键盘状态监听服务，支持多组件监听和防抖处理
/// 使用示例：
/*
KeyboardService.instance.addListener((open) {
  print("键盘: $open, 高度: $height");
});
*/
class KeyboardService with WidgetsBindingObserver {
  // 私有构造
  KeyboardService._() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// 单例
  static final KeyboardService instance = KeyboardService._();

  /// 注册的监听器列表
  final List<void Function(bool open)> _listeners = [];

  /// 防抖 Timer
  Timer? _debounceTimer;

  /// 上一次的键盘状态
  bool _lastOpen = false;

  /// 防抖间隔
  final Duration debounceDuration = const Duration(milliseconds: 100);

  /// 添加键盘监听
  void addListener(void Function(bool open) listener) {
    _listeners.add(listener);
  }

  /// 移除键盘监听
  void removeListener(void Function(bool open) listener) {
    _listeners.remove(listener);
  }

  /// 系统窗口发生变化时回调
  @override
  void didChangeMetrics() {
    final isOpen = WidgetsBinding.instance.window.viewInsets.bottom > 0;

    // 如果状态未变化，则不触发回调
    if (isOpen == _lastOpen) return;

    _lastOpen = isOpen;

    // 防抖处理
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, () {
      for (final listener in _listeners) {
        listener(isOpen);
      }
    });
  }
}

