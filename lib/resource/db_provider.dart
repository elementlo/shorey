import 'package:spark_list/config/config.dart';
import 'package:spark_list/model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:synchronized/synchronized.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/19/21
/// Description:
///

class DbSparkProvider {
  final lock = Lock(reentrant: true);
  Database db;

  Future<Database> get ready async => db ??= await lock.synchronized(() async {
        if (db == null) {
          await openPath();
        }
        return db;
      });

  Future openPath() async {
    // db = await dbFactory.openDatabase(path,
    // 		options: OpenDatabaseOptions(
    // 				version: kVersion1,
    // 				onCreate: (db, version) async {
    // 					await _createDb(db);
    // 				},
    // 				onUpgrade: (db, oldVersion, newVersion) async {
    // 					if (oldVersion < kVersion1) {
    // 						await _createDb(db);
    // 					}
    // 				}));
    db = await openDatabase(DatabaseRef.DbName, version: DatabaseRef.kVersion,
        onCreate: (db, version) async {
      await _createDb(db);
    });
  }

  Future _createDb(Database db) async {
    await db.execute('''
  	CREATE TABLE ${DatabaseRef.tableMainFocus} (
  	${DatabaseRef.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
  	${DatabaseRef.mainFocusContent} TEXT,
  	${DatabaseRef.mainFocusCreatedTime} INT NOT NULL)
  	''');
    await db.execute('''
  	CREATE TABLE ${DatabaseRef.tableHeatMap} (
  	${DatabaseRef.heatPointId} INTEGER PRIMARY KEY AUTOINCREMENT,
  	${DatabaseRef.heatPointlevel} INT,
  	${DatabaseRef.heatPointcreatedTime} INT NOT NULL)
  	''');
  }

  Future saveMainFocus(MainFocusModel model) async {
    await db.insert(DatabaseRef.tableMainFocus, {
      '${DatabaseRef.mainFocusContent}': model.content,
      '${DatabaseRef.mainFocusCreatedTime}': model.createdTime
    });
  }

  Future<HeatMapModel> getTopHeatPoint() async {
    List<Map> list = await db.rawQuery('''
    SELECT * FROM ${DatabaseRef.tableHeatMap}
    WHERE ${DatabaseRef.heatPointId} = (SELECT MAX(${DatabaseRef.heatPointId})
    FROM ${DatabaseRef.tableHeatMap})
    ''');
    if (list.isNotEmpty) {
      return HeatMapModel(
          createdTime: list.first['${DatabaseRef.heatPointcreatedTime}'],
          level: list.first['${DatabaseRef.heatPointlevel}']);
    }
    return null;
  }

  Future insertHeatPoint(int heatLevel, int createdTime) async {
    await db.insert(DatabaseRef.tableHeatMap, {
      '${DatabaseRef.heatPointlevel}': heatLevel,
      '${DatabaseRef.heatPointcreatedTime}': createdTime
    });
  }
}
