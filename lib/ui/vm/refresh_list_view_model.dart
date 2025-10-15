
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
}



// class UserController extends GetxController with StateMixin<User> {
//   void fetchUser() async {
//     change(null, status: RxStatus.loading()); // 显示加载中
//
//     try {
//       final user = await Api.getUser(); // 模拟接口
//       change(user, status: RxStatus.success()); // 请求成功
//     } catch (e) {
//       change(null, status: RxStatus.error(e.toString())); // 出错
//     }
//   }
// }
//
//
// class UserPage extends GetView<UserController> {
//   @override
//   Widget build(BuildContext context) {
//     return controller.obx(
//           (state) => Text('用户名：${state?.name}'),
//       onLoading: const Center(child: CircularProgressIndicator()),
//       onError: (err) => Center(child: Text("出错：$err")),
//       onEmpty: const Center(child: Text("暂无数据")),
//     );
//   }
// }
