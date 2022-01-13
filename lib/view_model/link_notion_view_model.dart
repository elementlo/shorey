import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/model/notion_model.dart';
import 'package:spark_list/resource/http.dart';
import 'package:spark_list/config/api.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/13
/// Description: 
///

class LinkNotionViewModel extends ViewStateModel{
  final avatarUrl = '';

  Future syncUserInfo(String token) async{
    dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    final response = await dio.get(notionUsers);
    if (response.success){
      final model = NotionUsersInfo.fromJson(response.data);
    }

  }

}

