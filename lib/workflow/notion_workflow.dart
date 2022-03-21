import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/base/ext.dart';
import 'package:spark_list/base/regexp.dart';
import 'package:spark_list/config/api.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/notion_database_model.dart';
import 'package:spark_list/model/notion_database_template.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:spark_list/resource/http_provider.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/28
/// Description:
///

class NotionWorkFlow with ChangeNotifier {
  NotionWorkFlow._() : _actions = _NotionActions();
  static final NotionWorkFlow _instance = NotionWorkFlow._();
  _NotionActions _actions;
  Results? user;

  factory NotionWorkFlow() {
    return _instance;
  }

  Future<Results?> linkAccount(String token) async {
    final result = await _actions.retrieveUser(token);
    if (result != null) {
      result.token = token;
      await _actions.persistUser(result);
      user = result;
      notifyListeners();
      return user;
    }
    return null;
  }

  Future deleteUser() {
    user = null;
    notifyListeners();
    return _actions.deleteUser();
  }

  Future<Results?> getUser() async {
    user = await _actions.getUser();
    notifyListeners();
    return user;
  }

  Future<NotionDatabase?> linkDatabase(String databaseId) async {
    return _actions.retrieveDatabase(databaseId);
  }

  Future<String?> addTaskItem(String databaseId, ToDo todo) async {
    final links = <String>[];
    if (todo.brief != null && todo.brief!.isNotEmpty) {
      Iterable<RegExpMatch> matches =
          RegexFormater.regex.allMatches(todo.brief!);
      matches.forEach((match) {
        links.add(todo.brief!.substring(match.start, match.end));
      });
    }
    return _actions.addTaskItem(databaseId, todo, links: links);
  }

  Future<NotionDatabase?> createDatabase(String pageId) {
    return _actions.createDatabase(pageId);
  }

  Future updateTaskProperties(String? pageId, ToDosCompanion todo) {
    return _actions.updateTaskProperties(pageId, todo);
  }

  Future appendBlockChildren(String? pageId, {required String text}) {
    Iterable<RegExpMatch> matches = RegexFormater.regex.allMatches(text);
    final links = <String>[];
    matches.forEach((match) {
      links.add(text.substring(match.start, match.end));
    });
    return _actions.appendBlockChildren(pageId, text: text, links: links);
  }
}

class _NotionActions {
  _NotionActions._();

  static final _NotionActions _instance = _NotionActions._();

  factory _NotionActions() {
    return _instance;
  }

  Future<Results?> retrieveUser(String token) async {
    dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    final response = await dio.get(notionUsers);
    if (response.success) {
      final users = NotionUsersInfo.fromJson(response.data);
      for (int i = 0; i < (users.results?.length ?? 0); i++) {
        final user = users.results![i];
        if (user.type == 'person') {
          return user;
        }
      }
    }
    return null;
  }

  Future<NotionDatabase?> retrieveDatabase(String databaseId) async {
    try {
      final response = await dio.get('${notionDatabase}/${databaseId}');
      if (response.success) {
        return NotionDatabase.fromJson(response.data);
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  Future persistUser(Results user) {
    return dsProvider.saveValue<Map<String, dynamic>>(
        StoreKey.notionUser, user.toJson());
  }

  Future deleteUser() {
    return dsProvider.deleteValue(StoreKey.notionUser);
  }

  Future<Results?> getUser() async {
    final value =
        await dsProvider.getValue<Map<String, dynamic>>(StoreKey.notionUser);
    if (value != null) {
      return Results.fromJson(value);
    }
    return null;
  }

  Future<String?> addTaskItem(String databaseId, ToDo todo,
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

  Future<NotionDatabase?> createDatabase(String pageId) async {
    final param = await NotionDatabaseTemplate.taskList(pageId);
    if (param != null) {
      final response = await dio.post('${notionDatabase}', data: param);
      if (response.success) {
        return NotionDatabase.fromJson(response.data);
      }
    }
    return null;
  }

  Future updateTaskProperties(String? pageId, ToDosCompanion todo) async {
    if (pageId != null && pageId != '') {
      final param = await NotionDatabaseTemplate.itemProperties(
          title: todo.content == Value.absent() ? null : todo.content.value,
          tags: todo.tags == Value.absent() ? null : [todo.tags.value??''],
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

  Future appendBlockChildren(String? pageId,
      {required String text, List<String>? links}) async {
    if (pageId != null && pageId != '') {
      final param =
          await NotionDatabaseTemplate.blockChildren(text: text, links: links);
      final response =
          await dio.patch('${notionBlocks}/${pageId}/children', data: param);
      if (response.success) {}
    }
  }
}
