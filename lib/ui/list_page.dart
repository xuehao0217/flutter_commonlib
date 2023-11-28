import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_commonlib/base/mvvm/base_stateful_widget.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_commonlib/widget/common_list_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widget/common_widget.dart';
import 'vm/home_view_model.dart';

class CommonListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CommonListPage();
}

class _CommonListPage extends BaseStatefulWidget<HomeViewModel> {
  @override
  void onPageShow() {
    super.onPageShow();
  }

  @override
  void initData() {
    viewModel.getBannerData();
  }

  @override
  Color setStatusBarColor() => Colors.white;

  @override
  createViewModel() => HomeViewModel();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final controller = RefreshController(initialRefresh: true);

  @override
  Widget buildPageContent(BuildContext context) {
    return CommonListWidget(
      padding: const EdgeInsets.only(left: 15,right:15),
        controller: controller,
        enableRefresh: true,
        enableLoad: true,
        itemCount: viewModel.homeDatas.length,
        onRefresh: () {
          viewModel.getHomeData(() {
            setState(() {
              controller.refreshCompleted();
            });
          }, refresh: true);
        },
        onLoad: () {
          viewModel.getHomeData(() {
            setState(() {
              if (viewModel.homeDatas.length > 70) {
                controller.loadComplete();
                controller.loadNoData();
              } else {
                controller.loadComplete();
              }
            });
          });
        },
        header: [
          Column(
            children: [
              Obx(() => Swiper(
                    autoplay: true,
                    duration: 2000,
                    viewportFraction: 0.8,
                    scale: 0.9,
                    itemBuilder: (BuildContext context, int index) {
                      return CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: viewModel.banner[index].imagePath,
                      ).intoClipRRect(16);
                    },
                    itemCount: viewModel.banner.length,
                    pagination: SwiperPagination(),
                  ).intoContainer(width: double.infinity, height: 250)),
              const SizedBox(
                height: 15,
              ),
            ],
          )
        ],
        itemBuilder: (context, index) {
          return CommonButton(
            elevation: 2,
            circular: 10,
            backgroundColor: Colors.blue,
            width: double.infinity,
            height: 50,
            onPressed: () {},
            child: Text(
              viewModel.homeDatas[index].title,
              style: const TextStyle(color: Colors.white),
            ).intoPadding(const EdgeInsets.only(left: 15, right: 15)),
          );

          // Text(viewModel.rxBanner.toString(),
          //         style: const TextStyle(fontSize: 12))
          //     .clickInkWell(() {}),

          // CachedNetworkImage(
          //   imageUrl: "http://via.placeholder.com/350x150",
          //   placeholder: (context, url) => CircularProgressIndicator(),
          //   errorWidget: (context, url, error) => Icon(Icons.error),
          // ),
        });
  }
}
