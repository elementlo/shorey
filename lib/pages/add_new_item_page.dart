import 'dart:collection';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/pages/editor_page.dart';
import 'package:spark_list/pages/list_category_page.dart';
import 'package:spark_list/pages/root_page.dart';
import 'package:spark_list/view_model/config_view_model.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';
import 'package:spark_list/widget/category_list_item.dart';
import 'package:spark_list/widget/customized_date_picker.dart';
import 'package:spark_list/widget/settings_list_item.dart';
import 'package:spark_list/workflow/notion_workflow.dart';
import 'package:timezone/timezone.dart' as tz;

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/3/9
/// Description:
///

enum _ExpandableSetting {
  date,
  time,
}

class AddNewItemPage extends StatefulWidget {
  final CategoryItem category;
  final String? title;

  const AddNewItemPage(this.category, {Key? key, this.title}) : super(key: key);

  @override
  State<AddNewItemPage> createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _briefController = TextEditingController();
  final ScrollController _controller = ScrollController();

  late AnimationController _settingsPanelController;

  _ExpandableSetting? _expandedSettingId;
  late Animation<double> _staggerSettingsItemsAnimation;

  TimeOfDay _time = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  String _selectedDate = '';
  late int _categoryId;
  Color _categoryColor = Colors.white;
  String _categoryName = '';
  ToDosCompanion? companion;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.category.id;
    if(widget.title != null){
      _titleController.text = widget.title!;
    }
    _mapCategory();
    _settingsPanelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _settingsPanelController.addStatusListener(_closeSettingId);
    _staggerSettingsItemsAnimation = CurvedAnimation(
      parent: _settingsPanelController,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsListItems = [
      SettingsListItem<double>(
          title: S.of(context).date,
          selectedOption: 1.0,
          optionsMap: LinkedHashMap.of({1.0: DisplayOption(_selectedDate)}),
          onOptionChanged: (newTextScale) {},
          onTapSetting: () => _onTapSetting(_ExpandableSetting.date),
          isExpanded: _expandedSettingId == _ExpandableSetting.date,
          child: Localizations.override(
            context: context,
            locale: Locale(Intl.getCurrentLocale()),
            child: CustomizedDatePicker([], (selection) {
              _selectedDate =
                  '${selection.year}-${selection.month.toString().padLeft(2, '0')}'
                  '-${selection.day.toString().padLeft(2, '0')}';
              setState(() {});
            }),
          )),
      if (_selectedDate != '')
        SettingsListItem<double>(
          title: S.of(context).time,
          selectedOption: 1.0,
          optionsMap: LinkedHashMap.of(
              {1.0: DisplayOption(_time == null ? '' : _time.format(context))}),
          onOptionChanged: (newTextScale) {},
          onTapSetting: () => _onTapSetting(_ExpandableSetting.time),
          isExpanded: _expandedSettingId == _ExpandableSetting.time,
          child: createInlinePicker(
              accentColor: colorScheme.onSecondary,
              dialogInsetPadding: EdgeInsets.all(0),
              context: context,
              disableHour: false,
              disableMinute: false,
              value: _time,
              minMinute: 0,
              elevation: 0,
              maxMinute: 59,
              isOnChangeValueMode: true,
              onChange: (time) {
                print(time);
                setState(() {
                  _time = time;
                });
              }),
        ),
    ];
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: '${widget.category.name}',
        actions: [
          IconButton(
              icon: Icon(
                Icons.alarm_off,
                color: colorScheme.onSecondary,
              ),
              onPressed: () {
                _selectedDate = '';
                setState(() {});
                Fluttertoast.showToast(msg: S.of(context).cancelAlertTime);
              }),
          IconButton(
              icon: Icon(
                Icons.check,
                color: colorScheme.onSecondary,
              ),
              onPressed: () async {
                _syncWithNotion(await _saveItem());
                Navigator.pop(context, 0);
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: ListView(
          controller: _controller,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: Column(
                children: [
                  InputField(
                    hintText: S.of(context).itemAlert,
                    textEditingController: _titleController,
                  ),
                  Divider(
                    color: colorScheme.background,
                  ),
                  InputField(
                    hintText: S.of(context).itemRemark,
                    maxLines: 8,
                    textEditingController: _briefController,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: EditorTableRow(
                title: _categoryName,
                indicatorColor: _categoryColor,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ListCategoryPage(_categoryId)))
                      .then((result) {
                    if (result != null) {
                      _categoryId = result;
                      _mapCategory();
                      setState(() {});
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ...[
              AnimateSettingsListItems(
                animation: _staggerSettingsItemsAnimation,
                children: settingsListItems,
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Future _saveItem() async {
    String? alertTime = null;
    int? notificationId;
    if (_selectedDate.isNotEmpty) {
      notificationId =
          DateTime.now().millisecond * 1000 + DateTime.now().microsecond;
      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      alertTime = '$_selectedDate ${localizations.formatTimeOfDay(_time, alwaysUse24HourFormat: true)}';
      print('alerttime: $alertTime notificationId: ${notificationId}');
      await _setNotification(DateTime.parse(alertTime), notificationId)
          .catchError((onError) {
        debugPrint('${onError}');
      });
    }
    var index = -1;
    companion = ToDosCompanion(
      categoryId: d.Value(_categoryId),
      content: d.Value(_titleController.text),
      createdTime: d.Value(DateTime.now()),
      status: d.Value(1),
      brief: d.Value(_briefController.text),
      alertTime: d.Value(alertTime == null ? null : DateTime.parse(alertTime)),
      notificationId: d.Value(notificationId),
      tags: d.Value(_categoryName),
    );
    index = await context.read<HomeViewModel>().saveToDo(companion!);
    return index;
  }

  Future<void> _syncWithNotion(int index) async {
    if (widget.category.notionDatabaseId != null &&
        context.read<ConfigViewModel>().linkedNotion &&
        companion != null) {
      final pageId = await context.read<NotionWorkFlow>().addTaskItem(
          widget.category.notionDatabaseId!,
          ToDo(
            id: 0,
            content: companion!.content.value,
            createdTime: companion!.createdTime.value,
            categoryId: companion!.categoryId.value,
            status: 1,
            tags: _categoryName,
            brief: companion!.brief.value,
            alertTime: companion!.alertTime.value,
          ));
      if (index != -1) {
        _updatePageId(index, pageId);
      }
    }
  }

  Future _updatePageId(int index, String? pageId) async {
    if (pageId != null) {
      final companion =
          ToDosCompanion(id: d.Value(index), pageId: d.Value(pageId));
      await appContext
          .read<HomeViewModel>()
          .updateTodoItem(companion, companion);
    }
  }

  Future<void> _setNotification(DateTime alertTime, int notificationId) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        '${_titleController.text}',
        '${_briefController.text}',
        tz.TZDateTime.from(alertTime, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                NotificationId.mainChannelId, 'Todo Alert',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
                ticker: 'ticker')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void _onTapSetting(_ExpandableSetting settingId) {
    Future.delayed(Duration(milliseconds: 300), () {
      final extent = _controller.position.maxScrollExtent;
      if (extent > 0)
        _controller.animateTo(_controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
    setState(() {
      if (_expandedSettingId == settingId) {
        _expandedSettingId = null;
      } else {
        _expandedSettingId = settingId;
      }
    });
  }

  void _closeSettingId(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {
        _expandedSettingId = null;
      });
    }
  }

  void _mapCategory() {
    for (CategoryItem item
        in context.read<ConfigViewModel>().categoryDemosList) {
      if (_categoryId == item.id) {
        _categoryName = item.name;
        _categoryColor = item.color;
      }
    }
  }
}
