import 'dart:collection';

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';
import 'package:spark_list/widget/settings_list_item.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/7/28
/// Description:
///

enum _ExpandableSetting { textScale, time }

enum AlertPeriod { daily, mon, tue, wed, thu, fri, sat, sun, none }

class AlertPeriodPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AlertPeriodPageState();
  }
}

class AlertPeriodPageState extends State with TickerProviderStateMixin {
  late Animation<double> _staggerSettingsItemsAnimation;
  late AnimationController _settingsPanelController;
  _ExpandableSetting? _expandedSettingId;
  AlertPeriod selectPeriod = AlertPeriod.daily;
  TimeOfDay _time = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  int? selectedOption;
  final optionMap = LinkedHashMap.of({
    AlertPeriod.daily: '每天',
    AlertPeriod.mon: '每周一',
    AlertPeriod.tue: '每周二',
    AlertPeriod.wed: '每周三',
    AlertPeriod.thu: '每周四',
    AlertPeriod.fri: '每周五',
    AlertPeriod.sat: '每周六',
    AlertPeriod.sun: '每周日',
    AlertPeriod.none: '不提醒',
  });

  void onTapSetting(_ExpandableSetting settingId) {
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

  void _initSelectedOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedOption = prefs.getInt('alert_period') ?? 0;
    selectPeriod = optionMap.keys.elementAt(selectedOption!);
    if (prefs.getString('retrospect_time') != null &&
        prefs.getString('retrospect_time')!.isNotEmpty) {
      final time = prefs.getString('retrospect_time');
      print('init time: $time');
      var formatter = new DateFormat('Hm');
      _time = TimeOfDay.fromDateTime(formatter.parse(time!));
    }
    setState(() {});
  }

  Future<void> _savePeriod(AlertPeriod period) async {
    final provider = await Provider.of<HomeViewModel>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final index = optionMap.keys.toList().indexOf(period);
    print('period ${index}');
    print('time ${_time.format(context)}');
    if (index == 8) {
      await provider.cancelNotification(NotificationId.retrospectId);
    } else {
      await provider.assembleRetrospectNotification(_time, index);
    }
    prefs.setInt('alert_period', index);
    prefs.setString('retrospect_time', _time.format(context));
  }

  @override
  void initState() {
    super.initState();
    _initSelectedOption();
    _checkUncompetedTasks();
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
        title: '频率',
        optionsMap: LinkedHashMap.of(
            {1.0: DisplayOption(optionMap[selectPeriod] ?? '')}),
        selectedOption: MediaQuery.of(context).textScaleFactor,
        onOptionChanged: (newTextScale) {
          print(newTextScale);
        },
        onTapSetting: () => onTapSetting(_ExpandableSetting.textScale),
        isExpanded: _expandedSettingId == _ExpandableSetting.textScale,
        child: _optionChildList(colorScheme),
      ),
      SettingsListItem<double>(
        title: '时间',
        selectedOption: 1.0,
        optionsMap: LinkedHashMap.of(
            {1.0: DisplayOption(_time == null ? '无' : _time.format(context))}),
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
            elevation: 0,
            isOnChangeValueMode: true,
            onChange: (time) {
              setState(() {
                print(time.format(context));
                _time = time;
              });
            }),
      ),
    ];
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: '回顾',
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: colorScheme.onSecondary,
              ),
              onPressed: () async {
                await _savePeriod(selectPeriod);
                Navigator.pop(context);
              })
        ],
      ),
      body: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 64,
          ),
          // Remove ListView top padding as it is already accounted for.
          child: ListView(
            children: [
              const SizedBox(height: 12),
              ...[
                _AnimateSettingsListItems(
                  animation: _staggerSettingsItemsAnimation,
                  children: settingsListItems,
                ),
                const SizedBox(height: 12),
                //Divider(thickness: 2, height: 0, color: colorScheme.background),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionChildList(ColorScheme colorScheme) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _expandedSettingId == _ExpandableSetting.textScale ? 9 : 0,
      itemBuilder: (context, index) {
        final displayOption = optionMap.values.elementAt(index);
        return RadioListTile<AlertPeriod>(
          value: optionMap.keys.elementAt(index),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayOption,
                  style: TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
          groupValue: selectPeriod,
          onChanged: (option) {
            selectPeriod = option!;
            setState(() {});
          },
          activeColor: colorScheme.onSecondary,
          dense: true,
        );
      },
    );
  }

  void _checkUncompetedTasks() {}
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
