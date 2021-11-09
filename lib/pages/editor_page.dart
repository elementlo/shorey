import 'dart:collection';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/main.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/view_model/config_view_model.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';
import 'package:spark_list/widget/customized_date_picker.dart';
import 'package:spark_list/widget/settings_list_item.dart';
import 'package:timezone/timezone.dart' as tz;

import 'list_category_page.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/12/21
/// Description:
///

enum _ExpandableSetting {
  date,
  time,
}

class TextEditorPage extends StatefulWidget {
  final ToDoModel todoModel;

  TextEditorPage(this.todoModel);

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _briefController = TextEditingController();
  _ExpandableSetting? _expandedSettingId;
  late Animation<double> _staggerSettingsItemsAnimation;
  late AnimationController _settingsPanelController;
  final ScrollController _controller = ScrollController();
  TimeOfDay _time = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  String _selectedDate = '';
  DateTime? _alertDateTime = null;

  @override
  void initState() {
    super.initState();
    if (widget.todoModel.alertTime != null &&
        widget.todoModel.alertTime!.isNotEmpty) {
      _alertDateTime = DateTime.parse(widget.todoModel.alertTime!);
      _selectedDate =
          '${_alertDateTime!.year}-${_alertDateTime!.month.toString().padLeft(2, '0')}'
          '-${_alertDateTime!.day.toString().padLeft(2, '0')}';
      _time = TimeOfDay.fromDateTime(_alertDateTime!);
    }
    _titleController.text = widget.todoModel.content ??= '';
    _briefController.text = widget.todoModel.brief ??= '';
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsListItems = [
      SettingsListItem<double>(
          title: '日期',
          selectedOption: 1.0,
          optionsMap: LinkedHashMap.of(
              {1.0: DisplayOption(_selectedDate == '' ? '无' : _selectedDate)}),
          onOptionChanged: (newTextScale) {},
          onTapSetting: () => onTapSetting(_ExpandableSetting.date),
          isExpanded: _expandedSettingId == _ExpandableSetting.date,
          child: CustomizedDatePicker([], (selection) {
            _selectedDate =
                '${selection.year}-${selection.month.toString().padLeft(2, '0')}'
                '-${selection.day.toString().padLeft(2, '0')}';
            setState(() {});
          })),
      if (_selectedDate != '')
        SettingsListItem<double>(
          title: '时间',
          selectedOption: 1.0,
          optionsMap: LinkedHashMap.of({
            1.0: DisplayOption(_time == null ? '无' : _time.format(context))
          }),
          onOptionChanged: (newTextScale) {},
          onTapSetting: () => onTapSetting(_ExpandableSetting.time),
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
        title: '${widget.todoModel.category}',
        actions: [
          IconButton(
              icon: Icon(
                Icons.alarm_off,
                color: colorScheme.onSecondary,
              ),
              onPressed: () {
                _selectedDate = '';
                setState(() {});
                Fluttertoast.showToast(msg: '清除提醒时间');
              }),
          IconButton(
              icon: Icon(
                Icons.check,
                color: colorScheme.onSecondary,
              ),
              onPressed: () async {
                await _updateTodoItem();
                Navigator.pop(context);
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
                    hintText: '标题',
                    textEditingController: _titleController,
                  ),
                  Divider(
                    color: colorScheme.background,
                  ),
                  InputField(
                    hintText: '备注',
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
              child: _EditorTableRow(
                todoModel: widget.todoModel,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ...[
              _AnimateSettingsListItems(
                animation: _staggerSettingsItemsAnimation,
                children: settingsListItems,
              ),
              const SizedBox(height: 16),

              //Divider(thickness: 2, height: 0, color: colorScheme.background),
            ],
          ],
        ),
      ),
    );
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

  Future<void> _cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  Future<void> _updateTodoItem() async {
    final oldModel = widget.todoModel.copy();
    widget.todoModel.brief = _briefController.text;
    widget.todoModel.content = _titleController.text;
    String? alertTime = null;
    if (_selectedDate.isNotEmpty) {
      final notificationId =
          DateTime.now().millisecond * 1000 + DateTime.now().microsecond;
      widget.todoModel.notificationId ??= notificationId;
      alertTime = '$_selectedDate ${_time.format(context)}';
      print(
          'alerttime: $alertTime notificationId: ${widget.todoModel.notificationId}');
      await _setNotification(DateTime.parse(alertTime), notificationId)
          .catchError((onError) {
        debugPrint('${onError}');
      });
    } else {
      if (widget.todoModel.notificationId != null) {
        await _cancelNotification(widget.todoModel.notificationId!);
      }
      widget.todoModel.notificationId = null;
    }

    widget.todoModel.alertTime = alertTime;
    await context
        .read<HomeViewModel>()
        .updateTodoItem(oldModel, widget.todoModel);
  }

  void onTapSetting(_ExpandableSetting settingId) {
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
}

class InputField extends StatelessWidget {
  final String? hintText;
  final int maxLines;
  final TextEditingController? textEditingController;

  InputField({this.hintText, this.maxLines = 1, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '$hintText',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}

class _EditorTableRow extends StatefulWidget {
  const _EditorTableRow({Key? key, this.todoModel}) : super(key: key);

  final ToDoModel? todoModel;

  @override
  _EditorTableRowState createState() => _EditorTableRowState();
}

class _EditorTableRowState extends State<_EditorTableRow> {
  Color? _color = Colors.white;

  @override
  void initState() {
    super.initState();
    _color = _mapCategoryColor();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ListCategoryPage()))
              .then((result) {
            if (result != null) {
              widget.todoModel!.category = result;
              _color = _mapCategoryColor();
              setState(() {});
            }
          });
        },
        child: Container(
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Text('列表')),
              Container(
                height: 10,
                width: 10,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: _color),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '${widget.todoModel!.category}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Theme.of(context).colorScheme.onSecondary,
              )
            ],
          ),
        ),
      ),
    );
  }

  Color? _mapCategoryColor() {
    for (CategoryItem item
        in context.read<ConfigViewModel>().categoryDemosList) {
      if (widget.todoModel!.category == item.name) {
        return item.color;
      }
    }
    return Colors.white;
  }
}

class _AnimateSettingsListItems extends StatelessWidget {
  const _AnimateSettingsListItems({
    Key? key,
    required this.animation,
    required this.children,
  }) : super(key: key);

  final Animation<double> animation;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final dividingPadding = 4.0;
    final topPaddingTween = Tween<double>(
      begin: 0,
      end: children.length * dividingPadding,
    );
    final dividerTween = Tween<double>(
      begin: 0,
      end: dividingPadding,
    );

    return Padding(
      padding: EdgeInsets.only(top: topPaddingTween.animate(animation).value),
      child: Column(
        children: [
          for (Widget child in children)
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: dividerTween.animate(animation).value,
                  ),
                  child: child,
                );
              },
              child: child,
            ),
        ],
      ),
    );
  }
}
