import 'package:shorey/base/view_state_model.dart';
import 'package:shorey/main.dart';
import 'package:shorey/model/model.dart';
import 'package:shorey/model/notion_database_model.dart';
import 'package:shorey/model/notion_model.dart';
import 'package:shorey/resource/data_provider.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/12/17
/// Description:
///

class CategoryInfoViewModel extends ViewStateModel {
  int _selectedColor = 1;
  int _selectedIcon = 1;

  int get selectedColor => _selectedColor;

  set selectedColor(int index) {
    this._selectedColor = index;
    notifyListeners();
  }

  int get selectedIcon => _selectedIcon;

  set selectedIcon(int index) {
    this._selectedIcon = index;
    notifyListeners();
  }

}
