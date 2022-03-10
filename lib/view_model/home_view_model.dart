import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:timezone/timezone.dart' as tz;

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

class HomeViewModel extends ViewStateModel {
  HomeViewModel() {
    _initMainFocus();
  }

  Map<int, List<ToDo?>> indexedList = Map();
  Map<String, int?> heatPointsMap = Map();

  String? _mainFocus = '';
  bool _hasMainFocus = true;
  String mantra = '';

  String? get mainFocus => _mainFocus;

  bool get hasMainFocus => _hasMainFocus;

  ToDo? mainFocusModel;
  List<ToDo?>? filedListModel;
  List<UserAction?>? userActionList;

  set hasMainFocus(bool hasMainFocus) {
    this._hasMainFocus = hasMainFocus;
    notifyListeners();
  }

  Future initDefaultSettings() async {
    await _initDefaultAlert();
    await initMantra();
    await _initHeatGraph();
  }

  Future _initDefaultAlert() async {
    if (await dsProvider.getValue<int>(StoreKey.alertPeriod) == null) {
      await dsProvider.saveValue<int>(StoreKey.alertPeriod, 0);
      await dsProvider.saveValue<String>(StoreKey.retrospectTime, '18:00');
      assembleRetrospectNotification(TimeOfDay(hour: 18, minute: 0), 0);
    }
  }

  Future initMantra() async {
    final defaultMantra = await dsProvider.getValue<String>(StoreKey.mantra);
    if (defaultMantra == null || defaultMantra == '') {
      mantra = Mantra.mantraList[Random().nextInt(3)];
    } else {
      mantra = defaultMantra;
    }
    print('mantra: $mantra');
    notifyListeners();
  }

  Future saveMantra(String text) async {
    mantra = text.isEmpty ? Mantra.mantraList[Random().nextInt(3)] : text;
    notifyListeners();
    await dsProvider.saveValue<String>(StoreKey.mantra, text);
  }

  Future<String?> getMantra() async {
    return await dsProvider.getValue<String>(StoreKey.mantra);
  }

  void _initMainFocus() async {
    mainFocusModel = (await dbProvider.queryTopMainFocus());
    final currentTime = DateTime.now();
    if (mainFocusModel?.createdTime != null) {
      final lastTime = mainFocusModel!.createdTime;
      if (lastTime.year != currentTime.year ||
          lastTime.month != currentTime.month ||
          lastTime.day != currentTime.day) {
        print('One day passed by ...insert initial heat point...');
        _hasMainFocus = false;
      } else {
        if (mainFocusModel != null) {
          _mainFocus = mainFocusModel!.content;
          _hasMainFocus = true;
        } else {
          _hasMainFocus = false;
        }
        print('the same day ...ignore...');
      }
    } else {
      _hasMainFocus = false;
      print('non-mainfocus');
    }
    notifyListeners();
  }

  Future _initHeatGraph() async {
    final heatPoint = await dbProvider.queryTopHeatPoint();
    if (heatPoint == null) {
      await dbProvider.insertHeatPoint(HeatGraphCompanion(
          level: Value(0), createdTime: Value(DateTime.now())));
    } else {
      final lastTime = heatPoint.createdTime;
      final currentTime = DateTime.now();
      if (lastTime.year != currentTime.year ||
          lastTime.month != currentTime.month ||
          lastTime.day != currentTime.day) {
        await dbProvider.insertHeatPoint(HeatGraphCompanion(
            level: Value(0), createdTime: Value(DateTime.now())));
      }
    }
  }

  Future saveCategory(CategoriesCompanion entity) async {
    return dbProvider.insertCategory(entity);
  }

  Future deleteCategory(int id) async {
    return dbProvider.deleteCategory(id);
  }

  Future updateCategory(CategoriesCompanion entity) async {
    return dbProvider.updateCategory(entity);
  }

  Future queryAllHeatPoints() async {
    heatPointsMap = await dbProvider.heatPointList;
    notifyListeners();
  }

  Future _updateMainFocus() async {
    mainFocusModel = (await dbProvider.queryTopMainFocus());
    if (mainFocusModel != null) {
      _mainFocus = mainFocusModel!.content;
      hasMainFocus = true;
    }
    notifyListeners();
  }

  Future<ToDo?> queryMainFocus() async {
    return (await dbProvider.queryTopMainFocus());
  }

