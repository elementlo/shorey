import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shorey/base/ext.dart';
import 'package:shorey/config/config.dart';
import 'package:shorey/database/database.dart';
import 'package:shorey/generated/l10n.dart';
import 'package:shorey/main.dart';
import 'package:shorey/model/model.dart';
import 'package:shorey/pages/root_page.dart';
import 'package:shorey/view_model/config_view_model.dart';
import 'package:shorey/view_model/home_view_model.dart';
import 'package:shorey/widget/app_bar.dart';
import 'package:shorey/widget/customized_date_picker.dart';
import 'package:shorey/widget/settings_list_item.dart';
import 'package:shorey/workflow/notion_workflow.dart';
import 'package:timezone/timezone.dart' as tz;

import '../widget/diary_banner.dart';

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
  final CategoryItem category;
  final int itemId;

  TextEditorPage(this.itemId, this.category);

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _briefController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final GlobalKey rootWidgetKey = GlobalKey();

  late AnimationController _settingsPanelController;
  late Animation<double> _staggerSettingsItemsAnimation;

  _ExpandableSetting? _expandedSettingId;
  TimeOfDay _time = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  String _selectedDate = '';
  ToDo? _oldModel;
  ToDo? _updatedModel;
  String _categoryName = '';
  Color _categoryColor = Colors.white;
  bool _hasLocationPermission = false;
  Uint8List? imageBuffer = null;
  String? _thumb;

  @override
  void initState() {
    super.initState();

    context.read<HomeViewModel>().queryToDoItem(widget.itemId).then((value) {
      _updatedModel = value!;
      _oldModel = _updatedModel!.copyWith();
      if (_updatedModel!.alertTime != null) {
        DateTime _alertDateTime = _updatedModel!.alertTime!;
        _selectedDate =
            '${_alertDateTime.year}-${_alertDateTime.month.toString().padLeft(2, '0')}'
            '-${_alertDateTime.day.toString().padLeft(2, '0')}';
        _time = TimeOfDay.fromDateTime(_alertDateTime);
      }
      _thumb = _updatedModel!.thumb;
      _titleController.text = _updatedModel!.content;
      _briefController.text = _updatedModel!.brief ?? '';
      _mapCategory();
      setState(() {});
    });

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

    if (widget.category.notionDatabaseType == ActionType.DIARY) {
      context.read<ConfigViewModel>().requestLocationPermission().then((value) {
        _hasLocationPermission = value;
        setState(() {});
      });
    }
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: Scaffold(
        appBar: SparkAppBar(
          context: context,
          title: '${widget.category.name}',
          actions: [
            if (widget.category.notionDatabaseId != null &&
                context.read<ConfigViewModel>().linkedNotion)
              UnconstrainedBox(
                child: InkWell(
                  onTap: () async {
                    EasyLoading.show();
                    await _prepareData();
                    await _syncWithNotion();
                    EasyLoading.dismiss();
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/ic_notion_logo.webp'),
                        )),
                  ),
                ),
              ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.alarm_off,
                    color: colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    _selectedDate = '';
                    setState(() {});
                    Fluttertoast.showToast(msg: S.of(context).cancelAlertTime);
                  }),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.check,
                    color: colorScheme.onSecondary,
                  ),
                  onPressed: () async {
                    await _prepareData();
                    await _updateItem();
                    if (widget.category.notionDatabaseId != null &&
                        context.read<ConfigViewModel>().linkedNotion &&
                        widget.category.autoSync) {
                      _syncWithNotion();
                    }
                    Navigator.pop(context, 0);
                  }),
            ),
            SizedBox(
              width: 14,
            )
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
                      child: InputField(
                        hintText: S.of(context).itemRemark,
                        maxLines: 7,
                        textEditingController: _briefController,
                      ),
                    ),
                    if (_thumb != null && _thumb != '')
                      Align(
                        alignment: Alignment.centerRight,
                        child: Image.memory(base64.decode(_thumb!), height: 20,),
                      ),
                    // if (imageBuffer != null) Image.memory(imageBuffer!),
                    // TextButton(
                    //     onPressed: () async {
                    //       RenderRepaintBoundary boundary =
                    //           rootWidgetKey.currentContext?.findRenderObject()
                    //               as RenderRepaintBoundary;
                    //       var image = await boundary.toImage(pixelRatio: 3.0);
                    //       ByteData? byteData = await image.toByteData(
                    //           format: ImageByteFormat.png);
                    //       imageBuffer = byteData?.buffer.asUint8List();
                    //       imageBuffer =
                    //           base64.decode(base64.encode(imageBuffer!));
                    //       setState(() {});
                    //     },
                    //     child: Text(
                    //       'capture',
                    //       style: TextStyle(color: Colors.black),
                    //     ))
                    SizedBox(
                      height: 16,
                    ),
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

  Future _prepareData() async {
    _updatedModel!.brief = _briefController.text;
    _updatedModel!.content = _titleController.text;
    if (widget.category.notionDatabaseType == ActionType.DIARY) {
      await _prepareDiaryBannerPic();
    } else {
      await _prepareReminderTime();
    }
  }

  Future _prepareReminderTime() async {
    String? alertTime = null;
    if (_selectedDate.isNotEmpty) {
      final notificationId =
          DateTime.now().millisecond * 1000 + DateTime.now().microsecond;
      _updatedModel!.notificationId ??= notificationId;
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);
      alertTime =
          '$_selectedDate ${localizations.formatTimeOfDay(_time, alwaysUse24HourFormat: true)}';
      print(
          'alerttime: $alertTime notificationId: ${_updatedModel!.notificationId}');
      await _setNotification(DateTime.parse(alertTime), notificationId)
          .catchError((onError) {
        debugPrint('${onError}');
      });
    } else {
      if (_updatedModel!.notificationId != null) {
        await _cancelNotification(_updatedModel!.notificationId!);
      }
      _updatedModel!.notificationId = null;
    }

    _updatedModel!.alertTime =
        alertTime == null ? null : DateTime.parse(alertTime);
  }

  Future _prepareDiaryBannerPic() async {
    RenderRepaintBoundary boundary = rootWidgetKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List? imageBuffer = byteData?.buffer.asUint8List();
    if (imageBuffer != null) {
      _updatedModel!.thumb = base64.encode(imageBuffer);
    }
    //imageBuffer = base64.decode(base64.encode(imageBuffer!));
  }

  Future _updateItem() async {
    await context.read<HomeViewModel>().updateTodoItem(
        _oldModel!.toCompanion(true), _updatedModel!.toCompanion(true));
  }

  Future<void> _syncWithNotion() async {
    if (!_updatedModel!.properTiesEquals(_oldModel!)) {
      _updatedModel!.tags = _categoryName;
      await appContext.read<NotionWorkFlow>().updateTaskProperties(
          _updatedModel!.pageId, _updatedModel!.toCompanion(true),
          actionType: widget.category.notionDatabaseType);
    }
    if (_updatedModel!.brief != null &&
        !_updatedModel!.briefEquals(_oldModel!)) {
      await appContext.read<NotionWorkFlow>().appendBlockChildren(
          _updatedModel!.pageId,
          text: _updatedModel!.brief!,
          actionType: widget.category.notionDatabaseType);
    }
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
      if (_updatedModel?.categoryId == item.id) {
        _categoryName = item.name;
        _categoryColor = item.color;
      }
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
    return TextField(
      controller: textEditingController,
      keyboardType: TextInputType.multiline,
      style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xff4F4F4F)),
      maxLines: maxLines,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
          hintText: '$hintText',
          hintStyle: TextStyle(color: Colors.grey)),
    );
  }
}

class EditorTableRow extends StatefulWidget {
  const EditorTableRow(
      {Key? key,
      this.todoModel,
      this.onTap,
      required this.title,
      required this.indicatorColor})
      : super(key: key);

  final ToDo? todoModel;
  final String title;
  final Color indicatorColor;
  final VoidCallback? onTap;

  @override
  EditorTableRowState createState() => EditorTableRowState();
}

class EditorTableRowState extends State<EditorTableRow> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Text(S.of(context).categoryList)),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: widget.indicatorColor),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '${widget.title}',
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
}
