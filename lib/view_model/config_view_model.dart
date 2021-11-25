import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/model/model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

class ConfigViewModel extends ViewStateModel {
  static ThemeMode themeMode = ThemeMode.system;

  bool isSettingsOpenNotifier = false;

  List<CategoryItem> categoryDemosList = [];

  Locale? defaultLocale;

  void set settingsOpenNotifier(bool open) {
    isSettingsOpenNotifier = open;
    notifyListeners();
  }
//I/flutter (24107): default: en_US
// I/flutter (24107): zh_CN
  void initLocale(){
    defaultLocale = Locale(Intl.getCurrentLocale(), '');
    print('default: ${defaultLocale}');
    notifyListeners();
  }

  void updateLocale(Locale locale){
    defaultLocale = locale;
    notifyListeners();
  }

  void initCategoryDemosList() {
    categoryDemosList = List.of([
      CategoryItem(
          name: 'To Do',
          icon: Icon(
            Icons.article_outlined,
            color: Colors.blue,
          ),
          color: Colors.blue),
      CategoryItem(
          name: 'To Watch',
          icon: Icon(
            Icons.movie_outlined,
            color: Colors.yellow,
          ),
          color: Colors.yellow),
      CategoryItem(
          name: 'To Read',
          icon: Icon(
            Icons.menu_book_outlined,
            color: Colors.red,
          ),
          color: Colors.red),
      CategoryItem(
          name: 'Alert',
          icon: Icon(
            Icons.add_alert,
            color: Colors.orangeAccent,
          ),
          color: Colors.orangeAccent),
      CategoryItem(
          name: 'Work',
          icon: Icon(
            Icons.work_outline,
            color: Colors.greenAccent,
          ),
          color: Colors.greenAccent),
      CategoryItem(
          name: 'To Learn',
          icon: Icon(
            Icons.school_outlined,
            color: Colors.black,
          ),
          color: Colors.black),
    ]);
  }

  static SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance!.window.platformBrightness;
    }

    final overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return overlayStyle;
  }
}
