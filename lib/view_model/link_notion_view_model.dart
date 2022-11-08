import 'package:shorey/base/view_state_model.dart';
import 'package:shorey/model/notion_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/13
/// Description:
///

class LinkNotionViewModel extends ViewStateModel {

  Results? user;

  set setUser(Results? user) {
    this.user = user;
    notifyListeners();
  }

}
