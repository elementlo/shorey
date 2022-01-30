import 'package:spark_list/config/api.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/resource/http_provider.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/28
/// Description:
///

class NotionWorkFlow {
  NotionWorkFlow._() : actions = _NotionActions();
  static final NotionWorkFlow _instance = NotionWorkFlow._();
  _NotionActions actions;

  factory NotionWorkFlow() {
    return _instance;
  }

  Future linkNotionAccount(String token) async {
    final user = await actions.retrieveUser(token);
    if (user != null) {

    }
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
          // avatarUrl = user.avatarUrl;
          // name = user.name;
          // email = user.person?.email;
          // user.token = token;
          // notifyListeners();
          // dsProvider.saveNotionUser(user);
          return user;
        }
      }
    }
    return null;
  }
}
