import 'package:flutter/cupertino.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/19/21
/// Description:
///
class ToDoModel {
  int id;
  int createdTime;
  String content;
  int status;

  ToDoModel(
      {this.id,
      this.content,
      @required this.createdTime,
      this.status});
}

class HeatMapModel {
  int id;
  int createdTime;
  int level;

  HeatMapModel({this.id, this.level, this.createdTime});
}
