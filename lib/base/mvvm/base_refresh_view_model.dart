import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../net/dio_utils.dart';
import 'base_view_abs.dart';
import 'base_view_model.dart';

abstract class BaseRefreshViewModel<T> extends BaseViewModel {
  final controller = RefreshController(initialRefresh: true);

  var currentPageIndex = 1; ///当前是多少页

  var defPageIndex = 0; ///默认的页面角标

  ///当前页面
  var datas = <T>[].obs;

  var pageCount = 1;///一页有多少数据 或者不满足多少算结束。

  @override
  void onInit() {
    currentPageIndex = defPageIndex;
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }

  void requestRefresh() {
    currentPageIndex = defPageIndex;
    controller.requestRefresh();
  }

  void getRefreshLoadData<T>(
      {bool refresh = false,
      required String url,
      required NetSuccessCallback<T?>? success}) {
    if (refresh) {
      currentPageIndex = defPageIndex;
    } else {
      currentPageIndex++;
    }
    requestNetwork<T>(Method.get,
        showLoading: true, url: url, onSuccess: success, onError: (code, str) {
      if (refresh) {
        finishRefresh(success: false);
      } else {
        finishLoad(success: false);
      }
    });
  }

  void onRequestData(
    bool refresh,
    List<T> resultData,
  ) {
    if (refresh) {
      datas.value.clear();
      datas.value = resultData;
      finishRefresh();
    } else {
      datas.addAll(resultData);
      if (resultData.isEmpty || resultData.length < pageCount) {
        finishLoad(noMore: true);
      } else {
        finishLoad();
      }
    }
  }

  /// 完成上拉加载
  void finishRefresh({
    bool success = true,
    bool noMore = false,
  }) {
    if (success) {
      if (noMore) {
        controller.loadNoData();
      }
      controller.refreshCompleted(resetFooterState: !noMore);
    } else {
      controller.refreshFailed();
    }
  }

  /// 完成上拉加载
  void finishLoad({
    bool success = true,
    bool noMore = false,
  }) {
    if (success) {
      if (noMore) {
        controller.loadComplete();
        controller.loadNoData();
      } else {
        controller.loadComplete();
      }
    } else {
      controller.loadFailed();
    }
  }
}
