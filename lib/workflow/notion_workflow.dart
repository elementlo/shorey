import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/base/ext.dart';
import 'package:spark_list/base/regexp.dart';
import 'package:spark_list/config/api.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/model/notion_database_model.dart';
import 'package:spark_list/model/notion_database_template.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/resource/http_provider.dart';

import 'actions.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/28
/// Description:
///

// enum ActionType { mDefault, task, simple, diary }

class ActionType {
  static const int DEFAULT = -1;
  static const int SIMPLE = 0;
  static const int TASK = 1;
  static const int DIARY = 2;
}

class NotionWorkFlow with ChangeNotifier {
  NotionWorkFlow()
      : _defaultActions = _DefaultActions(),
        _simpleActions = _SampleListActions(),
        _taskActions = _TaskListActions(),
        _diaryActions = _DiaryActions();

  late _DefaultActions _defaultActions;
  late _TaskListActions _taskActions;
  late _SampleListActions _simpleActions;
  late _DiaryActions _diaryActions;

  Results? user;

  NotionActions _adaptAction(int type) {
    switch (type) {
      case ActionType.DEFAULT:
        return _defaultActions;
      case ActionType.SIMPLE:
        return _simpleActions;
      case ActionType.TASK:
        return _taskActions;
        case ActionType.DIARY:
          return _diaryActions;
      default:
        return _defaultActions;
    }
  }

  Future<Results?> linkAccount(String token) async {
    final result = await _defaultActions.retrieveUser(token);
    if (result != null) {
      result.token = token;
      await _defaultActions.persistUser(result);
      user = result;
      notifyListeners();
      return user;
    }
    return null;
  }

  Future deleteUser() {
    user = null;
    notifyListeners();
    return _defaultActions.deleteUser();
  }

  Future<Results?> getUser() async {
    user = await _defaultActions.getUser();
    notifyListeners();
    return user;
  }

  Future<NotionDatabase?> linkDatabase(String databaseId) async {
    return _defaultActions.retrieveDatabase(databaseId);
  }

  Future<String?> addTaskItem(String databaseId, ToDo todo,
      {required int actionType}) async {
    final action = _adaptAction(actionType);
    final links = <String>[];
    if (todo.brief != null && todo.brief!.isNotEmpty) {
      Iterable<RegExpMatch> matches =
          RegexFormater.regex.allMatches(todo.brief!);
      matches.forEach((match) {
        links.add(todo.brief!.substring(match.start, match.end));
      });
    }
    return action.addItem(databaseId, todo, links: links);
  }

  Future<NotionDatabase?> createDatabase(String pageId,
      {required int actionType}) {
    return _defaultActions.createDatabase(pageId, actionType);
  }

  Future updateDatabaseProperties(String databaseId, NotionDatabase database){
    return _defaultActions.updateDatabase(databaseId, database);
  }

  Future updateTaskProperties(String? pageId, ToDosCompanion todo,
      {required int actionType}) {
    final action = _adaptAction(actionType);
    return action.updateTaskProperties(pageId, todo);
  }

  Future appendBlockChildren(String? pageId,
      {required String text, required int actionType}) {
    final action = _adaptAction(actionType);
    Iterable<RegExpMatch> matches = RegexFormater.regex.allMatches(text);
    final links = <String>[];
    matches.forEach((match) {
      links.add(text.substring(match.start, match.end));
    });
    return action.appendBlockChildren(pageId, text: text, links: links);
  }

  Future<List<dynamic>> searchObjects({required String keywords}) {
    return _defaultActions.searchObjects(keywords: keywords);
  }
}

class _DefaultActions extends NotionActions {
  @override
  Future<String?> addItem(String databaseId, ToDo todo, {List<String>? links}) {
    throw UnimplementedError();
  }

  @override
  Future appendBlockChildren(String? pageId,
      {required String text, List<String>? links}) {
    throw UnimplementedError();
  }

  @override
  Future updateTaskProperties(String? pageId, ToDosCompanion todo) {
    throw UnimplementedError();
  }
}

class _TaskListActions extends NotionActions {
  _TaskListActions._();

  static final _TaskListActions _instance = _TaskListActions._();

  factory _TaskListActions() {
    return _instance;
  }

