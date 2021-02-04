import 'view_state_model.dart';
///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

abstract class ViewStateListModel<T> extends ViewStateModel {
  List<T> list = [];

  initDate() async {
    setBusy();
    await refresh(init: true);
  }

  ///下拉刷新
  Future<List<T>> refresh({bool init = false}) async {
    try {
      List<T> data = await loadData();
      if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        setIdle();
      }
      return data;
    } catch (e, s) {
      if (init) list.clear();
      setError(e: e, stackTrace: s);
      return null;
    }
  }

  ///加载数据
  Future<List<T>> loadData({int pageNum});

  onCompleted(List<T> data) {}
}
