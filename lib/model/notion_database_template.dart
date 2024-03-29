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
  static const String jsonBlockChildren =
      'assets/json/notion_block_children.json';

  static const String jsonSimpleList = 'assets/json/notion_simple_list.json';
  static const String jsonSimpleItem = 'assets/json/notion_simple_item.json';

  static const String jsonDiaryRepo = 'assets/json/notion_diary_repo.json';
  static const String jsonDiaryItem = 'assets/json/notion_diary_item.json';

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
  static const String jTypeImage = 'image';
  static const String jTypeDate = 'date';
  static const String jTypeStart = 'start';
  static const String jTypeEnd = 'end';
  static const String jTypeRichText = 'rich_text';
  static const String jTypeCreatedTime = 'created_time';
  static const String jTypeExternal = 'external';
  static const String jTypeUrl = 'url';

  static const String jStatus = 'Status';
  static const String jBrief = 'Brief';
  static const String jName = 'Name';
  static const String jDate = 'Date';
  static const String jTags = 'Tags';
  static const String jDuration = 'Duration';
  static const String jReminderTime = 'Reminder Time';
  static const String jCreated = 'Created';
  static const String jLocation = 'Location';
  static const String jWeather = 'Weather';

  static Future<dynamic?> loadTemplate(String pageId, int actionType) async {
    String path;
    switch (actionType) {
      case 0:
        path = jsonSimpleList;
        break;
      case 1:
        path = jsonTaskList;
        break;
      case 2:
        path = jsonDiaryRepo;
        break;
      default:
        path = jsonSimpleList;
    }
    final json = await rootBundle.loadString(path);
    if (json != null) {
      final map = jsonDecode(json);
      map[jParent][jPageId] = pageId;
      return map;
    }
    return null;
  }

  static dynamic simpleItem(String databaseId,
      {required String title, String? brief}) async {
    final json = await rootBundle.loadString(jsonSimpleItem);
    if (json != null) {
      final map = jsonDecode(json);
      map[jParent][jDatabaseId] = databaseId;
      map[jProperties][jName][jTypeTitle][0][jTypeText][jTypeContent] = title;
      map[jTypeChildren][0][jTypeParagraph][jTypeRichText][0][jTypeText]
          [jTypeContent] = brief;
      return map;
    }
    return null;
  }

  static dynamic taskItem(String databaseId,
      {required String title,
      required String statusTitle,
      required String createdTime,
      List<String>? links,
      String? brief,
      String? endTime,
      List<String>? tags,
      String? reminderTime}) async {
    final json = await rootBundle.loadString(jsonTaskItem);
    if (json != null) {
      final map = jsonDecode(json);
      map[jParent][jDatabaseId] = databaseId;
      map[jProperties][jName][jTypeTitle][0][jTypeText][jTypeContent] = title;
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
      if (links != null && links.isNotEmpty) {
        links.forEach((element) {
          if (!element.startsWith('http')) {
            element = 'https://${element}';
          }
          (map[jTypeChildren] as List).insert(0, {
            "object": "block",
            "bookmark": {"url": element}
          });
        });
      }
      return map;
    }
    return null;
  }

  static dynamic diaryItem(
    String databaseId, {
    required String title,
    String? location,
    String? weather,
    String? brief,
    String? weatherUploadUrl,
    String? date,
    List<String>? tags,
  }) async {
    final json = await rootBundle.loadString(jsonDiaryItem);
    if (json != null) {
      final map = jsonDecode(json);
      map[jParent][jDatabaseId] = databaseId;
      map[jProperties][jName][jTypeTitle][0][jTypeText][jTypeContent] = title;
      map[jProperties][jDate][jTypeDate][jTypeStart] = date;
      map[jProperties][jTags][jTypeMultiSelect][0][jTypeName] = tags?[0];
      map[jProperties][jLocation][jTypeRichText][0][jTypeText][jTypeContent] =
          location;
      map[jProperties][jWeather][jTypeRichText][0][jTypeText][jTypeContent] =
          weather;
      map[jTypeChildren][1][jTypeParagraph][jTypeRichText][0][jTypeText]
          [jTypeContent] = brief;
      map[jTypeChildren][0][jTypeImage][jTypeExternal][jTypeUrl] =
          weatherUploadUrl;
      return map;
    }
    return null;
  }

  static dynamic databaseProperties({String? title}) {
    if (title != null) {
      final map = Map<String, dynamic>();
      List list = [
        {
          'text': {'content': title}
        }
      ];
      map[jTypeTitle] = list;
      return map;
    }
    return null;
  }

  static dynamic itemProperties({
    String? title,
    List<String>? tags,
    String? createdTime,
    String? reminderTime,
    String? endTime,
    String? statusTitle,
  }) {
    final map = Map<String, dynamic>();
    map[jProperties] = {};
    if (title != null && title.isNotEmpty) {
      map[jProperties][jName] = {
        'title': [
          {
            'text': {'content': '${title}'}
          }
        ]
      };
    }
    if (tags != null && tags.length > 0) {
      map[jProperties][jTags] = {
        'multi_select': [
          {'name': '${tags[0]}'}
        ]
      };
    }
    if (reminderTime != null && reminderTime.isNotEmpty) {
      map[jProperties][jReminderTime] = {
        "date": {
          "start": "${reminderTime}",
        }
      };
    }
    if (endTime != null && endTime.isNotEmpty) {
      map[jProperties][jDuration] = {
        "date": {
          "start": "$createdTime",
          "end": "$endTime",
        }
      };
    }
    if (statusTitle != null && statusTitle.isNotEmpty) {
      map[jProperties][jStatus] = {
        'select': {'name': '$statusTitle'}
      };
    }
    return map;
  }

  static dynamic toDoBlockChildren(
      {required String text, List<String>? links}) async {
    final json = await rootBundle.loadString(jsonBlockChildren);
    if (json != null) {
      final map = jsonDecode(json);
      map[jTypeChildren][0][jTypeParagraph][jTypeRichText][0][jTypeText]
              [jTypeContent] = '''
${DateTime.now().toIso8601String()}
${text}
      ''';
      if (links != null && links.isNotEmpty) {
        links.forEach((element) {
          if (!element.startsWith('http')) {
            element = 'https://${element}';
          }
          (map[jTypeChildren] as List).insert(0, {
            "object": "block",
            "bookmark": {"url": element}
          });
        });
      }
      return map;
    }
    return null;
  }

  static dynamic simpleBlockChildren(String text) async {
    final json = await rootBundle.loadString(jsonBlockChildren);
    if (json != null) {
      final map = jsonDecode(json);
      map[jTypeChildren][0][jTypeParagraph][jTypeRichText][0][jTypeText]
              [jTypeContent] = '''
${DateTime.now().toIso8601String()}
${text}
      ''';
      return map;
    }
    return null;
  }
}
