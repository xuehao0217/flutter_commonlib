import 'package:flutter/material.dart';
import 'package:flutter_helper_kit/widgets/sharp_corners/sharp_border_radius.dart';
import 'package:flutter_helper_kit/widgets/sharp_corners/sharp_rectangle_border.dart';

/// 💡 Widget 扩展工具：
///
/// 统一封装点击、圆角、Padding、Container、布局包裹等常用修饰。
///
/// 支持链式写法：
/// ```dart
/// Text("Hello")
///   .withPadding(const EdgeInsets.all(8))
///   .withClipRRect(12)
///   .withInkWell(onTap: () => print("Tapped"))
///   .withContainer(color: Colors.blue)
///   .withCenter();
/// ```
extension WidgetExt on Widget {
  // --------------------
  // 🎯 点击相关
  // --------------------

  /// 🖱️ 添加点击事件（支持防抖与空安全）
  ///
  /// [enable] 控制是否启用点击
  /// [throttle] 限制两次点击最短间隔
  Widget withClick(
      VoidCallback? onTap, {
        bool enable = true,
        Duration throttle = const Duration(milliseconds: 300),
      }) {
    VoidCallback? effectiveTap;
    if (enable && onTap != null) {
      DateTime? _lastTap;
      effectiveTap = () {
        final now = DateTime.now();
        if (_lastTap == null ||
            now.difference(_lastTap!) > throttle) {
          _lastTap = now;
          onTap();
        }
      };
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: effectiveTap,
      child: this,
    );
  }

  /// 🌊 InkWell 水波纹点击（支持圆角与自定义颜色）
  Widget withInkWell({
    required VoidCallback? onTap,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: this,
    );
  }


  /// 🖱️ 点击事件，可传入 BuildContext，并复用原有防抖逻辑
  Widget clickWithContext(void Function(BuildContext context) onTap, {
    bool enable = true,
    Duration throttle = const Duration(milliseconds: 300),
  }) {
    return Builder(
      builder: (context) {
        return this.withClick(
              () => onTap(context), // 复用原来的防抖逻辑
          enable: enable,
          throttle: throttle,
        );
      },
    );
  }

  // --------------------
  // 🧱 布局与样式
  // --------------------

  /// 📦 包裹 Container（自动忽略空参数，避免冗余）
  Widget withContainer({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
  }) {
    assert(color == null || decoration == null,
    'color 与 decoration 不能同时使用');
    if (alignment == null &&
        padding == null &&
        color == null &&
        decoration == null &&
        width == null &&
        height == null &&
        margin == null &&
        transform == null) return this;
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      margin: margin,
      transform: transform,
      child: this,
    );
  }

  /// 📏 添加统一的 Padding
  Widget withPadding(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);

  /// 📐 横向内边距
  Widget withHorizontalPadding(double padding) =>
      withPadding(EdgeInsets.symmetric(horizontal: padding));

  /// 📏 纵向内边距
  Widget withVerticalPadding(double padding) =>
      withPadding(EdgeInsets.symmetric(vertical: padding));

  /// 🎯 居中或对齐
  Widget withAlign([AlignmentGeometry alignment = Alignment.center]) =>
      Align(alignment: alignment, child: this);

  Widget withCenter() => Center(child: this);

  /// 🛡️ 添加 SafeArea 包裹   top 是否避开顶部状态栏 bottom 是否避开底部系统区
  Widget withSafeArea({bool top = true, bool bottom = true}) =>
      SafeArea(top: top, bottom: bottom, child: this);

  // --------------------
  // 📐 尺寸与布局
  // --------------------

  /// ⬛ Expanded 包裹
  Widget withExpanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// 🟩 Flexible 包裹
  Widget withFlexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  /// ✂️ 圆角裁剪
  Widget withClipRRect(double radius) =>
      ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);

  /// ⚪ 椭圆裁剪
  Widget withClipOval() => ClipOval(child: this);

  /// 📏 固定宽高
  Widget withSizedBox({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);

  /// 🧱 拉伸占满父容器
  Widget withSizedBoxExpand() => SizedBox.expand(child: this);

  /// ⚖️ 设置宽高比
  Widget withAspectRatio(double ratio) =>
      AspectRatio(aspectRatio: ratio, child: this);

  // --------------------
  // 🎨 自定义样式
  // --------------------

  /// 🟦 使用 SharpShape 实现直角裁剪与边框
  Widget withShapeClip({
    double radius = 0,
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    double? width,
    double? height,
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: SharpRectangleBorder(
          side: BorderSide(color: borderColor, width: borderWidth),
          borderRadius: SharpBorderRadius(cornerRadius: radius),
        ),
      ),
      child: this,
    );
  }

  // --------------------
  // 🧠 Context & Key
  // --------------------

  /// 🧠 传入 BuildContext（适合曝光埋点、Theme 获取等）
  Widget withContext(void Function(BuildContext context) onBuild) {
    return Builder(builder: (context) {
      onBuild(context);
      return this;
    });
  }

  /// 🔑 添加 Key
  Widget withKey(Key key) => KeyedSubtree(key: key, child: this);

  // --------------------
  // 📏 Intrinsic 尺寸
  // --------------------
  /// ⚠️ 慎用，性能开销大
  Widget withIntrinsicHeight() => IntrinsicHeight(child: this);
  /// ⚠️ 慎用，性能开销大
  Widget withIntrinsicWidth() => IntrinsicWidth(child: this);


  // --------------------
  // 👀 Visibility & Opacity
  // --------------------

  Widget withVisibility(bool visible) => visible ? this : const SizedBox.shrink();

  Widget withOpacity(double value) => Opacity(opacity: value, child: this);

  Widget withFittedBox({BoxFit fit = BoxFit.contain}) =>
      FittedBox(fit: fit, child: this);

}



// class StudyBuddyWidget extends StatelessWidget {
//   const StudyBuddyWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SPHelper.getTid().toWidget(
//       builder: (tid) {
//         if (tid != "10") return const SizedBox.shrink();
//
//         return const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Your StudyBuddy',
//               style: TextStyle(color: Color(0xFF222222), fontSize: 20),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Fast summary • report polish • solve all',
//               style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 14),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

extension FutureBuilderExt<T> on Future<T> {
  Widget toWidget({
    required Widget Function(T data) builder,
    Widget? loading,
    Widget? error,
    Widget? empty,
  }) {
    return FutureBuilder<T>(
      future: this,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading ?? const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return error ??
              Center(child: Text('Error: ${snapshot.error}'));
        }
        final data = snapshot.data;
        if (data == null) {
          return empty ?? const SizedBox.shrink();
        }
        return builder(data);
      },
    );
  }
}
