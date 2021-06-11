import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

class HomeViewModel extends ViewStateModel {
  HomeViewModel() {
    _heatMapTask();
  }

  String _mainFocus = '';
  bool _hasMainFocus = true;

  String get mainFocus => _mainFocus;

  bool get hasMainFocus => _hasMainFocus;

  set hasMainFocus(bool hasMainFocus) {
    this._hasMainFocus = hasMainFocus;
    notifyListeners();
  }

  void _heatMapTask() async {
    final point = await sparkProvider.getTopHeatPoint();
    print('heat map task: ${point}');
    final currentTime = DateTime.now();
    if (point?.createdTime != null) {
      final lastTime = DateTime.fromMillisecondsSinceEpoch(point.createdTime);
      if (lastTime.year != currentTime.year &&
          lastTime.month != currentTime.month &&
          lastTime.day != currentTime.day) {
        print('not the same day ...insert initial heat point...');
        oneDayPassBy = true;
        await sparkProvider.insertHeatPoint(
            0, currentTime.millisecondsSinceEpoch);
      } else {
        oneDayPassBy = false;
        print('the same day ...ignore...');
      }
    } else {
      oneDayPassBy = true;
      print('insert initial heat point...');
      await sparkProvider.insertHeatPoint(
          0, currentTime.millisecondsSinceEpoch);
    }
    
    initMainFocus();
  }

  Future initMainFocus() async{
    if (oneDayPassBy) {
      _hasMainFocus = false;
    } else {
      final model = await queryMainFocus();
      if (model != null) {
        _mainFocus = model.content;
        _hasMainFocus = true;
      }else{
        _hasMainFocus = false;
      }
    }
    notifyListeners();
  }
  
  Future saveMainFocus(String content, {int status = 1}) async {
    await sparkProvider.insertToDo(
        ToDoModel(createdTime: DateTime.now().millisecondsSinceEpoch)
          ..content = content
          ..status = 1);
    await initMainFocus();
    notifyListeners();
  }

  Future<ToDoModel> queryMainFocus() async {
    return await sparkProvider.getTopToDo();
  }
  
  Future updateMainFocusStatus(int status){
    
  }
}
