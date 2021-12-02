import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:spark_list/resource/db_provider.dart';

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
  final DbSparkProvider _dBProvider;
  final DbProvider _dbProvider;
  final DataProvider _dataProvider;
  Locale? _deviceLocale;

  ConfigViewModel(this._dBProvider, this._dataProvider, this._dbProvider);

  void set settingsOpenNotifier(bool open) {
    isSettingsOpenNotifier = open;
    notifyListeners();
  }

  Locale? initLocale(Locale? locale) {
    _deviceLocale = locale;
    final defaultLocale = _dataProvider.defaultLocale;
    if (defaultLocale == null) {
      return locale;
    } else if (defaultLocale == 'zh') {
      return Locale('zh', '');
    } else {
      return Locale('en', '');
    }
  }

  Future<String?> getDefaultLocale() async {
    final locale = await _dataProvider.getLocale();
    if (locale == null) {
      return _deviceLocale?.languageCode;
    } else {
      return locale;
    }
  }

  Future savePerfLocale(Locale locale) async {
    await _dataProvider.saveLocale(locale);
  }

  Future<int?> getAlertPeriod() async {
    return await _dataProvider.getAlertPeriod();
  }

  Future<String?> getRetrospectTime() async {
    return await _dataProvider.getRetrospectTime();
  }

  Future saveAlertPeriod(int period) async {
    await _dataProvider.saveAlertPeriod(period);
  }

  Future saveRetrospectTime(String time) async {
    await _dataProvider.saveRetrospectTime(time);
  }

  Future getCategoryList() async {
    final list = await _dbProvider.categoryList;
    list.forEach((element) {
      categoryDemosList.add(CategoryItem(
          name: '${element.name}',
          icon: Icon(
            Icons.article_outlined,
            color: Colors.blue,
          ),
          color: Colors.blue));
    });
    notifyListeners();
  }

  Future initCategoryDemosList() async {
    await _dbProvider.countCategories().then((value) async {
      if (value == 0) {
        await _dbProvider.setCategories();
      }
    });
    // categoryDemosList = List.of([
    //   CategoryItem(
    //       name: 'To Do',
    //       icon: Icon(
    //         Icons.article_outlined,
    //         color: Colors.blue,
    //       ),
    //       color: Colors.blue),
    //   CategoryItem(
    //       name: 'To Watch',
    //       icon: Icon(
    //         Icons.movie_outlined,
    //         color: Colors.yellow,
    //       ),
    //       color: Colors.yellow),
    //   CategoryItem(
    //       name: 'To Read',
    //       icon: Icon(
    //         Icons.menu_book_outlined,
    //         color: Colors.red,
    //       ),
    //       color: Colors.red),
    //   CategoryItem(
    //       name: 'Alert',
    //       icon: Icon(
    //         Icons.add_alert,
    //         color: Colors.orangeAccent,
    //       ),
    //       color: Colors.orangeAccent),
    //   CategoryItem(
    //       name: 'Work',
    //       icon: Icon(
    //         Icons.work_outline,
    //         color: Colors.greenAccent,
    //       ),
    //       color: Colors.greenAccent),
    //   CategoryItem(
    //       name: 'To Learn',
    //       icon: Icon(
    //         Icons.school_outlined,
    //         color: Colors.black,
    //       ),
    //       color: Colors.black),
    // ]);
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
