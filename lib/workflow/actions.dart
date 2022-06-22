import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/base/ext.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/model/notion_database_model.dart';
import 'package:spark_list/model/notion_page_model.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:spark_list/resource/http_provider.dart';

import '../config/api.dart';
import '../main.dart';
import '../model/notion_database_template.dart';
import '../model/notion_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/4/21
/// Description:
///

abstract class NotionActions {
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

  Future<List<dynamic>> searchObjects({required String keywords}) async {
    final List<dynamic> list = [];
    final response = await dio
        .post('${searchNotionObjects}', data: {'query': '${keywords}'});
    if (response.success) {
      response.data['results'].forEach((value) {
        if(value['object'] == 'page'){
          list.add(NotionPage.fromJson(value));
        }else if(value['object']=='database'){
          list.add(NotionDatabase.fromJson(value));
        }
      });
    }
    return list;
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

  @override
  Future<NotionDatabase?> createDatabase(String pageId, int actionType) async {
    final param = await NotionDatabaseTemplate.loadTemplate(pageId, actionType);
    if (param != null) {
      final response = await dio.post('${notionDatabase}', data: param);
      if (response.success) {
        return NotionDatabase.fromJson(response.data);
      }
    }
    return null;
  }


  Future<String?> addItem(String databaseId, ToDo todo,
      {List<String>? links});

  Future updateTaskProperties(String? pageId, ToDosCompanion todo);

  Future appendBlockChildren(String? pageId, {required String text, List<String>? links});
}
