import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';


// late final VoidCallback _unbind;
// @override
// void initState() {
//   super.initState();
//   _unbind = scrollController.bindShowOnScroll(show);
// }
//
// @override
// void dispose() {
//   _unbind(); // 取消 Timer 和 listener
//   scrollController.dispose();
//   super.dispose();
// }
extension ScrollControllerExt on ScrollController {
  /// 返回一个取消绑定的方法
  VoidCallback bindShowOnScroll(
      RxBool target, {
        Duration delay = const Duration(milliseconds: 200),
      }) {
    Timer? _scrollStopTimer;

    void listener() {
      final direction = position.userScrollDirection;

      if (direction == ScrollDirection.reverse) {
        target.value = false;
      } else if (direction == ScrollDirection.forward) {
        target.value = true;
      }

      _scrollStopTimer?.cancel();
      _scrollStopTimer = Timer(delay, () {
        target.value = true;
      });
    }

    addListener(listener);

    // 返回取消函数
    return () {
      _scrollStopTimer?.cancel();
      removeListener(listener);
    };
  }
}