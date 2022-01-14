import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/config/api.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/resource/http.dart';

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

  LinkNotionViewModel() {
    dsProvider.getNotionUser().then((value) {
      if (value != null) {
        avatarUrl = value.avatarUrl ?? '';
        email = value.person?.email ?? '';
        name = value.name ?? '';
        notifyListeners();
      }
    });
  }

  Future<Results?> syncUserInfo(String token) async {
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
          notifyListeners();
          dsProvider.saveNotionUser(user);
          return user;
        }
      }
    }
    return null;
  }

  Future deleteUser() {
    avatarUrl = '';
    email = '';
    name = '';
    notifyListeners();
    return dsProvider.deleteNotionUser();
  }
}
