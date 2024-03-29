import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:day_night_time_picker/day_night_time_picker.dart' as dy;
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shorey/base/provider_widget.dart';
import 'package:shorey/config/config.dart';
import 'package:shorey/database/database.dart';
import 'package:shorey/generated/l10n.dart';
import 'package:shorey/main.dart';
import 'package:shorey/model/model.dart';
import 'package:shorey/pages/editor_page.dart';
import 'package:shorey/pages/list_category_page.dart';
import 'package:shorey/pages/root_page.dart';
import 'package:shorey/view_model/config_view_model.dart';
import 'package:shorey/view_model/home_view_model.dart';
import 'package:shorey/view_model/new_item_view_model.dart';
import 'package:shorey/widget/app_bar.dart';
import 'package:shorey/widget/customized_date_picker.dart';
import 'package:shorey/widget/settings_list_item.dart';
import 'package:shorey/workflow/notion_workflow.dart';
import 'package:timezone/timezone.dart' as tz;

import '../widget/diary_banner.dart';

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
  final GlobalKey rootWidgetKey = GlobalKey();

  late AnimationController _settingsPanelController;

  _ExpandableSetting? _expandedSettingId;
  late Animation<double> _staggerSettingsItemsAnimation;

  late dy.Time _time;
  String _selectedDate = '';
  late int _categoryId;
  Color _categoryColor = Colors.white;
  String _categoryName = '';
  int? _notionDatabaseType;
  ToDosCompanion? _companion;
  String? _thumb;
  String? _alertTime = null;
  int? _notificationId;
  String? _weather;
  String? _location;
  String? _bannerUploadUrl;
  ByteData? _byteData;

  @override
  void initState() {
    super.initState();
    TimeOfDay _timeOfDay =
        TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
    _time = dy.Time.fromTimeOfDay(_timeOfDay, 60);
    _categoryId = widget.category.id;
    if (widget.title != null) {
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
          child: dy.showPicker(
              isInlinePicker: true,
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
    return ProviderWidget<NewItemViewModel>(
      onModelReady: (viewModel) {},
      model: NewItemViewModel(),
      child: Scaffold(
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
            Consumer<NewItemViewModel>(builder: (context, _, __) {
              return IconButton(
                  icon: Icon(
                    Icons.check,
                    color: colorScheme.onSecondary,
                  ),
                  onPressed: () async {
                    _syncWithNotion(context, await _saveItem(context));
                    Navigator.pop(context, 0);
                  });
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
                height: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
                child: Column(
                  children: [
                    InputField(
                      hintText: S.of(context).itemAlert,
                      textEditingController: _titleController,
                    ),
                    Divider(
                      color: colorScheme.background,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InputField(
                          hintText: S.of(context).itemRemark,
                          maxLines: 8,
                          textEditingController: _briefController,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RepaintBoundary(
                          key: rootWidgetKey,
                          child: DiaryBanner(
                            onInfoUpdated: (weather, temp, location) {
                              _weather = '$weather $temp℃';
                              _location = location;
                              // if (weather!.isNotEmpty &&
                              //     _location != null &&
                              //     _bannerUploadUrl != null) {
                              //   //_prepareDiaryBannerPic(context);
                              // }
                            },
                          )),
                    ),
                    SizedBox(
                      height: 16,
                    )
                  ],
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
      ),
    );
  }

  Future _saveItem(BuildContext context) async {
    if (widget.category.notionDatabaseType == ActionType.DIARY) {
      await _prepareDiaryBannerPic();
      _companion = ToDosCompanion(
          categoryId: d.Value(_categoryId),
          content: d.Value(_titleController.text),
          createdTime: d.Value(DateTime.now()),
          status: d.Value(1),
          brief: d.Value(_briefController.text),
          tags: d.Value(_categoryName),
          thumb: d.Value(_thumb),
          weather: d.Value(_weather),
          location: d.Value(_location),
          weatherBannerUrl: d.Value(_bannerUploadUrl));
    } else {
      await _prepareReminderTime();
      _companion = ToDosCompanion(
        categoryId: d.Value(_categoryId),
        content: d.Value(_titleController.text),
        createdTime: d.Value(DateTime.now()),
        status: d.Value(1),
        brief: d.Value(_briefController.text),
        alertTime:
            d.Value(_alertTime == null ? null : DateTime.parse(_alertTime!)),
        notificationId: d.Value(_notificationId),
        tags: d.Value(_categoryName),
      );
    }
    var index = await context.read<HomeViewModel>().saveToDo(_companion!);
    return index;
  }

  Future _prepareDiaryBannerPic() async {
    RenderRepaintBoundary boundary = rootWidgetKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    _byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List? imageBuffer = _byteData?.buffer.asUint8List();
    if (imageBuffer != null) {
      _thumb = base64.encode(imageBuffer);
    }
  }

  Future _uploadDiaryBannerPic(BuildContext context) async {
    final Response res =
        await context.read<NewItemViewModel>().uploadImage(_byteData);
    _bannerUploadUrl = res.data;
  }

  Future _prepareReminderTime() async {
    if (_selectedDate.isNotEmpty) {
      _notificationId =
          DateTime.now().millisecond * 1000 + DateTime.now().microsecond;
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);
      _alertTime =
          '$_selectedDate ${localizations.formatTimeOfDay(_time, alwaysUse24HourFormat: true)}';
      print('alerttime: $_alertTime notificationId: ${_notificationId}');
      await _setNotification(DateTime.parse(_alertTime!), _notificationId!)
          .catchError((onError) {
        debugPrint('${onError}');
      });
    }
  }

  Future<void> _syncWithNotion(BuildContext context, int index) async {
    if (widget.category.notionDatabaseId != null &&
        context.read<ConfigViewModel>().linkedNotion &&
        _companion != null) {
      if (_notionDatabaseType == ActionType.DIARY) {
        await _uploadDiaryBannerPic(context);
      }
      final pageId = await appContext.read<NotionWorkFlow>().addTaskItem(
          widget.category.notionDatabaseId!,
          ToDo(
              id: 0,
              content: _companion!.content.value,
              createdTime: _companion!.createdTime.value,
              categoryId: _companion!.categoryId.value,
              status: 1,
              tags: _categoryName,
              brief: _companion!.brief.value,
              alertTime: _companion!.alertTime.value,
              weather: _weather,
              location: _location,
              thumb: _thumb,
              weatherBannerUrl: _bannerUploadUrl),
          actionType: _notionDatabaseType!);
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
        _notionDatabaseType = item.notionDatabaseType;
      }
    }
  }
}
