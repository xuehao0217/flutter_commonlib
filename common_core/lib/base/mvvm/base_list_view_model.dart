import 'dart:async';
import 'package:get/get.dart';
import 'base_view_model.dart';

abstract class BaseListViewModel<T> extends BaseViewModel {
  final datas = <T>[].obs;

  /// ：请求一页数据，返回 List<T> 和 total（可选）
  Future<List<T>> fetchPage(int page, int size);

  /// 页码、总数、每页数量
  int _pageNumber = 1;
  int _pageSize = 20;
  int _totalCount = 0;

  @override
  void onInit() {
    super.onInit();
    getRefreshData();
  }

  /// 下拉刷新
  Future<void> getRefreshData() async {
    _pageNumber = 1;
    final result = await fetchPage(_pageNumber, _pageSize);
    datas.assignAll(result);
  }

  /// 加载更多
  Future<bool> getLoadData() async {
    _pageNumber++;
    final result = await fetchPage(_pageNumber, _pageSize);
    datas.addAll(result);
    return result.isNotEmpty;
  }

  @override
  void onClose() {
    datas.clear();
    super.onClose();
  }
}
