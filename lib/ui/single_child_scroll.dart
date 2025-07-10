import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SingleChildScrollViewPage extends StatefulWidget {
  @override
  _SingleChildScrollViewState createState() {
    return _SingleChildScrollViewState();
  }
}

class _SingleChildScrollViewState extends State<SingleChildScrollViewPage> {
  ScrollController mController = new ScrollController();

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  @override
  void initState() {
    //监听滚动事件，打印滚动位置
    mController.addListener(() {
      print(mController.offset); //打印滚动位置
      if (mController.offset < getKey1Height() && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (mController.offset >= getKey1Height() &&
          showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    mController.dispose();
    super.dispose();
  }

// 在需要获取高度的地方
  double getKey1Height() {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  final GlobalKey _key = GlobalKey();
  final GlobalKey _key2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // 显示进度条
        appBar: new AppBar(title: new Text("滚动控件")),
        floatingActionButton: !showToTopBtn
            ? null
            : FloatingActionButton(
                child: Icon(Icons.arrow_upward),
                onPressed: () {
                  //返回到顶部时执行动画
                  mController.animateTo(.0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                }),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: mController,
                child: Center(
                  child: Column(
                    //动态创建一个List<Widget>
                    children: [
                      Container(
                        width: double.infinity,
                        height: 500,
                        color: Colors.deepOrange,
                        key: _key,
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.blue,
                      ),
                      Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.yellow,
                      ),
                      Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.green,
                      ),
                      Container(
                        width: double.infinity,
                        height: 500,
                        color: Colors.amber,
                      ),
                      Container(
                        width: double.infinity,
                        height: 700,
                        color: Colors.brown,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
