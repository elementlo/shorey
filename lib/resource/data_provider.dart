import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:synchronized/synchronized.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/11/25
/// Description:
///

class StoreKey {
  static const alertPeriod = 'alert_period';
  static const retrospectTime = 'retrospect_time';
  static const mantra = 'mantra';
  static const notionUser = 'notion_user';
}

class DataStoreProvider {
  static const String storeName = 'store.db';
  static const int kVersion1 = 1;
  final lock = Lock(reentrant: true);
  final DatabaseFactory dbFactory = databaseFactoryIo;
  Database? db;
  String? defaultLocale;

  final dataStore = StoreRef.main();

  Future<Database> open() async {
    final path = await getApplicationDocumentsDirectory();
    await path.create(recursive: true);
    var dbPath = join(path.path, storeName);
    return await openPath(dbPath);
  }

  Future<Database> openPath(String path) async {
    db = await dbFactory.openDatabase(path, version: kVersion1);
    return db!;
  }

  Future<Database> get ready async =>
      db ??= await lock.synchronized<Database>(() async {
        if (db == null) {
          await open();
        }
        return db!;
      });

  Future<T?> getValue<T>(String key) async {
    return (await dataStore.record(key).get(db!)) as T?;
  }

  Future saveValue<T>(String key, T value) {
    return dataStore.record(key).put(db!, value);
  }

  Future deleteValue(String key){
    return dataStore.record(key).delete(db!);
  }

  Future<String?> getLocale() async {
    defaultLocale = await dataStore.record('locale').get(db!) as String?;
    return defaultLocale;
  }

  Future saveLocale(Locale locale) async {
    await dataStore.record('locale').put(db!, locale.languageCode);
  }

  // Future saveAlertPeriod(int period) async {
  //   await dataStore
  //       .record(
  //         'alert_period',
  //       )
  //       .put(db!, period);
  // }

  // Future<int?> getAlertPeriod() async {
  //   return await dataStore.record('alert_period').get(db!);
  // }

  // Future saveRetrospectTime(String time) async {
  //   await dataStore
  //       .record(
  //         'retrospect_time',
  //       )
  //       .put(db!, time);
  // }

  // Future<String?> getRetrospectTime() async {
  //   return await dataStore.record('retrospect_time').get(db!);
  // }

  // Future<String?> getMantra() async {
  //   return await dataStore.record('mantra').get(db!);
  // }

  // Future saveMantra(String mantra) async {
  //   await dataStore.record('mantra').put(db!, mantra);
  // }

  // Future saveNotionUser(Results user) {
  //   return dataStore.record('notion_user').put(db!, user.toJson());
  // }
  //
  // Future<Results?> getNotionUser() async {
  //   final user =
  //       await dataStore.record('notion_user').get(db!) as Map<String, dynamic>?;
  //   if (user != null) {
  //     return Results.fromJson(user);
  //   }
  //   return null;
  // }

  // Future deleteNotionUser() {
  //   return dataStore.record('notion_user').delete(db!);
  // }
  //
  // Future saveRootNotionPage(NotionPage page) {
  //   return dataStore.record('root_notion_page').put(db!, page.toJson());
  // }
  //
  // Future<NotionPage?> getRootNotionPage() async {
  //   final page = await dataStore.record('root_notion_page').get(db!)
  //       as Map<String, dynamic>?;
  //   if (page != null) {
  //     return NotionPage.fromJson(page);
  //   }
  //   return null;
  // }
  //
  // Future deleteRootNotionPage() {
  //   return dataStore.record('root_notion_page').delete(db!);
  // }
}
