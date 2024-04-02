import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

/// https://juejin.cn/post/7103058155692621837
class ScrollviewObserverPage extends StatefulWidget {
  const ScrollviewObserverPage({Key? key}) : super(key: key);

  @override
  _ScrollviewObserverPageState createState() => _ScrollviewObserverPageState();
}

class _ScrollviewObserverPageState extends State<ScrollviewObserverPage> {
  @override
  Widget build(BuildContext context) {
    return ListViewObserver(
      child: _buildListView(),
      sliverListContexts: () {
        return [if (_sliverListViewContext != null) _sliverListViewContext!];
      },
      onObserveAll: (resultMap) {
        final model = resultMap[_sliverListViewContext];
        if (model == null) return;
        debugPrint('ScrollviewObserverPage visible -- ${model.visible}');
        debugPrint('ScrollviewObserverPage firstChild.index -- ${model.firstChild?.index}');
        debugPrint('ScrollviewObserverPage displaying -- ${model.displayingChildIndexList}');
      },
    );
  }

  BuildContext? _sliverListViewContext;
  ListView _buildListView() {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        // 在 builder 回调中，将 BuildContext 记录起来
        if (_sliverListViewContext != ctx) {
          _sliverListViewContext = ctx;
        }
        return Container(
          alignment: Alignment.center,
          color: Colors.green.withBlue((index + 1) * 100),
          height: (index + 1) * 20,
          child: Text('index==$index'),
        );
      },
      separatorBuilder: (ctx, index) {
        return Container(
          height: 15,
        );
      },
      itemCount: 50,
    );
  }
}
