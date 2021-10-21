import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spark_list/base/view_state_model.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/model.dart';
import 'package:timezone/timezone.dart' as tz;

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

class HomeViewModel extends ViewStateModel {
  HomeViewModel() {
    _heatMapTask();
  }

  ToDoModel? selectedModel;
  Map<String?, ToDoListModel?> indexedList = Map();
  Map<String, int?> heatPointsMap = Map();

  String? _mainFocus = '';
  bool _hasMainFocus = true;

  String? get mainFocus => _mainFocus;

  bool get hasMainFocus => _hasMainFocus;

  ToDoModel? _mainFocusModel;
  HeatMapModel? _heatMapModel;
  ToDoListModel? filedListModel;


  set hasMainFocus(bool hasMainFocus) {
    this._hasMainFocus = hasMainFocus;
    notifyListeners();
  }

  void _heatMapTask() async {
    final point = await sparkProvider.getTopHeatPoint();
    print('heat map task: ${point}');
    final currentTime = DateTime.now();
    if (point?.createdTime != null) {
      final lastTime = DateTime.fromMillisecondsSinceEpoch(point!.createdTime!);
      if (lastTime.year != currentTime.year ||
          lastTime.month != currentTime.month ||
          lastTime.day != currentTime.day) {
        print('not the same day ...insert initial heat point...');
        oneDayPassBy = true;
        await sparkProvider.insertHeatPoint(
            0, currentTime.millisecondsSinceEpoch);
      } else {
        oneDayPassBy = false;
        print('the same day ...ignore...');
      }
    } else {
      oneDayPassBy = true;
      print('insert initial heat point...');
      await sparkProvider.insertHeatPoint(
          0, currentTime.millisecondsSinceEpoch);
    }
    _initMainFocus();
  }

  Future queryAllHeatPoints() async {
    heatPointsMap = await sparkProvider.queryAllHeatPoints();
    notifyListeners();
  }

  Future _initMainFocus() async {
    if (oneDayPassBy) {
      _hasMainFocus = false;
    } else {
      _mainFocusModel = await queryMainFocus();
      if (_mainFocusModel != null) {
        _mainFocus = _mainFocusModel!.content;
        _hasMainFocus = true;
      } else {
        _hasMainFocus = false;
      }
    }
    notifyListeners();
  }

  Future<ToDoModel?> queryMainFocus() async {
    return await sparkProvider.getTopToDo();
  }

  Future updateMainFocusStatus(int status) async {
    if (_mainFocusModel != null) {
      _mainFocusModel!.status = status;
      await sparkProvider.updateToDoItem(_mainFocusModel!);
      int difference = 0;
      if (status == 0) {
        difference = 1;
      } else if (status == 1) {
        difference = -1;
      }
      await sparkProvider.updateHeatPoint(difference);
    }
  }

  Future saveMainFocus(String content, {int status = 1}) async {
    await saveToDo(content, 'mainfocus', status: status);
    await _initMainFocus();
    notifyListeners();
  }

  Future saveToDo(String content, String? category,
      {String? brief, int status = 1}) async {
    await sparkProvider.insertToDo(
        ToDoModel(createdTime: DateTime.now().millisecondsSinceEpoch)
          ..content = content
          ..category = category
          ..status = status
          ..brief = brief);
  }

  Future<ToDoListModel?> queryToDoList(String? category) async {
    ToDoListModel? toDoListModel = await sparkProvider.queryToDoList(category);
    indexedList[category] = toDoListModel;
    notifyListeners();
    return toDoListModel;
  }

  Future<ToDoListModel?> queryFiledList() async {
    filedListModel = await sparkProvider.queryToDoList(null, status: 0);
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
    await sparkProvider.updateToDoItem(model, updateContent: false);
    await sparkProvider.updateHeatPoint(difference);
    notifyListeners();
  }

  Future clearFiledItems() async{
    await sparkProvider.updateToDoListStatus(0, 2);
    filedListModel = null;
    notifyListeners();
  }

  Future updateTodoItem(ToDoModel model) async {
    await sparkProvider.updateToDoItem(model, updateContent: true);
  }

  Future queryToDoItem(int id) async {
    selectedModel = await sparkProvider.queryToDoItem(id);
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
    if(brief.isNotEmpty){
      _setNotification(alertTime: alertTime, weekday: weekday, title: '回顾', body: brief);
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
                NotificationId.retrospectChannelId,
                'Retrospect Alert',
                'Retrospect\'s notification channel',
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
