import 'package:dio/dio.dart';
import 'package:spark_list/database/database.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/3/8
/// Description:
///

extension ResponseExt on Response {
  bool get success => this.statusCode == 200;

  bool get notFound => this.data?['code'] == 'object_not_found';
}

extension ToDoExt on ToDo {
  String get statusTitle {
    String title = '';
    switch (this.status) {
      case 0:
        title = 'Archived';
        break;
      case 1:
        title = 'On Going';
        break;
      case 2:
        title = 'Deleted';
        break;
    }
    return title;
  }

  bool properTiesEquals(ToDo model) {
    return this.content == model.content &&
        this.categoryId == model.categoryId &&
        this.alertTime?.millisecondsSinceEpoch ==
            model.alertTime?.millisecondsSinceEpoch;
  }

  bool briefEquals(ToDo model){
    return this.brief == model.brief;
  }

}

extension CompanionExt on ToDosCompanion{
  String get statusTitle {
    String title = '';
    switch (this.status.value) {
      case 0:
        title = 'Archived';
        break;
      case 1:
        title = 'On Going';
        break;
      case 2:
        title = 'Deleted';
        break;
    }
    return title;
  }
}