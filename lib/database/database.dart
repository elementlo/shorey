import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';

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

  IntColumn get notificationId => integer()();

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
      integer().customConstraint('NULLABLE REFERENCES categories(id)')();
}

@DataClassName('HeatPoint')
class HeatGraph extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get level => integer()();

  DateTimeColumn get createdTime => dateTime()();
}

@DataClassName('Action')
class ActionsHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get earlyContent => text()();

  TextColumn get updatedContent => text()();

  DateTimeColumn get updatedTime => dateTime()();

  IntColumn get action => integer()();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    print(dbFolder.parent);
    var file;
    if(Platform.isAndroid){
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

  Future<List<Category>> get categoryList => select(categories).get();

  Future setCategories() async {
    await batch((batch) {
      batch.insertAll(categories, [
        CategoriesCompanion.insert(name: 'To Do'),
        CategoriesCompanion.insert(name: 'To Watch'),
        CategoriesCompanion.insert(name: 'To Read'),
        CategoriesCompanion.insert(name: 'Alert'),
        CategoriesCompanion.insert(name: 'Work'),
        CategoriesCompanion.insert(name: 'To Learn')
      ]);
    });
  }

  Future<int> countCategories() async {
    final query = selectOnly(categories)..addColumns([categories.id.count()]);
    final result = (await query.get())[0];
    final count = result.read(categories.id.count());
    return count;
  }

  Future<int> insertHeatPoint(HeatGraphCompanion entity) async {
    return into(heatGraph).insert(entity);
  }

  Future updateHeatPoint(HeatGraphCompanion entity) async {
   return  (update(heatGraph)..where((tbl) => tbl.id.equalsExp(tbl.id.max()))).write(entity);
  }

}
