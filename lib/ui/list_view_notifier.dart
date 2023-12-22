import 'package:baseoo/http/http_handle.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'load_state.dart';

abstract class ListViewStateNotifier<T>
    extends StateNotifier<LoadState<List<T>>> {
  ListViewStateNotifier({
    this.pageSize = 10,
    this.pageIndex = 1,
    this.openRefresh = true,
    this.openLoadMore = true,
  }) : super(const LoadState.loading()) {
    init();
  }

  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);

  EasyRefreshController get refreshController => _refreshController;

  final int pageSize;
  final int pageIndex;
  int _page = 0;

  final List<T> _items = [];

  List<T> get items => _items;

  int loadType = 0;

  Future<List<T>> quest(int page, int size);

  LoadType type = LoadType.NORMAL;

  bool _isEnd = false;

  var isLoading = false;

  var openRefresh = true;

  var openLoadMore = true;

  void init() {
    type = LoadType.NORMAL;
    _page = pageIndex;
    loadData();
  }

  void update() {
    state = LoadState.success(items);
  }


  Future<void> refreshData() async {
    _page = pageIndex;
    type = LoadType.REFRESH;
    await loadData();
  }

  Future<void> moreData() async {
    if (isLoading) {
      return;
    }
    if (_isEnd) {
      _refreshController.finishLoad(IndicatorResult.noMore);
    } else {
      type = LoadType.LOADMORE;

      await loadData();
    }
  }

  Future<void> reStart({bool clearData = true}) async {
    state = const LoadState.loading();
    if (clearData) _items.clear();
    await refreshData();
  }

  void reversed() {
    if (_items.isNotEmpty) {
      final newList = _items.reversed.toList();
      _items.clear();
      _items.addAll(newList);
      state = LoadState.success(_items);
    }
  }

  bool addData(T t, {int index = 0}) {
    if (!_items.contains(t)) {
      _items.insert(index, t);
      state = LoadState.success(_items);
      return true;
    }
    return false;
  }

  bool remove(T t) {
    if (_items.contains(t)) {
      _items.remove(t);
      state = LoadState.success(_items);
      return true;
    }
    return false;
  }

  bool removeAt(int index) {
    if (_items.length > index) {
      _items.removeAt(index);
      state = LoadState.success(_items);
      return true;
    }
    return false;
  }

  Future<void> loadData() async {
    isLoading = true;

    HttpHandle.d(quest(_page, pageSize), (list) {
      if (list.isEmpty) {
        if (_items.isEmpty) {
          state = LoadState.success(_items);
        }
      } else {
        if (_page == pageIndex) {
          _items.clear();
          if (type == LoadType.REFRESH) {
            _refreshController.finishRefresh(IndicatorResult.success);
          }
        }
        _items.addAll(list);
        state = LoadState.success(_items);
      }

      _isEnd = list.length < pageSize;

      if (type == LoadType.LOADMORE) {
        _refreshController.finishLoad(
            _isEnd ? IndicatorResult.noMore : IndicatorResult.success);
      }

      _page += 1;
    }, fail: (e) {
      if (_page == pageIndex) {
        if (_items.isNotEmpty) {
          _refreshController.finishRefresh(IndicatorResult.fail);
        } else {
          state = LoadState.error(e);
        }
      } else {
        _refreshController.finishLoad(IndicatorResult.fail);
      }
    }, complete: (c) {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

enum LoadType { REFRESH, LOADMORE, NORMAL }
