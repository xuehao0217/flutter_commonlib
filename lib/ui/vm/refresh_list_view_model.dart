
import 'package:common_core/helpter/talker_helper.dart';
import 'package:common_core/net/dio_utils.dart';
import 'package:flutter_commonlib/entity/home_list_entity.dart';
import 'package:common_core/base/mvvm/base_list_view_model.dart';

class RefreshListViewModel extends  BaseListViewModel<HomeListDataDatas> {
  @override
  Future<List<HomeListDataDatas>> fetchPage(int page, int size) async {
      final result = await HttpUtils.requestNetwork<HomeListData>(
        Method.get,
        "/article/list/$page/json",
      );
      return result.datas;
  }


  @override
  void onReady() {
    super.onReady();
    "RefreshListViewModel onReady".logI(tag: "log");
  }
  @override
  void onInit() {
    super.onInit();
    "RefreshListViewModel onInit".logI(tag: "log");
  }
}