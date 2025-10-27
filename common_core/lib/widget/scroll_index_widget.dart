import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///https://juejin.cn/post/7348247657284517938
///貌似只能对ListView.builder 准确
typedef ViewPortCallback = void Function(int firstIndex, int lastIndex);

class ScrollIndexWidget extends StatelessWidget {
  final ScrollView child;
  final ViewPortCallback callback;

  const ScrollIndexWidget(
      {Key? key, required this.child, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener(child: child, onNotification: _onNotification);
  }

  bool _onNotification(ScrollNotification notice) {
    final SliverMultiBoxAdaptorElement sliverMultiBoxAdaptorElement =
    findSliverMultiBoxAdaptorElement(notice.context! as Element)!;

    final viewportDimension = notice.metrics.viewportDimension;

    int firstIndex = 0;
    int lastIndex = 0;
    void onVisitChildren(Element element) {
      final SliverMultiBoxAdaptorParentData oldParentData =
      element.renderObject?.parentData as SliverMultiBoxAdaptorParentData;
      double layoutOffset = oldParentData.layoutOffset!;
      double pixels = notice.metrics.pixels;
      double all = pixels + viewportDimension;
      if (layoutOffset >= pixels) {
        ///first和last是不同item
        firstIndex = min(firstIndex, oldParentData.index! - 1);
        if (layoutOffset <= all) {
          lastIndex = max(lastIndex, oldParentData.index!);
        }
        firstIndex = max(firstIndex, 0);
      } else {
        ///first和last是同一个item
        lastIndex = firstIndex = oldParentData.index!;
      }
    }

    sliverMultiBoxAdaptorElement.visitChildren(onVisitChildren);

    callback(
      firstIndex,
      lastIndex,
    );

    return false;
  }

  SliverMultiBoxAdaptorElement? findSliverMultiBoxAdaptorElement(
      Element element) {
    if (element is SliverMultiBoxAdaptorElement) {
      return element;
    }
    SliverMultiBoxAdaptorElement? target;
    element.visitChildElements((child) {
      target = findSliverMultiBoxAdaptorElement(child);
    });
    return target;
  }
}


/// 通用可见索引统计组件
/// 支持 ListView.separated，自动过滤 separator
// class ScrollIndexWidget extends StatelessWidget {
//   final ScrollView child;
//   final ViewPortCallback callback;
//
//   /// header 个数
//   final int headerCount;
//
//   const ScrollIndexWidget({
//     Key? key,
//     required this.child,
//     required this.callback,
//     this.headerCount = 0, // header 默认 0 个
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return NotificationListener<ScrollNotification>(
//       child: child,
//       onNotification: _onNotification,
//     );
//   }
//
//   bool _onNotification(ScrollNotification notice) {
//     final sliver = findSliverMultiBoxAdaptorElement(notice.context! as Element);
//     if (sliver == null) return false;
//
//     final viewportDimension = notice.metrics.viewportDimension;
//     final pixels = notice.metrics.pixels;
//
//     int? firstIndex;
//     int? lastIndex;
//
//     sliver.visitChildren((child) {
//       final parentData =
//       child.renderObject?.parentData as SliverMultiBoxAdaptorParentData?;
//       if (parentData?.layoutOffset == null) return;
//
//       final layoutOffset = parentData!.layoutOffset!;
//       final index = parentData.index!;
//
//       final visibleEnd = pixels + viewportDimension;
//
//       // 过滤 separator: ListView.separated 偶数 index 对应 item
//       final itemIndex = (index - headerCount) ~/ 2;
//
//       if (itemIndex < 0) return;
//
//       // 判断是否可见
//       if (layoutOffset + 1 >= pixels && layoutOffset <= visibleEnd) {
//         firstIndex ??= itemIndex;
//         lastIndex = itemIndex;
//       }
//     });
//
//     if (firstIndex != null && lastIndex != null) {
//       callback(firstIndex, lastIndex);
//     }
//
//     return false;
//   }
//
//   SliverMultiBoxAdaptorElement? findSliverMultiBoxAdaptorElement(Element element) {
//     if (element is SliverMultiBoxAdaptorElement) return element;
//     SliverMultiBoxAdaptorElement? target;
//     element.visitChildElements((child) {
//       target ??= findSliverMultiBoxAdaptorElement(child);
//     });
//     return target;
//   }
// }
