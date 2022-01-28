import 'package:flutter/cupertino.dart';
import 'package:spark_list/database/database.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/19/21
/// Description:
///

class VerboseTodo {
  final ToDo todo;
  final Category category;

  VerboseTodo(this.todo, this.category);
}

// class ToDoModel {
//   int? id;
//   int? createdTime;
//   int? filedTime;
//   String? content;
//   String? brief;
//
//   String get formatFiledTime {
//     var formatter = new DateFormat('yyyy-MM-dd');
//     return formatter
//         .format(DateTime.fromMillisecondsSinceEpoch(filedTime ?? 0));
//   }
//
//   ///0: finished 1: going 2: deleted
//   int? status;
//   String? category;
//   String? alertTime;
//   int? notificationId;
//
//   ToDoModel(
//       {this.id,
//       this.content,
//       required this.createdTime,
//       this.filedTime,
//       this.status,
//       this.category,
//       this.brief,
//       this.alertTime,
//       this.notificationId});
//
//   ToDoModel.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     createdTime = json['created_time'];
//     content = json['content'];
//     status = json['status'];
//     category = json['category'];
//     brief = json['brief'];
//     alertTime = json['alert_time'];
//     notificationId = json['notification_id'];
//     filedTime = json['filed_time'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.id;
//     data['created_time'] = this.createdTime;
//     data['content'] = this.content;
//     data['status'] = this.status;
//     data['category'] = this.category;
//     data['brief'] = this.brief;
//     data['alert_time'] = this.alertTime;
//     data['notification_id'] = this.notificationId;
//     data['filed_time'] = this.filedTime;
//     return data;
//   }
//
//   ToDoModel copy() {
//     final model = ToDoModel(createdTime: this.createdTime);
//     model.content = this.content;
//     return model;
//   }
// }
//
// abstract class ListModel<T> {
//   late List<T?> _cacheTodoList;
//   List<Map<String, dynamic>> list;
//   final bool reversed;
//
//   ListModel(this.list, {this.reversed = false}) {
//     _cacheTodoList = List.generate(list.length, (index) => null);
//   }
//
//   @override
//   T operator [](int index) {
//     if (reversed) {
//       list = list.reversed.toList();
//     }
//     return _cacheTodoList[index] ??= snapshotToToDo(list[index]);
//   }
//
//   @override
//   int get length => list.length;
//
//   @override
//   void operator []=(int index, T value) => throw 'read-only';
//
//   @override
//   set length(int newLength) => throw 'read-only';
//
//   T snapshotToToDo(Map<String, dynamic> snapshot);
// }
//
// class ToDoListModel extends ListModel<ToDoModel> {
//   final List<Map<String, dynamic>> list;
//   final bool reversed;
//
//   ToDoListModel(this.list, {this.reversed = false})
//       : super(list, reversed: reversed);
//
//   @override
//   ToDoModel snapshotToToDo(Map<String, dynamic> snapshot) {
//     return ToDoModel.fromJson(snapshot);
//   }
// }
//
// class HeatMapModel {
//   int? id;
//   int? createdTime;
//   int? level;
//
//   HeatMapModel({this.id, this.level, this.createdTime});
//
//   HeatMapModel.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     createdTime = json['created_time'];
//     level = json['level'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['created_time'] = this.createdTime;
//     data['level'] = this.level;
//     return data;
//   }
// }
//
class CategoryItem {
  String? name;
  String? notionDatabaseId;
  Icon? icon;
  Color? color;
  int id;
  int colorId;
  int iconId;

  CategoryItem(this.id,
      {this.name,
      this.icon,
      this.color,
      this.notionDatabaseId,
      required this.colorId,
      required this.iconId});
}

// class UserActionList extends ListModel<UserAction> {
//   final List<Map<String, dynamic>> list;
//   final bool reversed;
//
//   UserActionList(this.list, {this.reversed = false})
//       : super(list, reversed: reversed);
//
//   @override
//   UserAction snapshotToToDo(Map<String, dynamic> snapshot) {
//     return UserAction.fromJson(snapshot);
//   }
// }
//
// class UserAction {
//   int? id;
//   String? earlyContent;
//   String? updatedContent;
//   int? updatedTime;
//   int? action;
//
//   String get formatFiledTime {
//     var formatter = new DateFormat('yyyy-MM-dd');
//     return formatter
//         .format(DateTime.fromMillisecondsSinceEpoch(updatedTime ?? 0));
//   }
//
//   UserAction(
//       {this.id,
//       this.earlyContent,
//       this.updatedContent,
//       this.updatedTime,
//       this.action});
//
//   UserAction.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     earlyContent = json['early_content'];
//     updatedContent = json['updated_content'];
//     updatedTime = json['updated_time'];
//     action = json['action'];
//   }
// }

class CategoryDemo {
  int? id;
  String? name;

  CategoryDemo({this.id, this.name});
}
