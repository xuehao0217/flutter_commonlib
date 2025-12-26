import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class SizeObserver extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onChange;

  const SizeObserver({
    super.key,
    required this.onChange,
    required Widget child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _SizeObserverRenderObject(onChange);
  }

  @override
  void updateRenderObject(
      BuildContext context, _SizeObserverRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}

class _SizeObserverRenderObject extends RenderProxyBox {
  ValueChanged<Size> onChange;
  Size? _oldSize;

  _SizeObserverRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      _oldSize = size;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onChange(size);
      });
    }
  }
}
