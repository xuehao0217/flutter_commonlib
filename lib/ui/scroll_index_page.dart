import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/base/base_page_stateless_widget.dart';
import 'package:flutter_commonlib/base/mvvm/base_stateless_widget.dart';
import 'package:flutter_commonlib/base/mvvm/base_view_abs.dart';
import 'package:flutter_commonlib/base/mvvm/base_view_model.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../base/base_page_stateful_widget.dart';
import '../widget/scroll_index_widget.dart';


class ScrollIndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScrollIndexPage();
}

class _ScrollIndexPage   extends BasePgaeStatefulWidget<ScrollIndexPage>{
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 添加滚动监听器
    _scrollController.addListener(() {
    });
  }

  @override
  void dispose() {
    // 在组件销毁时释放ScrollController
    _scrollController.dispose();
    super.dispose();
  }


  // 滑动停止时执行的操作
  void _WhenScrollStops(first,last) {
    // 在这里执行您想要的操作
    print('滑动已停止  当前第一个可见元素下标 $first 当前最后一个可见元素下标 $last');
    SmartDialog.showToast("当前第一个可见元素下标 $first 当前最后一个可见元素下标 $last");
  }


  @override
  Color setStatusBarColor()=>Colors.deepPurpleAccent;

  @override
  String setTitle() => "我的";

  @override
  bool showTitleBar()=>false;

  @override
  Widget buildPageContent(BuildContext context) {
    // return   ScrollIndexWidget(
    //   child: ListView.builder(
    //     controller: _scrollController,
    //     itemBuilder: (c, i) {
    //       return Container(
    //         alignment: Alignment.center,
    //         color: Colors.green.withBlue((i + 1) * 100),
    //         height: (i + 1) * 20,
    //         child: Text('index==$i'),
    //       );
    //     },
    //     scrollDirection: Axis.vertical,
    //     itemCount: 100,
    //   ),
    //   callback: (first, last) {
    //     if (!_scrollController.position.isScrollingNotifier.value) {
    //       _WhenScrollStops(first,last);
    //     }
    //   },
    // );
    int _progress = 0;
    return NotificationListener(
      onNotification: (ScrollNotification notification){
        //1.监听事件的类型
        if(notification is ScrollStartNotification){
          print("开始滚动...");
        }else if(notification is ScrollUpdateNotification){
          //当前滚动的位置和总长度
          final currentPixel = notification.metrics.pixels;
          final totalPixel = notification.metrics.maxScrollExtent;
          double progress = currentPixel/totalPixel;
          setState(() {
            _progress = (progress*100).toInt();
          });
          print("正在滚动： ${_progress}%   ${notification.metrics.pixels} - ${notification.metrics.maxScrollExtent}");
        }else if(notification is ScrollEndNotification){
          print("滚动结束....");
        }
        return false;
      },
      child: Stack(
        alignment: Alignment(.9,.9),
        children: <Widget>[
          ListView.builder(
            itemCount: 100,
            itemExtent: 80,
            itemBuilder: (BuildContext context,int index){
              return ListTile(title: Text("item $index"),);
            },
          ),
          CircleAvatar(
            radius: 30,
            child: Text("$_progress%"),
            backgroundColor: Colors.black54,
          ),
        ],
      ),
    );
  }
}
