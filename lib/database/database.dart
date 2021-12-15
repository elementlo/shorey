import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:spark_list/config/config.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/12/1
/// Description:
///
part 'database.g.dart';

@DataClassName('ToDo')
class ToDos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get notificationId => integer().nullable()();

  DateTimeColumn get createdTime => dateTime()();

  DateTimeColumn get filedTime => dateTime().nullable()();

  DateTimeColumn get alertTime => dateTime().nullable()();

  TextColumn get content => text()();

  TextColumn get brief => text().nullable()();

  TextColumn get category => text().nullable()();

  //
  // String get formatFiledTime {
  //   var formatter = new DateFormat('yyyy-MM-dd');
  //   return formatter
  //       .format(DateTime.fromMillisecondsSinceEpoch(filedTime ?? 0));
  // }

  ///0: finished 1: going 2: deleted
  IntColumn get status => integer()();

  IntColumn get categoryId =>
      integer().customConstraint('NULLABLE REFERENCES categories(id) ON DELETE CASCADE')();
}

@DataClassName('HeatPoint')
class HeatGraph extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get level => integer()();

  DateTimeColumn get createdTime => dateTime()();
}

@DataClassName('UserAction')
class ActionsHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get earlyContent => text().nullable()();

  TextColumn get updatedContent => text()();

  DateTimeColumn get updatedTime => dateTime()();

  IntColumn get action => integer()();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get iconId => integer()();

  IntColumn get colorId => integer()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    print(dbFolder.parent);
    var file;
    if (Platform.isAndroid) {
      file = File(p.join(dbFolder.parent.path, 'databases/shorey.sqlite'));
    } else {
      file = File(p.join(dbFolder.path, 'shorey.sqlite'));
    }
    return NativeDatabase(file, logStatements: true);
  });
}

@DriftDatabase(tables: [ToDos, Categories, HeatGraph, ActionsHistory])
class DbProvider extends _$DbProvider {
  DbProvider() : super(_openConnection());

  @override
  int get schemaVersion => 1;


  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (m) async{
        await customStatement('PRAGMA foreign_keys = ON;');
      }
    );
  }

  Stream<List<Category>> get categoryList => select(categories).watch();

  Future<Map<String, int?>> get heatPointList async {
    List<HeatPoint> list = await select(heatGraph).get();
    Map<String, int?> mapPoints = Map();
    list.forEach((element) {
      DateTime dateTime = element.createdTime;
      String key = '${dateTime.year}${dateTime.month}${dateTime.day}';
      mapPoints[key] = element.level;
    });
    return mapPoints;
  }

  Future setCategories() async {
    await batch((batch) {
      batch.insertAll(categories, [
        CategoriesCompanion.insert(
            name: 'mainfocus', colorId: SColor.red, iconId: 0),
        CategoriesCompanion.insert(
            name: 'To Do',
            colorId: SColor.blue,
            iconId: SIcons.article_outlined),
        CategoriesCompanion.insert(
            name: 'To Watch',
            colorId: SColor.yellow,
            iconId: SIcons.movie_outlined),
        CategoriesCompanion.insert(
            name: 'To Read',
            colorId: SColor.orangeAccent,
            iconId: SIcons.menu_book_outlined),
        CategoriesCompanion.insert(
            name: 'Alert', colorId: SColor.red, iconId: SIcons.add_alert),
        CategoriesCompanion.insert(
            name: 'Work',
            colorId: SColor.greenAccent,
            iconId: SIcons.work_outline),
        CategoriesCompanion.insert(
            name: 'To Learn',
            colorId: SColor.black,
            iconId: SIcons.school_outlined),
      ]);
    });
  }

  Future<int> countCategories() async {
    final query = selectOnly(categories)..addColumns([categories.id.count()]);
    final result = (await query.get())[0];
    final count = result.read(categories.id.count());
    return count;
  }

  Future deleteCategory(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> insertHeatPoint(HeatGraphCompanion entity) {
    return into(heatGraph).insert(entity);
  }

  Future updateHeatPoint(int difference) async {
    HeatPoint point = await (select(heatGraph)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingle();
    final level = point.level + 1;
    return (update(heatGraph)..where((tbl) => tbl.id.equals(point.id)))
        .write(HeatGraphCompanion(level: Value(level)));
  }

  Future<ToDo?> queryTopMainFocus() async {
    ToDo? todo = await (select(toDos)
          ..where((tbl) => tbl.category.equals('mainfocus'))
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    return todo;
  }

  Future<HeatPoint?> queryTopHeatPoint() async {
    HeatPoint? point = await (select(heatGraph)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    return point;
  }

  Future insertTodo(ToDosCompanion entity) {
    return into(toDos).insert(entity);
  }

  Future updateToDoItem(ToDosCompanion entity, {bool updateContent = true}) {
    ToDosCompanion target;
    if (updateContent) {
      target = ToDosCompanion(
          status: entity.status,
          content: entity.content,
          brief: entity.brief,
          category: entity.category,
          alertTime: entity.alertTime,
          notificationId: entity.notificationId);
    } else {
      target = ToDosCompanion(
          status: entity.status,
          filedTime: entity.status.value == 0
              ? Value(DateTime.now())
              : Value.absent());
    }
    return (update(toDos)..where((tbl) => tbl.id.equals(entity.id.value)))
        .write(target);
  }

  Future updateAllToDosStatus(int currentStatus, int updatedStatus) {
    return (update(toDos)..where((tbl) => tbl.status.equals(currentStatus)))
        .write(ToDosCompanion(status: Value(updatedStatus)));
  }

  Future<List<ToDo>> queryToDosByCategory(String? category,
      {int status = 1}) async {
    return (select(toDos)
          ..where((tbl) => category == null
              ? tbl.status.equals(status)
              : tbl.category.equals(category) & tbl.status.equals(status)))
        .get();
  }

  Future<List<ToDo>> queryToDoItem(int id) {
    return (select(toDos)..where((tbl) => tbl.id.equals(id))).get();
  }

  ///0:新增 1:归档 2:更新
  Future<int> insertAction(ActionsHistoryCompanion entity) {
    return into(actionsHistory).insert(entity);
  }

  Future<List<UserAction>> queryActions() async {
    return select(actionsHistory).get();
  }

}
