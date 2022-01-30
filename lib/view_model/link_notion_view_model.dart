import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/config/api.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/model/notion_page_model.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:spark_list/resource/http_provider.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/13
/// Description:
///

class LinkNotionViewModel extends ViewStateModel {
  String? avatarUrl = '';
  String? email = '';
  String? name = '';
  String? coverUrl = '';
  String? title = '';
  String? titleIcon = '';

  LinkNotionViewModel() {
    dsProvider.getValue<Map<String, dynamic>>(StoreKey.notionUser).then((value) {
      if (value != null) {
        final user = Results.fromJson(value);
        avatarUrl = user.avatarUrl ?? '';
        email = user.person?.email ?? '';
        name = user.name ?? '';
        notifyListeners();
      }
    });
  }

  Future<Results?> linkNotionAccount(String token) async {
    dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    final response = await dio.get(notionUsers);
    if (response.success) {
      final users = NotionUsersInfo.fromJson(response.data);
      for (int i = 0; i < (users.results?.length ?? 0); i++) {
        final user = users.results![i];
        if (user.type == 'person') {
          avatarUrl = user.avatarUrl;
          name = user.name;
          email = user.person?.email;
          user.token = token;
          notifyListeners();
          dsProvider.saveValue<Map<String, dynamic>>(StoreKey.notionUser, user.toJson());
          return user;
        }
      }
    }
    return null;
  }

  Future deleteUser() async {
    avatarUrl = '';
    email = '';
    name = '';
    notifyListeners();
    await dsProvider.deleteValue(StoreKey.notionUser);
  }
}
