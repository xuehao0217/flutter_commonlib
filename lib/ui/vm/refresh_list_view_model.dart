
import 'package:common_core/net/dio_utils.dart';
import 'package:flutter_commonlib/entity/home_list_entity.dart';
import 'package:common_core/base/mvvm/base_list_view_model.dart';

class RefreshListViewModel extends  BaseListViewModel<HomeListDataDatas> {
  @override
  Future<PageResult<HomeListDataDatas>> fetchPage(int page, int size) async {
      final result = await HttpUtils.requestNetwork<HomeListData>(
        Method.get,
        "/article/list/$page/json",
      );
      return PageResult<HomeListDataDatas>(
        items: result.datas,
        total: result.total,
      );
  }

  @override
  void onReady() {
    super.onReady();
    getAsyncData(isRefresh: true);
  }


  @override
  int setPageSize()=>20;
}