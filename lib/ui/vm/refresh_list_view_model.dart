import 'package:flutter_commonlib/base/mvvm/base_refresh_view_model.dart';
import 'package:flutter_commonlib/entity/home_list_entity.dart';

import '../../entity/home_list_entity.dart';

class RefreshListViewModel extends BaseRefreshViewModel<HomeListDatas> {
  void getDatas({bool refresh = false}) {
    getRefreshLoadData<HomeListEntity>(
        url: "/article/list/$page/json",
        success: (data) {
          onRequestData(refresh, data!.datas);
        },
        refresh: refresh);
  }
}
