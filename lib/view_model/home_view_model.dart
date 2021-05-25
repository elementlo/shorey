import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/main.dart';

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

  _heatMapTask() async {
    final point = await sparkProvider.getTopHeatPoint();
    print('heat map task: ${point}');
    final currentTime = DateTime.now();
    if (point?.createdTime != null) {
      final lastTime = DateTime.fromMillisecondsSinceEpoch(point.createdTime);
      if (lastTime.year != currentTime.year &&
          lastTime.month != currentTime.month &&
          lastTime.day != currentTime.day) {
	      print('not the same day ...insert initial heat point...');
	      await sparkProvider.insertHeatPoint(0, currentTime.millisecondsSinceEpoch);
      }else{
        print('the same day ...ignore...');
      }
    }else{
      print('insert initial heat point...');
      await sparkProvider.insertHeatPoint(0, currentTime.millisecondsSinceEpoch);
    }
  }
}
