import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/base/base_page_stateless_widget.dart';
import 'package:flutter_commonlib/base/mvvm/base_stateless_widget.dart';
import 'package:flutter_commonlib/base/mvvm/base_view_abs.dart';
import 'package:flutter_commonlib/base/mvvm/base_view_model.dart';
import 'package:flutter_commonlib/widget/tab_widget.dart';

class MsgPage extends BasePageStatelessWidget {
  @override
  String setTitle() => "消息";

  @override
  bool showTitleBar() => false;

  @override
  Color setStatusBarColor() => Colors.greenAccent;

  final List<Tab> tabs = <Tab>[
    const Tab(text: 'AAAAAA'),
    const Tab(text: 'BBBBBB'),
    const Tab(text: 'CCCCCC'),
    const Tab(text: 'DDDDDD'),
    const Tab(text: 'EEEEEE'),
    const Tab(text: 'FFFFFF'),
    const Tab(text: 'GGGGGG'),
  ];

  @override
  Widget buildContent(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            TabBar(
              tabs: tabs,
              labelStyle:const TextStyle(fontSize: 18),   // 选中tab文字样式
              unselectedLabelStyle:const TextStyle(fontSize: 18),// 非选中tab文字样式
              // indicatorPadding: const EdgeInsets.symmetric(vertical: 8),
              isScrollable: true,
              labelColor: Colors.black,  // 选中
              unselectedLabelColor: Colors.black,//非选中
              indicator: const MyTabIndicator(
                  borderSide: BorderSide(color: Colors.blue, width: 3),
                  indicatorWidth: 30,
                  indicatorBottom: 10),
            ),
            TabBar(
                tabs: tabs,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 8),
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle:const TextStyle(fontSize: 18),   // 选中tab文字样式
                unselectedLabelStyle:const TextStyle(fontSize: 18),// 非选中tab文字样式
                indicatorWeight: 1,
                indicator: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.green,
                )),

            Expanded(
                child: TabBarView(
                    children: tabs
                        .map((Tab tab) =>
                            Center(child: Text(tab.text.toString())))
                        .toList())),
          ],
        ));
  }
}
