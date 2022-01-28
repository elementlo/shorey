import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/resource/http_provider.dart';

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
  Locale? _deviceLocale;
  Stream<List<Category>>? categoryStream;

  void set settingsOpenNotifier(bool open) {
    isSettingsOpenNotifier = open;
    notifyListeners();
  }

  Future configDio() async {
    final user = await dsProvider.getNotionUser();
    if (user != null) {
      final token = user.token;
      dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    }
  }

  Locale? initLocale(Locale? locale) {
    _deviceLocale = locale;
    final defaultLocale = dsProvider.defaultLocale;
    if (defaultLocale == null) {
      return locale;
    } else if (defaultLocale == 'zh') {
      return Locale('zh', '');
    } else {
      return Locale('en', '');
    }
  }

  Future<String?> getDefaultLocale() async {
    final locale = await dsProvider.getLocale();
    if (locale == null) {
      return _deviceLocale?.languageCode;
    } else {
      return locale;
    }
  }

  Future savePerfLocale(Locale locale) async {
    await dsProvider.saveLocale(locale);
  }

  Future<int?> getAlertPeriod() async {
    return await dsProvider.getAlertPeriod();
  }

  Future<String?> getRetrospectTime() async {
    return await dsProvider.getRetrospectTime();
  }

  Future saveAlertPeriod(int period) async {
    await dsProvider.saveAlertPeriod(period);
  }

  Future saveRetrospectTime(String time) async {
    await dsProvider.saveRetrospectTime(time);
  }

  Future getCategoryList() async {
    categoryStream = dbProvider.categoryList;
    categoryStream?.listen((event) {
      categoryDemosList.clear();
      event.forEach((element) {
        if (element.name != 'mainfocus') {
          categoryDemosList.add(CategoryItem(
            element.id,
            colorId: element.colorId,
            iconId: element.iconId,
            name: '${element.name}',
            notionDatabaseId: element.notionDatabaseId,
            icon: Icon(
              SIcons.iconMap[element.iconId],
              color: Color(SColor.colorMap[element.colorId]!),
            ),
          ));
        }
      });
      notifyListeners();
    });
    // final list = await _dbProvider.categoryList;
    // list.forEach((element) {
    //   if(element.name != 'mainfocus')
    //   categoryDemosList.add(CategoryItem(element.id,
    //       name: '${element.name}',
    //       icon: Icon(
    //         SIcons.iconMap[element.iconId],
    //         color: Color(SColor.colorMap[element.colorId]!),
    //       ),));
    // });
    // notifyListeners();
  }

  Future initCategoryDemosList() async {
    await dbProvider.countCategories().then((value) async {
      if (value == 0) {
        await dbProvider.setCategories();
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

  @override
  void dispose() {
    super.dispose();
  }
}
