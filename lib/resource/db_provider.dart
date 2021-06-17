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
  	CREATE TABLE ${DatabaseRef.tableToDo} (
  	${DatabaseRef.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
  	${DatabaseRef.toDoContent} TEXT,
  	${DatabaseRef.toDoCreatedTime} INT NOT NULL,
  	${DatabaseRef.status} INT)
  	''');
    await db.execute('''
  	CREATE TABLE ${DatabaseRef.tableHeatMap} (
  	${DatabaseRef.heatPointId} INTEGER PRIMARY KEY AUTOINCREMENT,
  	${DatabaseRef.heatPointlevel} INT,
  	${DatabaseRef.heatPointcreatedTime} INT NOT NULL)
  	''');
  }

  ///status: 0: 已完成 1: 未完成 2: 已删除
  Future<int> insertToDo(ToDoModel model) async {
    return await db.insert(DatabaseRef.tableToDo, {
      '${DatabaseRef.toDoContent}': model.content,
      '${DatabaseRef.toDoCreatedTime}': model.createdTime,
      '${DatabaseRef.status}': model.status,
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

  Future<ToDoModel> getTopToDo() async {
    List<Map> list = await db.rawQuery('''
    SELECT * FROM ${DatabaseRef.tableToDo}
    WHERE ${DatabaseRef.columnId} = (SELECT MAX(${DatabaseRef.columnId})
    FROM ${DatabaseRef.tableToDo})
    ''');
    if (list.isNotEmpty) {
      return ToDoModel(
          id: list.first['${DatabaseRef.columnId}'],
          createdTime: list.first['${DatabaseRef.toDoCreatedTime}'],
          content: list.first['${DatabaseRef.toDoContent}']);
    }
    return null;
  }

  Future<int> insertHeatPoint(int heatLevel, int createdTime) async {
    return await db.insert(DatabaseRef.tableHeatMap, {
      '${DatabaseRef.heatPointlevel}': heatLevel,
      '${DatabaseRef.heatPointcreatedTime}': createdTime
    });
  }

  Future updateToDoStatus(ToDoModel model) async {
    return await db.update(
        DatabaseRef.tableToDo,
        {
          DatabaseRef.toDoContent: model.content,
          DatabaseRef.status: model.status,
        },
        where: '${DatabaseRef.columnId} = ?',
        whereArgs: [model.id]);
  }
  
  Future updateHeatPoint(int difference) async{
    return await db.execute('''
    UPDATE ${DatabaseRef.tableHeatMap}
    SET ${DatabaseRef.heatPointlevel} = ${DatabaseRef.heatPointlevel} + ${difference}
    WHERE ${DatabaseRef.columnId} IN (SELECT ${DatabaseRef.columnId} FROM ${DatabaseRef.tableHeatMap}
    ORDER BY ${DatabaseRef.columnId} DESC
    LIMIT 1)
    ''');
  }
}
