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

abstract class ModelMixin {
  Map<String, dynamic> toJson();
}

class CategoryItem {
  String? name;
  String? notionDatabaseId;
  int? notionDatabaseType;
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
      this.notionDatabaseType,
      required this.colorId,
      required this.iconId});
}

class CategoryDemo {
  int? id;
  String? name;

  CategoryDemo({this.id, this.name});
}
