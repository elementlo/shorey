import 'package:dio/dio.dart';
import 'package:spark_list/database/database.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/13
/// Description: 
///

var dio = Dio();

extension ResponseExt on Response{
  bool get success => this.statusCode == 200;
  bool get notFound => this.data?['code'] == 'object_not_found';
}

extension ToDoExt on ToDo{
  String get statusTitle {
    String title = '';
    switch(this.status){
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