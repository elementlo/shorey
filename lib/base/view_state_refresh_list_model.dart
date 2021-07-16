import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'view_state_list_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

abstract class ViewStateRefreshListModel<T> extends ViewStateListModel<T> {
  static const int pageNumFirst = 0;
  static const int pageSize = 20;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;

  int _currentPageNum = pageNumFirst;

  @override
  Future<List<T>?> refresh({bool init = false}) async {
    try {
      _currentPageNum = pageNumFirst;
      List<T> data = await loadData(pageNum: pageNumFirst);
      if (data.isEmpty) {
        refreshController.refreshCompleted(resetFooterState: true);
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        refreshController.refreshCompleted();

        ///小于分页的数据，禁止上拉加载更多
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
        setIdle();
      }
      return data;
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) list.clear();
      _refreshController.refreshFailed();
      setError(e: e, stackTrace: s);
      return null;
    }
  }

  Future<List<T>?> loadMore() async {
    try {
      List<T> data = await loadData(pageNum: ++_currentPageNum);
      if (data.isEmpty) {
        _currentPageNum--;
        refreshController.loadNoData();
      } else {
        onCompleted(data);
        list.addAll(data);
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      }
      notifyListeners();
      return data;
    } catch (e, s) {
      _currentPageNum--;
      refreshController.loadFailed();
      debugPrint('error--->\n${e.toString()}');
      debugPrint('statck--->\n${s.toString()}');
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }
}
