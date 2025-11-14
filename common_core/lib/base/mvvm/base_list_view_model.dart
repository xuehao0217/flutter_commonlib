import 'dart:async';
import 'package:get/get.dart';
import 'base_view_model.dart';

abstract class BaseListViewModel<T> extends BaseViewModel {
  final datas = <T>[].obs;

  Future<List<T>> fetchPage(int page, int size);

  int _pageNumber = 1;
  int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    getRefreshData();
  }

  Future<void> getRefreshData() async {
    _pageNumber = 1;
    try {
      final result = await fetchPage(_pageNumber, _pageSize);
      datas.assignAll(result);
    } catch (e) {
      // error handling
    }
  }

  Future<bool> getLoadData() async {
    _pageNumber++;
    try {
      final result = await fetchPage(_pageNumber, _pageSize);
      datas.addAll(result);
      return result.isNotEmpty;
    } catch (e) {
      _pageNumber--;
      return false;
    }
  }

  @override
  void onClose() {
    datas.clear();
    super.onClose();
  }
}
