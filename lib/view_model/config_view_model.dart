import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shorey/base/view_state_model.dart';
import 'package:shorey/config/config.dart';
import 'package:shorey/database/database.dart';
import 'package:shorey/main.dart';
import 'package:shorey/model/model.dart';
import 'package:shorey/model/notion_model.dart';
import 'package:shorey/resource/data_provider.dart';
import 'package:shorey/resource/http_provider.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

class ConfigViewModel extends ViewStateModel {
  static ThemeMode themeMode = ThemeMode.system;

  bool isSettingsOpenNotifier = false;

  bool _linkedNotion = false;

  bool get linkedNotion => _linkedNotion;

  List<CategoryItem> categoryDemosList = [];
  Locale? _deviceLocale;
  Stream<List<Category>>? categoryStream;

  void set settingsOpenNotifier(bool open) {
    isSettingsOpenNotifier = open;
    notifyListeners();
  }

  void updateLinkedStatus(bool linked) {
    _linkedNotion = linked;
  }

  Future configDio(Results? user) async {
    if (user?.token != null) {
      updateLinkedStatus(true);
      dio.options.headers.addAll({'Authorization': 'Bearer ${user?.token}'});
    }
  }

  Locale? initLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    final defaultLocale = dsProvider.defaultLocale;
    if (defaultLocale == null) {
      if (locale?.languageCode != 'en' && locale?.languageCode != 'zh') {
        _deviceLocale = Locale('en', '');
        return Locale('en', '');
      }
      _deviceLocale = locale;
      return locale;
    } else if (defaultLocale == 'zh') {
      _deviceLocale = Locale('zh', '');
      return Locale('zh', '');
    } else {
      _deviceLocale = Locale('en', '');
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
    return await dsProvider.getValue<int>(StoreKey.alertPeriod);
  }

  Future<String?> getRetrospectTime() async {
    return await dsProvider.getValue<String>(StoreKey.retrospectTime);
  }

  Future saveAlertPeriod(int period) async {
    await dsProvider.saveValue<int>(StoreKey.alertPeriod, period);
  }

  Future saveRetrospectTime(String time) async {
    await dsProvider.saveValue<String>(StoreKey.retrospectTime, time);
  }

  void getCategoryList() {
    categoryStream = dbProvider.categoryList;
    categoryStream?.listen((event) {
      categoryDemosList.clear();
      event.forEach((element) {
        if (element.name != 'mainfocus') {
          categoryDemosList.add(CategoryItem(
            element.id,
            autoSync: element.autoSync ?? true,
            colorId: element.colorId,
            iconId: element.iconId,
            name: '${element.name}',
            notionDatabaseId: element.notionDatabaseId,
            notionDatabaseType: element.notionDatabaseType,
            notionDatabaseName: element.notionDatabaseName,
            icon: Icon(
              SIcons.iconMap[element.iconId],
              color: Color(SColor.colorMap[element.colorId]!),
            ),
            color: Color(SColor.colorMap[element.colorId] ?? 1),
          ));
        }
      });
      notifyListeners();
    });
  }

  Future initCategoryDemosList() async {
    await dbProvider.countCategories().then((value) async {
      if (value == 0) {
        await dbProvider.setCategories();
      }
    });
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
        brightness = WidgetsBinding.instance.window.platformBrightness;
    }

    final overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;

    return overlayStyle;
  }

  Future<bool> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