  Future updateMainFocusStatus(int status) async {
    if (mainFocusModel != null) {
      mainFocusModel!.status = status;
      await dbProvider.updateToDoItem(ToDosCompanion(
          id: Value(mainFocusModel!.id),
          status: Value(mainFocusModel!.status)));
      int difference = 0;
      if (status == 0) {
        difference = 1;
      } else if (status == 1) {
        difference = -1;
      }
      await dbProvider.updateHeatPoint(difference);
      if (mainFocusModel!.status == 0) {
        await dbProvider.insertAction(ActionsHistoryCompanion(
            updatedContent: Value(mainFocusModel!.content),
            updatedTime: Value(DateTime.now()),
            action: Value(1)));
      }
    }
  }

  Future saveMainFocus(String content, {int status = 1}) async {
    await saveToDo(ToDosCompanion(
      categoryId: Value(1),
      content: Value(content),
      status: Value(status),
    ));
    await _updateMainFocus();
    notifyListeners();
  }

  Future<int> saveToDo(ToDosCompanion todo) async {
    final index = await dbProvider.insertTodo(todo);

    await dbProvider.insertAction(ActionsHistoryCompanion(
        updatedContent: Value(todo.content.value),
        updatedTime: Value(todo.createdTime.value),
        action: Value(0)));
    return index;
  }

  Future<List<ToDo?>> queryToDoList({int? categoryId}) async {
    List<ToDo?> toDoListModel =
        await dbProvider.queryToDosByCategory(categoryId: categoryId);
    if (categoryId != null)
    indexedList[categoryId] = toDoListModel;
    notifyListeners();
    return toDoListModel;
  }

  Future queryActions() async {
    userActionList = await dbProvider.queryActions();
    notifyListeners();
  }

  Future<List<ToDo?>?> queryFiledList() async {
    filedListModel = await dbProvider.queryToDosByCategory(status: 0);
    notifyListeners();
    return filedListModel;
  }

  Future updateTodoStatus(ToDo model) async {
    int difference = 0;
    switch (model.status) {
      case 0:
        difference = -1;
        model.status = 1;
        break;
      case 1:
        difference = 1;
        model.status = 0;
        break;
    }
    await dbProvider.updateToDoItem(
        ToDosCompanion(id: Value(model.id), status: Value(model.status)));
    await dbProvider.updateHeatPoint(difference);
    if (model.status == 0) {
      await dbProvider.insertAction(ActionsHistoryCompanion(
          updatedContent: Value(model.content),
          updatedTime: Value(DateTime.now()),
          action: Value(1)));
    }
    notifyListeners();
  }

  Future clearFiledItems() async {
    await dbProvider.updateAllToDosStatus(0, 2);
    filedListModel = null;
    notifyListeners();
  }

  Future updateTodoItem(
      ToDosCompanion oldModel, ToDosCompanion updatedModel) async {
    await dbProvider.updateToDoItem(updatedModel);
    if (oldModel.content != updatedModel.content)
      await dbProvider.insertAction(ActionsHistoryCompanion(
          earlyContent: Value(oldModel.content.value),
          updatedContent: Value(updatedModel.content.value),
          updatedTime: Value(DateTime.now()),
          action: Value(2)));
  }

  Future<ToDo?> queryToDoItem(int id) {
    return dbProvider.queryToDoItem(id);
  }

  Future<void> assembleRetrospectNotification(
    TimeOfDay alertTime,
    int weekday,
  ) async {
    final todoList = await queryToDoList();
    var brief = '';
    if (todoList != null && todoList.length > 0) {
      for (var i = 0; i < todoList.length; i++) {
        brief += '${todoList[i]?.content}、';
      }
      debugPrint('assembleRetrospectNotification: $brief');
    }
    if (brief.isNotEmpty) {
      _setNotification(
          alertTime: alertTime,
          weekday: weekday,
          title: '${S.current.notificationTitle}',
          body: brief);
    }
  }

  Future<void> _setNotification(
      {required TimeOfDay alertTime,
      required int weekday,
      String? title,
      String? body}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        NotificationId.retrospectId,
        '$title',
        '$body',
        weekday == 0
            ? _nextInstance(alertTime)
            : _nextInstanceOfWeekday(alertTime, weekday),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                NotificationId.retrospectChannelId, 'Retrospect Alert',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
                ticker: 'ticker')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: weekday == 0
            ? DateTimeComponents.time
            : DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  tz.TZDateTime _nextInstanceOfWeekday(TimeOfDay time, int weekday) {
    tz.TZDateTime scheduledDate = _nextInstance(time);
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstance(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
