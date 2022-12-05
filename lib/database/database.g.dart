// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ToDo extends DataClass implements Insertable<ToDo> {
  int id;
  int? notificationId;
  DateTime createdTime;
  DateTime? filedTime;
  DateTime? alertTime;
  String content;
  String? brief;
  String? tags;
  String? pageId;
  String? thumb;

  ///0: finished 1: going 2: deleted
  int status;
  int categoryId;
  ToDo(
      {required this.id,
      this.notificationId,
      required this.createdTime,
      this.filedTime,
      this.alertTime,
      required this.content,
      this.brief,
      this.tags,
      this.pageId,
      this.thumb,
      required this.status,
      required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<int>(notificationId);
    }
    map['created_time'] = Variable<DateTime>(createdTime);
    if (!nullToAbsent || filedTime != null) {
      map['filed_time'] = Variable<DateTime>(filedTime);
    }
    if (!nullToAbsent || alertTime != null) {
      map['alert_time'] = Variable<DateTime>(alertTime);
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || brief != null) {
      map['brief'] = Variable<String>(brief);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || pageId != null) {
      map['page_id'] = Variable<String>(pageId);
    }
    if (!nullToAbsent || thumb != null) {
      map['thumb'] = Variable<String>(thumb);
    }
    map['status'] = Variable<int>(status);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  ToDosCompanion toCompanion(bool nullToAbsent) {
    return ToDosCompanion(
      id: Value(id),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
      createdTime: Value(createdTime),
      filedTime: filedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(filedTime),
      alertTime: alertTime == null && nullToAbsent
          ? const Value.absent()
          : Value(alertTime),
      content: Value(content),
      brief:
          brief == null && nullToAbsent ? const Value.absent() : Value(brief),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      pageId:
          pageId == null && nullToAbsent ? const Value.absent() : Value(pageId),
      thumb:
          thumb == null && nullToAbsent ? const Value.absent() : Value(thumb),
      status: Value(status),
      categoryId: Value(categoryId),
    );
  }

  factory ToDo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToDo(
      id: serializer.fromJson<int>(json['id']),
      notificationId: serializer.fromJson<int?>(json['notificationId']),
      createdTime: serializer.fromJson<DateTime>(json['createdTime']),
      filedTime: serializer.fromJson<DateTime?>(json['filedTime']),
      alertTime: serializer.fromJson<DateTime?>(json['alertTime']),
      content: serializer.fromJson<String>(json['content']),
      brief: serializer.fromJson<String?>(json['brief']),
      tags: serializer.fromJson<String?>(json['tags']),
      pageId: serializer.fromJson<String?>(json['pageId']),
      thumb: serializer.fromJson<String?>(json['thumb']),
      status: serializer.fromJson<int>(json['status']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notificationId': serializer.toJson<int?>(notificationId),
      'createdTime': serializer.toJson<DateTime>(createdTime),
      'filedTime': serializer.toJson<DateTime?>(filedTime),
      'alertTime': serializer.toJson<DateTime?>(alertTime),
      'content': serializer.toJson<String>(content),
      'brief': serializer.toJson<String?>(brief),
      'tags': serializer.toJson<String?>(tags),
      'pageId': serializer.toJson<String?>(pageId),
      'thumb': serializer.toJson<String?>(thumb),
      'status': serializer.toJson<int>(status),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  ToDo copyWith(
          {int? id,
          Value<int?> notificationId = const Value.absent(),
          DateTime? createdTime,
          Value<DateTime?> filedTime = const Value.absent(),
          Value<DateTime?> alertTime = const Value.absent(),
          String? content,
          Value<String?> brief = const Value.absent(),
          Value<String?> tags = const Value.absent(),
          Value<String?> pageId = const Value.absent(),
          Value<String?> thumb = const Value.absent(),
          int? status,
          int? categoryId}) =>
      ToDo(
        id: id ?? this.id,
        notificationId:
            notificationId.present ? notificationId.value : this.notificationId,
        createdTime: createdTime ?? this.createdTime,
        filedTime: filedTime.present ? filedTime.value : this.filedTime,
        alertTime: alertTime.present ? alertTime.value : this.alertTime,
        content: content ?? this.content,
        brief: brief.present ? brief.value : this.brief,
        tags: tags.present ? tags.value : this.tags,
        pageId: pageId.present ? pageId.value : this.pageId,
        thumb: thumb.present ? thumb.value : this.thumb,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
      );
  @override
  String toString() {
    return (StringBuffer('ToDo(')
          ..write('id: $id, ')
          ..write('notificationId: $notificationId, ')
          ..write('createdTime: $createdTime, ')
          ..write('filedTime: $filedTime, ')
          ..write('alertTime: $alertTime, ')
          ..write('content: $content, ')
          ..write('brief: $brief, ')
          ..write('tags: $tags, ')
          ..write('pageId: $pageId, ')
          ..write('thumb: $thumb, ')
          ..write('status: $status, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, notificationId, createdTime, filedTime,
      alertTime, content, brief, tags, pageId, thumb, status, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToDo &&
          other.id == this.id &&
          other.notificationId == this.notificationId &&
          other.createdTime == this.createdTime &&
          other.filedTime == this.filedTime &&
          other.alertTime == this.alertTime &&
          other.content == this.content &&
          other.brief == this.brief &&
          other.tags == this.tags &&
          other.pageId == this.pageId &&
          other.thumb == this.thumb &&
          other.status == this.status &&
          other.categoryId == this.categoryId);
}

class ToDosCompanion extends UpdateCompanion<ToDo> {
  Value<int> id;
  Value<int?> notificationId;
  Value<DateTime> createdTime;
  Value<DateTime?> filedTime;
  Value<DateTime?> alertTime;
  Value<String> content;
  Value<String?> brief;
  Value<String?> tags;
  Value<String?> pageId;
  Value<String?> thumb;
  Value<int> status;
  Value<int> categoryId;
  ToDosCompanion({
    this.id = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.createdTime = const Value.absent(),
    this.filedTime = const Value.absent(),
    this.alertTime = const Value.absent(),
    this.content = const Value.absent(),
    this.brief = const Value.absent(),
    this.tags = const Value.absent(),
    this.pageId = const Value.absent(),
    this.thumb = const Value.absent(),
    this.status = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  ToDosCompanion.insert({
    this.id = const Value.absent(),
    this.notificationId = const Value.absent(),
    required DateTime createdTime,
    this.filedTime = const Value.absent(),
    this.alertTime = const Value.absent(),
    required String content,
    this.brief = const Value.absent(),
    this.tags = const Value.absent(),
    this.pageId = const Value.absent(),
    this.thumb = const Value.absent(),
    required int status,
    required int categoryId,
  })  : createdTime = Value(createdTime),
        content = Value(content),
        status = Value(status),
        categoryId = Value(categoryId);
  static Insertable<ToDo> custom({
    Expression<int>? id,
    Expression<int>? notificationId,
    Expression<DateTime>? createdTime,
    Expression<DateTime>? filedTime,
    Expression<DateTime>? alertTime,
    Expression<String>? content,
    Expression<String>? brief,
    Expression<String>? tags,
    Expression<String>? pageId,
    Expression<String>? thumb,
    Expression<int>? status,
    Expression<int>? categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notificationId != null) 'notification_id': notificationId,
      if (createdTime != null) 'created_time': createdTime,
      if (filedTime != null) 'filed_time': filedTime,
      if (alertTime != null) 'alert_time': alertTime,
      if (content != null) 'content': content,
      if (brief != null) 'brief': brief,
      if (tags != null) 'tags': tags,
      if (pageId != null) 'page_id': pageId,
      if (thumb != null) 'thumb': thumb,
      if (status != null) 'status': status,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  ToDosCompanion copyWith(
      {Value<int>? id,
      Value<int?>? notificationId,
      Value<DateTime>? createdTime,
      Value<DateTime?>? filedTime,
      Value<DateTime?>? alertTime,
      Value<String>? content,
      Value<String?>? brief,
      Value<String?>? tags,
      Value<String?>? pageId,
      Value<String?>? thumb,
      Value<int>? status,
      Value<int>? categoryId}) {
    return ToDosCompanion(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      createdTime: createdTime ?? this.createdTime,
      filedTime: filedTime ?? this.filedTime,
      alertTime: alertTime ?? this.alertTime,
      content: content ?? this.content,
      brief: brief ?? this.brief,
      tags: tags ?? this.tags,
      pageId: pageId ?? this.pageId,
      thumb: thumb ?? this.thumb,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (createdTime.present) {
      map['created_time'] = Variable<DateTime>(createdTime.value);
    }
    if (filedTime.present) {
      map['filed_time'] = Variable<DateTime>(filedTime.value);
    }
    if (alertTime.present) {
      map['alert_time'] = Variable<DateTime>(alertTime.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (brief.present) {
      map['brief'] = Variable<String>(brief.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (thumb.present) {
      map['thumb'] = Variable<String>(thumb.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToDosCompanion(')
          ..write('id: $id, ')
          ..write('notificationId: $notificationId, ')
          ..write('createdTime: $createdTime, ')
          ..write('filedTime: $filedTime, ')
          ..write('alertTime: $alertTime, ')
          ..write('content: $content, ')
          ..write('brief: $brief, ')
          ..write('tags: $tags, ')
          ..write('pageId: $pageId, ')
          ..write('thumb: $thumb, ')
          ..write('status: $status, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $ToDosTable extends ToDos with TableInfo<$ToDosTable, ToDo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToDosTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
      'notification_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _createdTimeMeta =
      const VerificationMeta('createdTime');
  @override
  late final GeneratedColumn<DateTime> createdTime = GeneratedColumn<DateTime>(
      'created_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _filedTimeMeta = const VerificationMeta('filedTime');
  @override
  late final GeneratedColumn<DateTime> filedTime = GeneratedColumn<DateTime>(
      'filed_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _alertTimeMeta = const VerificationMeta('alertTime');
  @override
  late final GeneratedColumn<DateTime> alertTime = GeneratedColumn<DateTime>(
      'alert_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _briefMeta = const VerificationMeta('brief');
  @override
  late final GeneratedColumn<String> brief = GeneratedColumn<String>(
      'brief', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
      'page_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _thumbMeta = const VerificationMeta('thumb');
  @override
  late final GeneratedColumn<String> thumb = GeneratedColumn<String>(
      'thumb', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints:
          'NULLABLE REFERENCES categories(id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        notificationId,
        createdTime,
        filedTime,
        alertTime,
        content,
        brief,
        tags,
        pageId,
        thumb,
        status,
        categoryId
      ];
  @override
  String get aliasedName => _alias ?? 'to_dos';
  @override
  String get actualTableName => 'to_dos';
  @override
  VerificationContext validateIntegrity(Insertable<ToDo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    }
    if (data.containsKey('created_time')) {
      context.handle(
          _createdTimeMeta,
          createdTime.isAcceptableOrUnknown(
              data['created_time']!, _createdTimeMeta));
    } else if (isInserting) {
      context.missing(_createdTimeMeta);
    }
    if (data.containsKey('filed_time')) {
      context.handle(_filedTimeMeta,
          filedTime.isAcceptableOrUnknown(data['filed_time']!, _filedTimeMeta));
    }
    if (data.containsKey('alert_time')) {
      context.handle(_alertTimeMeta,
          alertTime.isAcceptableOrUnknown(data['alert_time']!, _alertTimeMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('brief')) {
      context.handle(
          _briefMeta, brief.isAcceptableOrUnknown(data['brief']!, _briefMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('page_id')) {
      context.handle(_pageIdMeta,
          pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta));
    }
    if (data.containsKey('thumb')) {
      context.handle(
          _thumbMeta, thumb.isAcceptableOrUnknown(data['thumb']!, _thumbMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ToDo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ToDo(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      notificationId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}notification_id']),
      createdTime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_time'])!,
      filedTime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}filed_time']),
      alertTime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}alert_time']),
      content: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      brief: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}brief']),
      tags: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
      pageId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}page_id']),
      thumb: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}thumb']),
      status: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      categoryId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
    );
  }

  @override
  $ToDosTable createAlias(String alias) {
    return $ToDosTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  int id;
  String name;
  String? notionDatabaseId;
  String? notionDatabaseName;

  ///0: simple list 1: task list 2: diary
  int notionDatabaseType;
  int iconId;
  int colorId;
  bool? autoSync;
  Category(
      {required this.id,
      required this.name,
      this.notionDatabaseId,
      this.notionDatabaseName,
      required this.notionDatabaseType,
      required this.iconId,
      required this.colorId,
      this.autoSync});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notionDatabaseId != null) {
      map['notion_database_id'] = Variable<String>(notionDatabaseId);
    }
    if (!nullToAbsent || notionDatabaseName != null) {
      map['notion_database_name'] = Variable<String>(notionDatabaseName);
    }
    map['notion_database_type'] = Variable<int>(notionDatabaseType);
    map['icon_id'] = Variable<int>(iconId);
    map['color_id'] = Variable<int>(colorId);
    if (!nullToAbsent || autoSync != null) {
      map['auto_sync'] = Variable<bool>(autoSync);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      notionDatabaseId: notionDatabaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(notionDatabaseId),
      notionDatabaseName: notionDatabaseName == null && nullToAbsent
          ? const Value.absent()
          : Value(notionDatabaseName),
      notionDatabaseType: Value(notionDatabaseType),
      iconId: Value(iconId),
      colorId: Value(colorId),
      autoSync: autoSync == null && nullToAbsent
          ? const Value.absent()
          : Value(autoSync),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notionDatabaseId: serializer.fromJson<String?>(json['notionDatabaseId']),
      notionDatabaseName:
          serializer.fromJson<String?>(json['notionDatabaseName']),
      notionDatabaseType: serializer.fromJson<int>(json['notionDatabaseType']),
      iconId: serializer.fromJson<int>(json['iconId']),
      colorId: serializer.fromJson<int>(json['colorId']),
      autoSync: serializer.fromJson<bool?>(json['autoSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'notionDatabaseId': serializer.toJson<String?>(notionDatabaseId),
      'notionDatabaseName': serializer.toJson<String?>(notionDatabaseName),
      'notionDatabaseType': serializer.toJson<int>(notionDatabaseType),
      'iconId': serializer.toJson<int>(iconId),
      'colorId': serializer.toJson<int>(colorId),
      'autoSync': serializer.toJson<bool?>(autoSync),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          Value<String?> notionDatabaseId = const Value.absent(),
          Value<String?> notionDatabaseName = const Value.absent(),
          int? notionDatabaseType,
          int? iconId,
          int? colorId,
          Value<bool?> autoSync = const Value.absent()}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        notionDatabaseId: notionDatabaseId.present
            ? notionDatabaseId.value
            : this.notionDatabaseId,
        notionDatabaseName: notionDatabaseName.present
            ? notionDatabaseName.value
            : this.notionDatabaseName,
        notionDatabaseType: notionDatabaseType ?? this.notionDatabaseType,
        iconId: iconId ?? this.iconId,
        colorId: colorId ?? this.colorId,
        autoSync: autoSync.present ? autoSync.value : this.autoSync,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notionDatabaseId: $notionDatabaseId, ')
          ..write('notionDatabaseName: $notionDatabaseName, ')
          ..write('notionDatabaseType: $notionDatabaseType, ')
          ..write('iconId: $iconId, ')
          ..write('colorId: $colorId, ')
          ..write('autoSync: $autoSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, notionDatabaseId,
      notionDatabaseName, notionDatabaseType, iconId, colorId, autoSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.notionDatabaseId == this.notionDatabaseId &&
          other.notionDatabaseName == this.notionDatabaseName &&
          other.notionDatabaseType == this.notionDatabaseType &&
          other.iconId == this.iconId &&
          other.colorId == this.colorId &&
          other.autoSync == this.autoSync);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  Value<int> id;
  Value<String> name;
  Value<String?> notionDatabaseId;
  Value<String?> notionDatabaseName;
  Value<int> notionDatabaseType;
  Value<int> iconId;
  Value<int> colorId;
  Value<bool?> autoSync;
  CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notionDatabaseId = const Value.absent(),
    this.notionDatabaseName = const Value.absent(),
    this.notionDatabaseType = const Value.absent(),
    this.iconId = const Value.absent(),
    this.colorId = const Value.absent(),
    this.autoSync = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.notionDatabaseId = const Value.absent(),
    this.notionDatabaseName = const Value.absent(),
    required int notionDatabaseType,
    required int iconId,
    required int colorId,
    this.autoSync = const Value.absent(),
  })  : name = Value(name),
        notionDatabaseType = Value(notionDatabaseType),
        iconId = Value(iconId),
        colorId = Value(colorId);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? notionDatabaseId,
    Expression<String>? notionDatabaseName,
    Expression<int>? notionDatabaseType,
    Expression<int>? iconId,
    Expression<int>? colorId,
    Expression<bool>? autoSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notionDatabaseId != null) 'notion_database_id': notionDatabaseId,
      if (notionDatabaseName != null)
        'notion_database_name': notionDatabaseName,
      if (notionDatabaseType != null)
        'notion_database_type': notionDatabaseType,
      if (iconId != null) 'icon_id': iconId,
      if (colorId != null) 'color_id': colorId,
      if (autoSync != null) 'auto_sync': autoSync,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? notionDatabaseId,
      Value<String?>? notionDatabaseName,
      Value<int>? notionDatabaseType,
      Value<int>? iconId,
      Value<int>? colorId,
      Value<bool?>? autoSync}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notionDatabaseId: notionDatabaseId ?? this.notionDatabaseId,
      notionDatabaseName: notionDatabaseName ?? this.notionDatabaseName,
      notionDatabaseType: notionDatabaseType ?? this.notionDatabaseType,
      iconId: iconId ?? this.iconId,
      colorId: colorId ?? this.colorId,
      autoSync: autoSync ?? this.autoSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notionDatabaseId.present) {
      map['notion_database_id'] = Variable<String>(notionDatabaseId.value);
    }
    if (notionDatabaseName.present) {
      map['notion_database_name'] = Variable<String>(notionDatabaseName.value);
    }
    if (notionDatabaseType.present) {
      map['notion_database_type'] = Variable<int>(notionDatabaseType.value);
    }
    if (iconId.present) {
      map['icon_id'] = Variable<int>(iconId.value);
    }
    if (colorId.present) {
      map['color_id'] = Variable<int>(colorId.value);
    }
    if (autoSync.present) {
      map['auto_sync'] = Variable<bool>(autoSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notionDatabaseId: $notionDatabaseId, ')
          ..write('notionDatabaseName: $notionDatabaseName, ')
          ..write('notionDatabaseType: $notionDatabaseType, ')
          ..write('iconId: $iconId, ')
          ..write('colorId: $colorId, ')
          ..write('autoSync: $autoSync')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _notionDatabaseIdMeta =
      const VerificationMeta('notionDatabaseId');
  @override
  late final GeneratedColumn<String> notionDatabaseId = GeneratedColumn<String>(
      'notion_database_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _notionDatabaseNameMeta =
      const VerificationMeta('notionDatabaseName');
  @override
  late final GeneratedColumn<String> notionDatabaseName =
      GeneratedColumn<String>('notion_database_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _notionDatabaseTypeMeta =
      const VerificationMeta('notionDatabaseType');
  @override
  late final GeneratedColumn<int> notionDatabaseType = GeneratedColumn<int>(
      'notion_database_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _iconIdMeta = const VerificationMeta('iconId');
  @override
  late final GeneratedColumn<int> iconId = GeneratedColumn<int>(
      'icon_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _colorIdMeta = const VerificationMeta('colorId');
  @override
  late final GeneratedColumn<int> colorId = GeneratedColumn<int>(
      'color_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _autoSyncMeta = const VerificationMeta('autoSync');
  @override
  late final GeneratedColumn<bool> autoSync = GeneratedColumn<bool>(
      'auto_sync', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK ("auto_sync" IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        notionDatabaseId,
        notionDatabaseName,
        notionDatabaseType,
        iconId,
        colorId,
        autoSync
      ];
  @override
  String get aliasedName => _alias ?? 'categories';
  @override
  String get actualTableName => 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notion_database_id')) {
      context.handle(
          _notionDatabaseIdMeta,
          notionDatabaseId.isAcceptableOrUnknown(
              data['notion_database_id']!, _notionDatabaseIdMeta));
    }
    if (data.containsKey('notion_database_name')) {
      context.handle(
          _notionDatabaseNameMeta,
          notionDatabaseName.isAcceptableOrUnknown(
              data['notion_database_name']!, _notionDatabaseNameMeta));
    }
    if (data.containsKey('notion_database_type')) {
      context.handle(
          _notionDatabaseTypeMeta,
          notionDatabaseType.isAcceptableOrUnknown(
              data['notion_database_type']!, _notionDatabaseTypeMeta));
    } else if (isInserting) {
      context.missing(_notionDatabaseTypeMeta);
    }
    if (data.containsKey('icon_id')) {
      context.handle(_iconIdMeta,
          iconId.isAcceptableOrUnknown(data['icon_id']!, _iconIdMeta));
    } else if (isInserting) {
      context.missing(_iconIdMeta);
    }
    if (data.containsKey('color_id')) {
      context.handle(_colorIdMeta,
          colorId.isAcceptableOrUnknown(data['color_id']!, _colorIdMeta));
    } else if (isInserting) {
      context.missing(_colorIdMeta);
    }
    if (data.containsKey('auto_sync')) {
      context.handle(_autoSyncMeta,
          autoSync.isAcceptableOrUnknown(data['auto_sync']!, _autoSyncMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      notionDatabaseId: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}notion_database_id']),
      notionDatabaseName: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}notion_database_name']),
      notionDatabaseType: attachedDatabase.options.types.read(
          DriftSqlType.int, data['${effectivePrefix}notion_database_type'])!,
      iconId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}icon_id'])!,
      colorId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}color_id'])!,
      autoSync: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_sync']),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class HeatPoint extends DataClass implements Insertable<HeatPoint> {
  int id;
  int level;
  DateTime createdTime;
  HeatPoint({required this.id, required this.level, required this.createdTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    map['created_time'] = Variable<DateTime>(createdTime);
    return map;
  }

  HeatGraphCompanion toCompanion(bool nullToAbsent) {
    return HeatGraphCompanion(
      id: Value(id),
      level: Value(level),
      createdTime: Value(createdTime),
    );
  }

  factory HeatPoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeatPoint(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      createdTime: serializer.fromJson<DateTime>(json['createdTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'createdTime': serializer.toJson<DateTime>(createdTime),
    };
  }

  HeatPoint copyWith({int? id, int? level, DateTime? createdTime}) => HeatPoint(
        id: id ?? this.id,
        level: level ?? this.level,
        createdTime: createdTime ?? this.createdTime,
      );
  @override
  String toString() {
    return (StringBuffer('HeatPoint(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('createdTime: $createdTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, createdTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeatPoint &&
          other.id == this.id &&
          other.level == this.level &&
          other.createdTime == this.createdTime);
}

class HeatGraphCompanion extends UpdateCompanion<HeatPoint> {
  Value<int> id;
  Value<int> level;
  Value<DateTime> createdTime;
  HeatGraphCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.createdTime = const Value.absent(),
  });
  HeatGraphCompanion.insert({
    this.id = const Value.absent(),
    required int level,
    required DateTime createdTime,
  })  : level = Value(level),
        createdTime = Value(createdTime);
  static Insertable<HeatPoint> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<DateTime>? createdTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (createdTime != null) 'created_time': createdTime,
    });
  }

  HeatGraphCompanion copyWith(
      {Value<int>? id, Value<int>? level, Value<DateTime>? createdTime}) {
    return HeatGraphCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (createdTime.present) {
      map['created_time'] = Variable<DateTime>(createdTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeatGraphCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('createdTime: $createdTime')
          ..write(')'))
        .toString();
  }
}

class $HeatGraphTable extends HeatGraph
    with TableInfo<$HeatGraphTable, HeatPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeatGraphTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _createdTimeMeta =
      const VerificationMeta('createdTime');
  @override
  late final GeneratedColumn<DateTime> createdTime = GeneratedColumn<DateTime>(
      'created_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, level, createdTime];
  @override
  String get aliasedName => _alias ?? 'heat_graph';
  @override
  String get actualTableName => 'heat_graph';
  @override
  VerificationContext validateIntegrity(Insertable<HeatPoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('created_time')) {
      context.handle(
          _createdTimeMeta,
          createdTime.isAcceptableOrUnknown(
              data['created_time']!, _createdTimeMeta));
    } else if (isInserting) {
      context.missing(_createdTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeatPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeatPoint(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      level: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      createdTime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_time'])!,
    );
  }

  @override
  $HeatGraphTable createAlias(String alias) {
    return $HeatGraphTable(attachedDatabase, alias);
  }
}

class UserAction extends DataClass implements Insertable<UserAction> {
  int id;
  String? earlyContent;
  String updatedContent;
  DateTime updatedTime;
  int action;
  UserAction(
      {required this.id,
      this.earlyContent,
      required this.updatedContent,
      required this.updatedTime,
      required this.action});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || earlyContent != null) {
      map['early_content'] = Variable<String>(earlyContent);
    }
    map['updated_content'] = Variable<String>(updatedContent);
    map['updated_time'] = Variable<DateTime>(updatedTime);
    map['action'] = Variable<int>(action);
    return map;
  }

  ActionsHistoryCompanion toCompanion(bool nullToAbsent) {
    return ActionsHistoryCompanion(
      id: Value(id),
      earlyContent: earlyContent == null && nullToAbsent
          ? const Value.absent()
          : Value(earlyContent),
      updatedContent: Value(updatedContent),
      updatedTime: Value(updatedTime),
      action: Value(action),
    );
  }

  factory UserAction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserAction(
      id: serializer.fromJson<int>(json['id']),
      earlyContent: serializer.fromJson<String?>(json['earlyContent']),
      updatedContent: serializer.fromJson<String>(json['updatedContent']),
      updatedTime: serializer.fromJson<DateTime>(json['updatedTime']),
      action: serializer.fromJson<int>(json['action']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'earlyContent': serializer.toJson<String?>(earlyContent),
      'updatedContent': serializer.toJson<String>(updatedContent),
      'updatedTime': serializer.toJson<DateTime>(updatedTime),
      'action': serializer.toJson<int>(action),
    };
  }

  UserAction copyWith(
          {int? id,
          Value<String?> earlyContent = const Value.absent(),
          String? updatedContent,
          DateTime? updatedTime,
          int? action}) =>
      UserAction(
        id: id ?? this.id,
        earlyContent:
            earlyContent.present ? earlyContent.value : this.earlyContent,
        updatedContent: updatedContent ?? this.updatedContent,
        updatedTime: updatedTime ?? this.updatedTime,
        action: action ?? this.action,
      );
  @override
  String toString() {
    return (StringBuffer('UserAction(')
          ..write('id: $id, ')
          ..write('earlyContent: $earlyContent, ')
          ..write('updatedContent: $updatedContent, ')
          ..write('updatedTime: $updatedTime, ')
          ..write('action: $action')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, earlyContent, updatedContent, updatedTime, action);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserAction &&
          other.id == this.id &&
          other.earlyContent == this.earlyContent &&
          other.updatedContent == this.updatedContent &&
          other.updatedTime == this.updatedTime &&
          other.action == this.action);
}

class ActionsHistoryCompanion extends UpdateCompanion<UserAction> {
  Value<int> id;
  Value<String?> earlyContent;
  Value<String> updatedContent;
  Value<DateTime> updatedTime;
  Value<int> action;
  ActionsHistoryCompanion({
    this.id = const Value.absent(),
    this.earlyContent = const Value.absent(),
    this.updatedContent = const Value.absent(),
    this.updatedTime = const Value.absent(),
    this.action = const Value.absent(),
  });
  ActionsHistoryCompanion.insert({
    this.id = const Value.absent(),
    this.earlyContent = const Value.absent(),
    required String updatedContent,
    required DateTime updatedTime,
    required int action,
  })  : updatedContent = Value(updatedContent),
        updatedTime = Value(updatedTime),
        action = Value(action);
  static Insertable<UserAction> custom({
    Expression<int>? id,
    Expression<String>? earlyContent,
    Expression<String>? updatedContent,
    Expression<DateTime>? updatedTime,
    Expression<int>? action,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (earlyContent != null) 'early_content': earlyContent,
      if (updatedContent != null) 'updated_content': updatedContent,
      if (updatedTime != null) 'updated_time': updatedTime,
      if (action != null) 'action': action,
    });
  }

  ActionsHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String?>? earlyContent,
      Value<String>? updatedContent,
      Value<DateTime>? updatedTime,
      Value<int>? action}) {
    return ActionsHistoryCompanion(
      id: id ?? this.id,
      earlyContent: earlyContent ?? this.earlyContent,
      updatedContent: updatedContent ?? this.updatedContent,
      updatedTime: updatedTime ?? this.updatedTime,
      action: action ?? this.action,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (earlyContent.present) {
      map['early_content'] = Variable<String>(earlyContent.value);
    }
    if (updatedContent.present) {
      map['updated_content'] = Variable<String>(updatedContent.value);
    }
    if (updatedTime.present) {
      map['updated_time'] = Variable<DateTime>(updatedTime.value);
    }
    if (action.present) {
      map['action'] = Variable<int>(action.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionsHistoryCompanion(')
          ..write('id: $id, ')
          ..write('earlyContent: $earlyContent, ')
          ..write('updatedContent: $updatedContent, ')
          ..write('updatedTime: $updatedTime, ')
          ..write('action: $action')
          ..write(')'))
        .toString();
  }
}

class $ActionsHistoryTable extends ActionsHistory
    with TableInfo<$ActionsHistoryTable, UserAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActionsHistoryTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _earlyContentMeta =
      const VerificationMeta('earlyContent');
  @override
  late final GeneratedColumn<String> earlyContent = GeneratedColumn<String>(
      'early_content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _updatedContentMeta =
      const VerificationMeta('updatedContent');
  @override
  late final GeneratedColumn<String> updatedContent = GeneratedColumn<String>(
      'updated_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _updatedTimeMeta =
      const VerificationMeta('updatedTime');
  @override
  late final GeneratedColumn<DateTime> updatedTime = GeneratedColumn<DateTime>(
      'updated_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<int> action = GeneratedColumn<int>(
      'action', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, earlyContent, updatedContent, updatedTime, action];
  @override
  String get aliasedName => _alias ?? 'actions_history';
  @override
  String get actualTableName => 'actions_history';
  @override
  VerificationContext validateIntegrity(Insertable<UserAction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('early_content')) {
      context.handle(
          _earlyContentMeta,
          earlyContent.isAcceptableOrUnknown(
              data['early_content']!, _earlyContentMeta));
    }
    if (data.containsKey('updated_content')) {
      context.handle(
          _updatedContentMeta,
          updatedContent.isAcceptableOrUnknown(
              data['updated_content']!, _updatedContentMeta));
    } else if (isInserting) {
      context.missing(_updatedContentMeta);
    }
    if (data.containsKey('updated_time')) {
      context.handle(
          _updatedTimeMeta,
          updatedTime.isAcceptableOrUnknown(
              data['updated_time']!, _updatedTimeMeta));
    } else if (isInserting) {
      context.missing(_updatedTimeMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserAction(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      earlyContent: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}early_content']),
      updatedContent: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}updated_content'])!,
      updatedTime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_time'])!,
      action: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}action'])!,
    );
  }

  @override
  $ActionsHistoryTable createAlias(String alias) {
    return $ActionsHistoryTable(attachedDatabase, alias);
  }
}

abstract class _$DatabaseProvider extends GeneratedDatabase {
  _$DatabaseProvider(QueryExecutor e) : super(e);
  late final $ToDosTable toDos = $ToDosTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $HeatGraphTable heatGraph = $HeatGraphTable(this);
  late final $ActionsHistoryTable actionsHistory = $ActionsHistoryTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [toDos, categories, heatGraph, actionsHistory];
}
