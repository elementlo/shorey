import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shorey/base/ext.dart';
import 'package:shorey/database/database.dart';
import 'package:shorey/model/notion_database_model.dart';
import 'package:shorey/model/notion_page_model.dart';
import 'package:shorey/resource/data_provider.dart';
import 'package:shorey/resource/http_provider.dart';

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

  Future updateDatabase(String databaseId, NotionDatabase database)async{
    if(database.title!=null && database.title!.length >0){
      final param = await NotionDatabaseTemplate.databaseProperties(title: database.title![0].text?.content??'');
      if(param != null){
        final response = await dio.patch('${notionDatabase}/${databaseId}', data: param);
        if(response.success){}
      }

    }
  }

  Future<String?> addItem(String databaseId, ToDo todo,
      {List<String>? links});

  Future updateTaskProperties(String? pageId, ToDosCompanion todo);

  Future appendBlockChildren(String? pageId, {required String text, List<String>? links});
}
