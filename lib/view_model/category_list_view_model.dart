import 'package:spark_list/base/view_state_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/7/9
/// Description: 
///

class CategoryListViewModel extends ViewStateModel{
  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  set selectedCategoryIndex(int index){
    this._selectedCategoryIndex = index;
    notifyListeners();
  }

}