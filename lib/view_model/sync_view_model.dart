import 'package:spark_list/base/view_state_model.dart';

import '../model/notion_database_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/5/20
/// Description: 
///

class SyncWorkflowViewModel extends ViewStateModel{
  bool autoSyncToggle = true;

  NotionDatabase? database;

  List<dynamic> notionObjectList = [];

  String title = '';

  set setObjectList(List<dynamic> objectList) {
    this.notionObjectList = objectList;
    notifyListeners();
  }

  set setDatabase(NotionDatabase? database) {
    this.database = database;
    notifyListeners();
  }

  set setAutoSyncToggle(bool toggle){
    this.autoSyncToggle = toggle;
    notifyListeners();
  }

  void unlinkNotionDatabase() {
    setDatabase = null;
  }
}