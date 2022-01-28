import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/config/api.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/model/notion_database_model.dart';
import 'package:spark_list/resource/http_provider.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/12/17
/// Description:
///

class CategoryInfoViewModel extends ViewStateModel {
  int _selectedColor = 1;
  int _selectedIcon = 1;
  String? coverUrl = '';
  String? title = '';
  String? titleIcon = '';
  String? notionDatabaseId = '';

  int get selectedColor => _selectedColor;

  CategoryInfoViewModel({CategoryItem? category}) {
    if (category != null) {
      if (category.notionDatabaseId != null &&
          category.notionDatabaseId != '') {
        linkNotionDatabase(category.notionDatabaseId!);
      }
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

  Future<NotionDatabase?> linkNotionDatabase(String databaseId) async {
    final response = await dio.get('${retrieveNotionDatabase}/${databaseId}');
    if (response.success) {
      final database = NotionDatabase.fromJson(response.data);
      coverUrl = database.cover?.external?.url ?? '';
      titleIcon = database.icon?.type == 'emoji' ? database.icon?.emoji : '';
      title = database.title?[0].plainText;
      notionDatabaseId = databaseId;
      notifyListeners();
      return database;
    }
    return null;
  }

  Future deleteNotionRootPage() {
    coverUrl = '';
    title = '';
    titleIcon = '';
    notifyListeners();
    return dsProvider.deleteRootNotionPage();
  }
}
