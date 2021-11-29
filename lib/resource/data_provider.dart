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

class DataProvider {
  static const String storeName = 'store.db';
  static const int kVersion1 = 1;
  final lock = Lock(reentrant: true);
  final DatabaseFactory dbFactory = databaseFactoryIo;
  Database? db;
  String? defaultLocale;

  final dataStore = StoreRef.main();

  DataProvider();

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

  Future<String?> getLocale() async {
    defaultLocale = await dataStore.record('locale').get(db!);
    return defaultLocale;
  }

  Future saveLocale(Locale locale) async {
    await dataStore.record('locale').put(db!, locale.languageCode);
  }

  Future saveAlertPeriod(int period) async {
    await dataStore
        .record(
          'alert_period',
        )
        .put(db!, period);
  }

  Future<int?> getAlertPeriod() async {
    return await dataStore.record('alert_period').get(db!);
  }

  Future saveRetrospectTime(String time) async {
    await dataStore
        .record(
          'retrospect_time',
        )
        .put(db!, time);
  }

  Future<String?> getRetrospectTime() async {
    return await dataStore.record('retrospect_time').get(db!);
  }

  Future<String?> getMantra() async {
    return await dataStore.record('mantra').get(db!);
  }

  Future saveMantra(String mantra) async {
    await dataStore.record('mantra').put(db!, mantra);
  }
}
