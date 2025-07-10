import 'dart:async';

import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:get/get.dart';

import '../../helpter/logger_helper.dart';
import 'base_view_model.dart';

/// 通用分页ViewModel，支持 InfinitePaginator 和 AsyncPaginator
abstract class BaseListViewModel<T> extends BaseViewModel {
  // 响应式数据
  final datas = <T>[].obs;

  late InfinitePaginator<T, int> infinitePaginator;
  late AsyncPaginator<T> asyncPaginator;

  int _total = 0;

  /// ：请求一页数据，返回 List<T> 和 total（可选）
  Future<PageResult<T>> fetchPage(int page, int size);

  int setPageSize() => 20;

  /// 初始化分页器
  @override
  void onInit() {
    super.onInit();
    infinitePaginator = InfinitePaginator.pageBased(
      fetchItems: (pageSize, pageNumber) async {
        LoggerHelper.d(
          "InfinitePaginator---> pageSize=$pageSize pageNumber=$pageNumber",
        );
        final result = await fetchPage(pageNumber, pageSize);
        return result.items;
      },
      pageSize: setPageSize(),
      initialPageNumber: 1,
    );

    asyncPaginator = AsyncPaginator<T>(
      pageSize: setPageSize(),
      config: PaginationConfig(retryAttempts: 3),
      totalItemsFetcher: () async => _total,
      fetchPage: (page, size) async {
        LoggerHelper.d("AsyncPaginator---> page=$page size=$size");
        final result = await fetchPage(page, size);
        if (page == 1) _total = result.total;
        return result.items;
      },
    );
  }

  /// InfinitePaginator 加载数据
  Future<void> getInfiniteData({bool isRefresh = false}) async {
    if (isRefresh) {
      infinitePaginator.reset();
    }
    await infinitePaginator.loadMoreItems();
    if (isRefresh) {
      datas.assignAll(infinitePaginator.items);
    } else {
      final oldLength = datas.length;
      final newItems = infinitePaginator.items.skip(oldLength);
      datas.addAll(newItems);
    }
  }

  /// AsyncPaginator 加载数据
  Future<void> getAsyncData({bool isRefresh = false}) async {
    if (isRefresh) {
      asyncPaginator.reset();
      final firstPage = await asyncPaginator.currentPageItems;
      datas.assignAll(firstPage);
    } else {
      final hasNext = await asyncPaginator.hasNextPage;
      LoggerHelper.d("getAsyncData   hasNext=${hasNext}");
      if (hasNext) {
        await asyncPaginator.nextPage();
        final nextPage = await asyncPaginator.currentPageItems;
        datas.addAll(nextPage);
      }
    }
  }

  @override
  void onClose() {
    infinitePaginator.dispose();
    asyncPaginator.dispose();
    super.onClose();
  }
}

/// 分页结果数据结构
class PageResult<T> {
  final List<T> items;
  final int total;

  PageResult({required this.items, required this.total});
}
