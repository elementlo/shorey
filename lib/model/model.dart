import 'package:flutter/cupertino.dart';
import 'package:spark_list/database/database.dart';

import '../generated/l10n.dart';

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
  String name;
  String? notionDatabaseId;
  String? notionDatabaseName;
  int notionDatabaseType;

  Icon? icon;
  Color color;
  int id;
  int colorId;
  int iconId;
  bool autoSync;

  CategoryItem(this.id,
      {required this.name,
      required this.autoSync,
      this.icon,
      required this.color,
      this.notionDatabaseId,
      this.notionDatabaseName,
      required this.notionDatabaseType,
      required this.colorId,
      required this.iconId});

  String mapTypeCode(int code) {
    switch (code) {
      case 0:
        return S.current.simpleList;
      case 1:
        return S.current.taskList;
      case 2:
        return S.current.templateDiaryTitle;
      default:
        return '';
    }
  }
}
