import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class BindShowOnScrollDemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<BindShowOnScrollDemoPage> {
  final scrollController = ScrollController();
  final showButton = true.obs;
  late final VoidCallback _unbind;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _unbind = scrollController.bindShowOnScroll(
        showButton,
        threshold: 15.0,
        delay: Duration(milliseconds: 150),
        onChange: (visible) {
          // 可以用 AnimatedOpacity / AnimatedSlide 实现平滑动画
          showButton.value = visible;
        },
      );
    });
  }

  @override
  void dispose() {
    _unbind();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: scrollController,
        itemCount: 50,
        itemBuilder: (_, index) => ListTile(title: Text("Item $index")),
      ),
      floatingActionButton: Obx(
        () => AnimatedOpacity(
          opacity: showButton.value ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
        ),
      ),
    );
  }
}

typedef ScrollShowCallback = void Function(bool visible);

extension ScrollControllerExt on ScrollController {
  /// 绑定显示/隐藏状态到滚动事件
  /// [target]：RxBool，用于控制UI显示/隐藏
  /// [onChange]：可选回调，用于动画处理
  /// [delay]：滚动停止后延迟多久自动显示
  /// [threshold]：滚动距离阈值，小幅滚动不触发
  VoidCallback bindShowOnScroll(
    RxBool target, {
    ScrollShowCallback? onChange,
    Duration delay = const Duration(milliseconds: 200),
    double threshold = 20.0,
  }) {
    Timer? _scrollStopTimer;
    double _lastOffset = position.pixels;

    void listener() {
      final offsetDiff = (position.pixels - _lastOffset).abs();
      if (offsetDiff < threshold) return;
      _lastOffset = position.pixels;

      final direction = position.userScrollDirection;
      bool visible = direction != ScrollDirection.reverse;

      // 调用回调或直接更新 RxBool
      if (onChange != null) {
        onChange(visible);
      } else {
        target.value = visible;
      }

      // 防抖：滚动停止后自动显示
      _scrollStopTimer?.cancel();
      _scrollStopTimer = Timer(delay, () {
        if (onChange != null) {
          onChange(true);
        } else {
          target.value = true;
        }
      });
    }

    addListener(listener);

    // 返回取消绑定函数
    return () {
      _scrollStopTimer?.cancel();
      removeListener(listener);
    };
  }
}
