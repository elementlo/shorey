import 'dart:convert';

import 'package:flutter/services.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/2/24
/// Description:
///

class NotionDatabaseTemplate {
  static const String jsonTaskList = 'assets/json/notion_task_list.json';
  static const String jsonTaskItem = 'assets/json/notion_task_item.json';

  static const String jPageId = 'page_id';
  static const String jParent = 'parent';
  static const String jDatabaseId = 'database_id';
  static const String jProperties = 'properties';
  static const String jTypeTitle = 'title';
  static const String jTypeText = 'text';
  static const String jTypeContent = 'content';
  static const String jTypeSelect = 'select';
  static const String jTypeName = 'name';
  static const String jTypeMultiSelect = 'multi_select';
  static const String jTypeChildren = 'children';
  static const String jTypeObject = 'object';
  static const String jTypeParagraph = 'paragraph';
  static const String jTypeDate = 'date';
  static const String jTypeStart = 'start';
  static const String jTypeEnd = 'end';
  static const String jTypeRichText = 'rich_text';

  static const String jStatus = 'Status';
  static const String jTitle = 'Title';
  static const String jTags = 'Tags';
  static const String jDuration = 'Duration';
  static const String jReminderTime = 'Reminder Time';

  static Future<dynamic?> taskList(String pageId) async {
    final json = await rootBundle.loadString(jsonTaskList);
    if (json != null) {
      final map = jsonDecode(json);
      map[jParent][jPageId] = pageId;
      return map;
    }
    return null;
  }

  static dynamic taskItem(String databaseId,
      {required String title,
      required String statusTitle,
      required String createdTime,
      String? brief,
      String? endTime,
      List<String>? tags,
      String? reminderTime}) async {
    final json = await rootBundle.loadString(jsonTaskItem);
    if (json != null) {
      final map = jsonDecode(json);
      map[jParent][jDatabaseId] = databaseId;
      map[jProperties][jTitle][jTypeTitle][0][jTypeText][jTypeContent] = title;
      map[jProperties][jStatus][jTypeSelect][jTypeName] = statusTitle;
      map[jProperties][jTags][jTypeMultiSelect][0][jTypeName] = tags?[0];
      map[jProperties][jDuration][jTypeDate][jTypeStart] = createdTime;
      map[jProperties][jDuration][jTypeDate][jTypeEnd] = endTime;
      if (reminderTime != null && reminderTime.isNotEmpty) {
        map[jProperties][jReminderTime] = {
          "date": {
            "start": "${reminderTime}",
          }
        };
      }
      map[jTypeChildren][0][jTypeParagraph][jTypeRichText][0][jTypeText]
          [jTypeContent] = brief;
      return map;
    }
    return null;
  }

  static dynamic itemProperties({
    String? title,
    List<String>? tags,
    String? reminderTime,
  }) {
    final map = Map<String, dynamic>();
    if (title != null && title.isNotEmpty) {
      map[jTitle] = {
        'title': [
          {'text': '${title}'}
        ]
      };
    }
    if (tags != null && tags.length > 0) {
      map[jTags] = {
        'multi_select': [
          {'name': '${tags[0]}'}
        ]
      };
    }
    if (reminderTime != null && reminderTime.isNotEmpty) {
      map[jReminderTime] = {
        "date": {
          "start": "${reminderTime}",
        }
      };
    }
    return map;
  }
}
