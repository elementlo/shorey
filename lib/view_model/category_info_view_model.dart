import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/model/notion_database_model.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/resource/data_provider.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/12/17
/// Description:
///

class CategoryInfoViewModel extends ViewStateModel {
  int _selectedColor = 1;
  int _selectedIcon = 1;

  NotionDatabase? database;

  List<NotionDatabase> notionObjectList = [];

  set setDatabase(NotionDatabase? database) {
    this.database = database;
    notifyListeners();
  }

  int get selectedColor => _selectedColor;

  CategoryInfoViewModel({CategoryItem? category}) {
    if (category != null) {
      selectedColor = category.colorId;
      selectedIcon = category.iconId;
    }
  }

  set selectedColor(int index) {
    this._selectedColor = index;
    notifyListeners();
  }

  int get selectedIcon => _selectedIcon;

  set selectedIcon(int index) {
    this._selectedIcon = index;
    notifyListeners();
  }

  void unlinkNotionDatabase() {
    setDatabase = null;
  }

  Future<bool> checkLinkingStatus() async {
    final map =
        await dsProvider.getValue<Map<String, dynamic>>(StoreKey.notionUser);
    if (map != null) {
      final token = Results.fromJson(map).token;
      return (token != null && token.isNotEmpty);
    }
    return false;
  }
}
