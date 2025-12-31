import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/common_core.dart';
import 'package:common_core/helpter/get_ext_helper.dart';
import 'package:common_core/helpter/logger_helper.dart';
import 'package:common_core/helpter/talker_helper.dart';
import 'package:common_core/widget/common_listview.dart';
import 'package:common_core/widget/common_widget.dart';
import 'package:common_core/widget/refresh_ext.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/ui/vm/refresh_list_view_model.dart';
import 'package:get/get.dart';
import '../entity/home_list_entity.dart';

class RefreshListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RefreshListPage();
}

class _RefreshListPage
    extends BaseVMStatefulWidget<RefreshListPage, RefreshListViewModel> {
  @override
  void onPageShow() {
    super.onPageShow();
  }

  @override
  void initData() {}

  @override
  createViewModel() => RefreshListViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(
      () => SmartRefresherListView(
        viewModel: viewModel,
        listView: CommonListView.buildListView<HomeListDataDatas>(
          physics: const ClampingScrollPhysics(),
          items: viewModel.datas,
          separatorBuilder: (context, index) {
            return SizedBox(height: 15);
          },
          // visibleListCallback: (datas) {
          //   LoggerHelper.d(
          //     "visibleListCallback==${datas.map((item) => item.title).toList()}",
          //   );
          // },
          itemBuilder: (item, index) {
            return Text(
                  "${viewModel.datas[index].title}",
                  style: const TextStyle(color: Colors.white),
                )
                .withContainer(
                  color: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                );
          },
        ),
      ),
    );

    return viewModel.datas.obxIfNotEmpty(
      (datas) => CommonListView.buildListView<HomeListDataDatas>(
        physics: const ClampingScrollPhysics(),
        items: datas,
        separatorBuilder: (context, index) {
          return SizedBox(height: 15);
        },
        // visibleListCallback: (datas) {
        //   LoggerHelper.d(
        //     "visibleListCallback==${datas.map((item) => item.title).toList()}",
        //   );
        // },
        itemBuilder: (item, index) {
          return Text(
                "${viewModel.datas[index].title}",
                style: const TextStyle(color: Colors.white),
              )
              .withContainer(
                color: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              );
        },
      ).intoRefreshList(viewModel),
      emptyWidget: Center(child: CircularProgressIndicator()),
    );

    return viewModel.datas.obxIfNotEmpty(
      (datas) =>
          CommonListView<HomeListDataDatas>(
            items: datas,
            separatorBuilder: (context, index) {
              return SizedBox(height: 15);
            },
            visibleListCallback: (datas) {
              LoggerHelper.d(
                "visibleListCallback==${datas.map((item) => item.title).toList()}",
              );
            },
            itemBuilder: (item, index) {
              return Text(
                    "${viewModel.datas[index].title}",
                    style: const TextStyle(color: Colors.white),
                  )
                  .withContainer(
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  )
                  .withIntrinsicHeight();
            },
          ).intoEasyRefreshList(
            viewModel,
            header: const CupertinoHeader(),
            footer: const CupertinoFooter(),
            // footer: const ClassicFooter(
            //   showMessage: false,
            //   noMoreIcon: SizedBox.shrink(),
            //   spacing: 0, // 去掉图标和文字之间的间距
            //   iconDimension: 0, // 不显示 icon 占位
            // ),
          ),
      emptyWidget: Center(child: CircularProgressIndicator()),
    );
  }
}
