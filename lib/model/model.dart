import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/19/21
/// Description:
///

class ToDoModel {
  int? id;
  int? createdTime;
  String? content;
  String? brief;
  ///0: finished, 1: going
  int? status;
  String? category;
  String? alertTime;
  int? notificationId;

  ToDoModel(
      {this.id,
      this.content,
      required this.createdTime,
      this.status,
      this.category,
      this.brief,
      this.alertTime,
      this.notificationId});

  ToDoModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    createdTime = json['created_time'];
    content = json['content'];
    status = json['status'];
    category = json['category'];
    brief = json['brief'];
    alertTime = json['alert_time'];
    notificationId = json['notification_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['created_time'] = this.createdTime;
    data['content'] = this.content;
    data['status'] = this.status;
    data['category'] = this.category;
    data['brief'] = this.brief;
    data['alert_time'] = this.alertTime;
    data['notification_id'] = this.notificationId;
    return data;
  }
}

class ToDoListModel {
  late List<ToDoModel?> _cacheTodoList;

  final List<Map<String, dynamic>> list;


  ToDoListModel(this.list) {
    ///lazy load
    _cacheTodoList = List.generate(list.length, (index) => null);
  }

  @override
  ToDoModel operator [](int index) {
    return _cacheTodoList[index] ??= snapshotToToDo(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, ToDoModel value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';

  ToDoModel snapshotToToDo(Map<String, dynamic> snapshot) {
    return ToDoModel.fromJson(snapshot);
  }
}

class HeatMapModel {
  int? id;
  int? createdTime;
  int? level;

  HeatMapModel({this.id, this.level, this.createdTime});

  HeatMapModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    createdTime = json['created_time'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_time'] = this.createdTime;
    data['level'] = this.level;
    return data;
  }
}

class CategoryItem{
  String? name;
  Icon? icon;
  Color? color;

  CategoryItem({this.name, this.icon, this.color});
}
