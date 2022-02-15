import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/config/api.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/model/notion_page_model.dart';
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
    dsProvider.getNotionUser().then((value) {
      if (value != null) {
        avatarUrl = value.avatarUrl ?? '';
        email = value.person?.email ?? '';
        name = value.name ?? '';
        notifyListeners();
      }
    });
    dsProvider.getRootNotionPage().then((page) {
      if (page != null) {
        coverUrl = page.cover?.external?.url ?? '';
        title = page.properties?.title?.title?[0].plainText ?? '';
        titleIcon = page.icon?.type == 'emoji' ? page.icon?.emoji : '';
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
          dsProvider.saveNotionUser(user);
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
    await dsProvider.deleteRootNotionPage();
    await dsProvider.deleteNotionUser();
  }

  Future<NotionPage?> linkNotionRootPage(String pageId) async {
    final response = await dio.get('${retrieveNotionPages}/${pageId}');
    if (response.success) {
      final page = NotionPage.fromJson(response.data);
      coverUrl = page.cover?.external?.url;
      title = page.properties?.title?.title?[0].plainText;
      titleIcon = page.icon?.type == 'emoji' ? page.icon?.emoji : '';
      notifyListeners();
      dsProvider.saveRootNotionPage(page);
      return page;
    }
    return null;
  }

  Future deleteNotionRootPage() {
    coverUrl = '';
    title = '';
    titleIcon = '';
    notifyListeners();
    return dsProvider.deleteRootNotionPage();
  }
}
