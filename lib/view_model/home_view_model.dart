import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:spark_list/resource/db_provider.dart';
import 'package:timezone/timezone.dart' as tz;

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

class HomeViewModel extends ViewStateModel {
  final DbSparkProvider dBProvider;
  final DataProvider _dataProvider;
  final DbProvider _dbProvider;

  HomeViewModel(this.dBProvider, this._dataProvider, this._dbProvider) {
    _initMainFocus();
  }

  ToDoModel? selectedModel;
  Map<String?, ToDoListModel?> indexedList = Map();
  Map<String, int?> heatPointsMap = Map();

  String? _mainFocus = '';
  bool _hasMainFocus = true;
  String mantra = '';

  String? get mainFocus => _mainFocus;

  bool get hasMainFocus => _hasMainFocus;

  ToDoModel? mainFocusModel;
  ToDoListModel? filedListModel;
  UserActionList? userActionList;

  set hasMainFocus(bool hasMainFocus) {
    this._hasMainFocus = hasMainFocus;
    notifyListeners();
  }

  Future initDefaultSettings() async {
    await _initDefaultAlert();
    await _initMantra();
  }

  Future _initDefaultAlert() async {
    if (await _dataProvider.getAlertPeriod() == null) {
      _dataProvider.saveAlertPeriod(0);
      assembleRetrospectNotification(TimeOfDay(hour: 18, minute: 0), 0);
    }
  }

  Future _initMantra() async {
    final defaultMantra = await _dataProvider.getMantra();
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
    await _dataProvider.saveMantra(text);
  }

  Future<String?> getMantra() async {
    return await _dataProvider.getMantra();
  }

  void _initMainFocus() async {
    mainFocusModel = await dBProvider.getTopToDo();
    final currentTime = DateTime.now();
    if (mainFocusModel?.createdTime != null) {
      final lastTime =
          DateTime.fromMillisecondsSinceEpoch(mainFocusModel!.createdTime!);
      if (lastTime.year != currentTime.year ||
          lastTime.month != currentTime.month ||
          lastTime.day != currentTime.day) {
        print('One day passed by ...insert initial heat point...');
        _hasMainFocus = false;
        //oneDayPassBy = true;
        // await sparkProvider.insertHeatPoint(
        //     0, currentTime.millisecondsSinceEpoch);
        await _dbProvider.insertHeatPoint(HeatGraphCompanion(
            level: Value(0), createdTime: Value(DateTime.now())));
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
      // await sparkProvider.insertHeatPoint(
      //     0, currentTime.millisecondsSinceEpoch);
      await _dbProvider.insertHeatPoint(HeatGraphCompanion(
          level: Value(0), createdTime: Value(DateTime.now())));
    }
    notifyListeners();
  }

  Future queryAllHeatPoints() async {
    heatPointsMap = await dBProvider.queryAllHeatPoints();
    notifyListeners();
  }

  Future _updateMainFocus() async {
    mainFocusModel = await dBProvider.getTopToDo();
    if (mainFocusModel != null) {
      _mainFocus = mainFocusModel!.content;
      hasMainFocus = true;
    }
    notifyListeners();
  }

  Future<ToDoModel?> queryMainFocus() async {
    return await dBProvider.getTopToDo();
  }

  Future updateMainFocusStatus(int status) async {
    if (mainFocusModel != null) {
      mainFocusModel!.status = status;
      await dBProvider.updateToDoItem(mainFocusModel!);
      int difference = 0;
      if (status == 0) {
        difference = 1;
      } else if (status == 1) {
        difference = -1;
      }
      await dBProvider.updateHeatPoint(difference);
      if (mainFocusModel!.status == 0) {
        final action = UserAction();
        action.updatedContent = mainFocusModel!.content;
        action.updatedTime = DateTime.now().millisecondsSinceEpoch;
        action.action = 1;
        await dBProvider.insertAction(action);
      }
    }
  }

  Future saveMainFocus(String content, {int status = 1}) async {
    await saveToDo(content, 'mainfocus', status: status);
    await _updateMainFocus();
    notifyListeners();
  }

  Future saveToDo(String content, String? category,
      {String? brief, int status = 1}) async {
    final updatedTime = DateTime.now().millisecondsSinceEpoch;
    await dBProvider.insertToDo(ToDoModel(createdTime: updatedTime)
      ..content = content
      ..category = category
      ..status = status
      ..brief = brief);

    await dBProvider.insertAction(UserAction()
      ..updatedTime = updatedTime
      ..updatedContent = content
      ..action = 0);
  }

  Future<ToDoListModel?> queryToDoList(String? category) async {
    ToDoListModel? toDoListModel = await dBProvider.queryToDoList(category);
    indexedList[category] = toDoListModel;
    notifyListeners();
    return toDoListModel;
  }

  Future queryActions() async {
    userActionList = await dBProvider.queryActions();
    notifyListeners();
  }

  Future<ToDoListModel?> queryFiledList() async {
    filedListModel = await dBProvider.queryToDoList(null, status: 0);
    notifyListeners();
    return filedListModel;
  }

  Future updateTodoStatus(ToDoModel model) async {
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
    await dBProvider.updateToDoItem(model, updateContent: false);
    await dBProvider.updateHeatPoint(difference);
    if (model.status == 0) {
      final action = UserAction();
      action.updatedContent = model.content;
      action.updatedTime = DateTime.now().millisecondsSinceEpoch;
      action.action = 1;
      await dBProvider.insertAction(action);
    }
    notifyListeners();
  }

  Future clearFiledItems() async {
    await dBProvider.updateToDoListStatus(0, 2);
    filedListModel = null;
    notifyListeners();
  }

  Future updateTodoItem(ToDoModel oldModel, ToDoModel updatedModel) async {
    await dBProvider.updateToDoItem(updatedModel, updateContent: true);
    final action = UserAction();
    action.earlyContent = oldModel.content;
    action.updatedContent = updatedModel.content;
    action.updatedTime = DateTime.now().millisecondsSinceEpoch;
    action.action = 2;
    await dBProvider.insertAction(action);
  }

  Future queryToDoItem(int id) async {
    selectedModel = await dBProvider.queryToDoItem(id);
  }

  Future<void> assembleRetrospectNotification(
    TimeOfDay alertTime,
    int weekday,
  ) async {
    final todoList = await queryToDoList(null);
    var brief = '';
    if (todoList != null && todoList.length > 0) {
      for (var i = 0; i < todoList.length; i++) {
        brief += '${todoList[i].content}、';
      }
      debugPrint('assembleRetrospectNotification: $brief');
    }
    if (brief.isNotEmpty) {
      _setNotification(
          alertTime: alertTime, weekday: weekday, title: '回顾', body: brief);
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
