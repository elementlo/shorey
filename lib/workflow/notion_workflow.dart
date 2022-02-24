import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spark_list/config/api.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/notion_database_model.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:spark_list/resource/http_provider.dart';
import 'package:spark_list/widget/category_list_item.dart';

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

  Future addItem() async {
    return _actions.addItem();
  }

  Future createDatabase(String pageId) async {
    return _actions.createDatabase(pageId);
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
    final response = await dio.get('${notionDatabase}/${databaseId}');
    if (response.success) {
      return NotionDatabase.fromJson(response.data);
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

  Future addItem() async {
    final response = await dio.post('${notionPages}', data: jsonMap);
    if (response.success) {}
    return null;
  }

  Future<NotionDatabase?> createDatabase(String pageId) async {
    final response =
        await dio.post('${notionDatabase}', data: jsonDecode(database));
  }
}
