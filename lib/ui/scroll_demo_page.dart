import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:common_core/helpter/scroll_controller_ext.dart';

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