  @override
  Future<String?> addItem(String databaseId, ToDo todo,
      {List<String>? links}) async {
    final param = await NotionDatabaseTemplate.taskItem(databaseId,
        title: todo.content,
        brief: todo.brief ?? '',
        links: links,
        tags: ['${todo.tags}'],
        statusTitle: todo.statusTitle,
        createdTime: todo.createdTime.toIso8601String(),
        reminderTime: todo.alertTime?.toIso8601String());
    final response = await dio.post('${notionPages}', data: param);
    if (response.success) {
      return response.data['id'];
    }
    return null;
  }

  @override
  Future updateTaskProperties(String? pageId, ToDosCompanion todo) async {
    if (pageId != null && pageId != '') {
      final param = await NotionDatabaseTemplate.itemProperties(
          title: todo.content == Value.absent() ? null : todo.content.value,
          tags: todo.tags == Value.absent() ? null : [todo.tags.value ?? ''],
          statusTitle: todo.statusTitle,
          createdTime: todo.createdTime.value.toIso8601String(),
          endTime: todo.filedTime == Value.absent()
              ? null
              : todo.filedTime.value?.toIso8601String(),
          reminderTime: todo.alertTime == Value.absent()
              ? null
              : todo.alertTime.value?.toIso8601String());
      final response = await dio.patch('${notionPages}/${pageId}', data: param);
    }
  }

  @override
  Future appendBlockChildren(String? pageId,
      {required String text, List<String>? links}) async {
    if (pageId != null && pageId != '') {
      final param =
          await NotionDatabaseTemplate.toDoBlockChildren(text: text, links: links);
      final response =
          await dio.patch('${notionBlocks}/${pageId}/children', data: param);
      if (response.success) {}
    }
  }
}

class _SampleListActions extends NotionActions {
  @override
  Future<String?> addItem(String databaseId, ToDo todo,
      {List<String>? links}) async {
    final param = await NotionDatabaseTemplate.simpleItem(
      databaseId,
      title: todo.content,
      brief: todo.brief ?? '',
    );
    final response = await dio.post('${notionPages}', data: param);
    if (response.success) {
      return response.data['id'];
    }
    return null;
  }

  @override
  Future appendBlockChildren(String? pageId,
      {required String text, List<String>? links}) async {
    if (pageId != null && pageId != '') {
      final param =
          await NotionDatabaseTemplate.simpleBlockChildren(text);
      final response =
          await dio.patch('${notionBlocks}/${pageId}/children', data: param);
      if (response.success) {}
    }
  }

  @override
  Future updateTaskProperties(String? pageId, ToDosCompanion todo) async {
    if (pageId != null && pageId != '') {
      final param = await NotionDatabaseTemplate.itemProperties(
        title: todo.content == Value.absent() ? null : todo.content.value,
        createdTime: todo.createdTime.value.toIso8601String(),
      );
      final response = await dio.patch('${notionPages}/${pageId}', data: param);
      if (response.success) {}
    }
  }
}

class _DiaryActions extends NotionActions {
  @override
  Future<String?> addItem(String databaseId, ToDo todo,
      {List<String>? links,}) async {
    final param = await NotionDatabaseTemplate.diaryItem(
      databaseId,
      title: todo.content,
      brief: todo.brief ?? '',
      // location: location,
      // weather: weather
    );
    final response = await dio.post('${notionPages}', data: param);
    if (response.success) {
      return response.data['id'];
    }
    return null;
  }

  @override
  Future appendBlockChildren(String? pageId,
      {required String text, List<String>? links}) async {
    if (pageId != null && pageId != '') {
      final param =
      await NotionDatabaseTemplate.simpleBlockChildren(text);
      final response =
      await dio.patch('${notionBlocks}/${pageId}/children', data: param);
      if (response.success) {}
    }
  }

  @override
  Future updateTaskProperties(String? pageId, ToDosCompanion todo) async {
    if (pageId != null && pageId != '') {
      final param = await NotionDatabaseTemplate.itemProperties(
        title: todo.content == Value.absent() ? null : todo.content.value,
        createdTime: todo.createdTime.value.toIso8601String(),
      );
      final response = await dio.patch('${notionPages}/${pageId}', data: param);
      if (response.success) {}
    }
  }
}