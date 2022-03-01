import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/model/notion_database_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/2/21
/// Description: 
///

class NotionDatabaseViewModel extends ViewStateModel{

  NotionDatabase? database;

  set setDatabase(NotionDatabase? database) {
    this.database = database;
    notifyListeners();
  }



  void unlinkNotionDatabase() {
    setDatabase = null;
  }

}
