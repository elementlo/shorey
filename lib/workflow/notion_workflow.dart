import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/config/api.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:spark_list/resource/http_provider.dart';
import 'package:spark_list/workflow/workflow.dart';

import '../view_model/link_notion_view_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/28
/// Description:
///

class NotionWorkFlow with ChangeNotifier{
  NotionWorkFlow._() : actions = _NotionActions();
  static final NotionWorkFlow _instance = NotionWorkFlow._();
  _NotionActions actions;
  Results? user;

  factory NotionWorkFlow() {
    return _instance;
  }

  Future<Results?> linkNotionAccount(String token) async {
    final result = await actions.retrieveUser(token);
    if (result != null) {
      await actions.persistUser(result);
      user = result;
      notifyListeners();
      return user;
    }
    return null;
  }

  Future deleteUser() async{
    return actions.deleteUser();
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

  Future persistUser(Results user) async {
    return dsProvider.saveValue<Map<String, dynamic>>(
        StoreKey.notionUser, user.toJson());
  }

  Future deleteUser() async{
    return dsProvider.deleteValue(StoreKey.notionUser);
  }
}
