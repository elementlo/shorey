import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:spark_list/widget/app_bar.dart';
import 'package:spark_list/widget/settings_list_item.dart';

import 'home_page.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/7/28
/// Description:
///

enum _ExpandableSetting {
  textScale,
  textDirection,
  locale,
  platform,
  theme,
}

class PushFrequencyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PushFrequencyPageState();
  }
}

class PushFrequencyPageState extends State with TickerProviderStateMixin {
  late Animation<double> _staggerSettingsItemsAnimation;
  late AnimationController _settingsPanelController;
  _ExpandableSetting? _expandedSettingId;

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

  @override
  void initState() {
    super.initState();
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
        title: 'title11',
        selectedOption: MediaQuery.of(context).textScaleFactor,
        optionsMap: LinkedHashMap.of({
          -1: DisplayOption(
            '1',
          ),
          0.8: DisplayOption(
            '1',
          ),
          1.0: DisplayOption(
            '1',
          ),
          2.0: DisplayOption(
            '1',
          ),
          3.0: DisplayOption(
            '1',
          ),
        }),
        onOptionChanged: (newTextScale){

        },
        onTapSetting: () => onTapSetting(_ExpandableSetting.textScale),
        isExpanded: _expandedSettingId == _ExpandableSetting.textScale,
        child: Container(),
      ),
    ];
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: '默认推送频率',
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: colorScheme.onSecondary,
              ),
              onPressed: () {})
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
