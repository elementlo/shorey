import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/view_model/notion_database_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';
import 'package:spark_list/widget/category_list_item.dart';
import 'package:spark_list/widget/settings_list_item.dart';
import 'package:spark_list/workflow/notion_workflow.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/2/21
/// Description:
///

enum _ExpandableSetting { linkNotionDatabase, categoryType }
enum _CategoryType { taskList }

class NotionDatabasePage extends StatefulWidget {
  const NotionDatabasePage({Key? key}) : super(key: key);

  @override
  _NotionDatabasePageState createState() => _NotionDatabasePageState();
}

class _NotionDatabasePageState extends State<NotionDatabasePage>
    with TickerProviderStateMixin {
  late Animation<double> _staggerSettingsItemsAnimation;
  late AnimationController _settingsPanelController;
  final TextEditingController _databaseController = TextEditingController();

  _ExpandableSetting? _expandedSettingId;

  late List<String> _categoryTypes;
  late int _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = 0;
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
    _categoryTypes = [
      S.of(context).taskList,
      S.of(context).templateDiaryTitle,
    ];
    return ProviderWidget<NotionDatabaseViewModel>(
      model: NotionDatabaseViewModel(),
      child: Scaffold(
        appBar: SparkAppBar(
          context: context,
          title: S.of(context).notionDatabasePageTitle,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.clear,
                  color: colorScheme.onSecondary,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                })
          ],
        ),
        body: Container(
          child: Column(
            children: [
              AnimateSettingsListItems(
                animation: _staggerSettingsItemsAnimation,
                children: [
                  SettingsListItem<double>(
                    title: S.of(context).categoryType,
                    optionsMap: LinkedHashMap.of({
                      1.0: DisplayOption('${_categoryTypes[_selectedOption]}'),
                    }),
                    selectedOption: 1.0,
                    onOptionChanged: (newTextScale) {
                      print(newTextScale);
                    },
                    onTapSetting: () =>
                        onTapSetting(_ExpandableSetting.categoryType),
                    isExpanded:
                        _expandedSettingId == _ExpandableSetting.categoryType,
                    child: _optionChildList(colorScheme),
                  ),
                  SettingsListItem<double>(
                    title: S.of(context).linkNotionDatabase,
                    selectedOption: 1.0,
                    optionsMap: LinkedHashMap.of({1.0: DisplayOption('')}),
                    onOptionChanged: (newTextScale) {},
                    onTapSetting: () =>
                        onTapSetting(_ExpandableSetting.linkNotionDatabase),
                    isExpanded: _expandedSettingId ==
                        _ExpandableSetting.linkNotionDatabase,
                    child: _NotionDatabaseCard(
                      controller: _databaseController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _optionChildList(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        itemCount: _categoryTypes.length + 1,
        itemExtent: 45,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return TipsTextView(S.of(context).categoryTypeTips);
          } else {
            return RadioListTile<String>(
              value: _categoryTypes[index - 1],
              title: Text(_categoryTypes[index - 1],
                  style: TextStyle(color: Colors.black, fontSize: 14)),
              groupValue: _categoryTypes[_selectedOption],
              onChanged: (option) {
                _selectedOption = _categoryTypes.indexOf(option!);
                setState(() {});
              },
              activeColor: colorScheme.onSecondary,
              dense: true,
            );
          }
        },
      ),
    );
  }
}

class _NotionDatabaseCard extends StatefulWidget {
  final TextEditingController controller;

  const _NotionDatabaseCard({Key? key, required this.controller})
      : super(key: key);

  @override
  State<_NotionDatabaseCard> createState() => _NotionDatabaseCardState();
}

class _NotionDatabaseCardState extends State<_NotionDatabaseCard> {
  var offStageCard = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = Provider.of<NotionDatabaseViewModel>(context);
    final database = viewModel.database;
    offStageCard = database == null;
    return Container(
      padding: EdgeInsets.only(top: 50),
      width: double.infinity,
      height: 230,
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Offstage(
            offstage: !offStageCard,
            child: Column(
              children: [
                TextField(
                  controller: widget.controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: S.of(context).notionPageId,
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      suffix: Container(
                        width: 25,
                        height: 25,
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () async {
                              if (widget.controller.text.isNotEmpty) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                EasyLoading.show();
                                final result = await context
                                    .read<NotionWorkFlow>()
                                    .linkDatabase(widget.controller.text);
                                if (result != null) {
                                  offStageCard = false;
                                  viewModel.setDatabase = result;
                                  setState(() {});
                                } else {

                                }
                                EasyLoading.dismiss();
                              }
                            },
                            icon: Icon(
                              Icons.check,
                              color: colorScheme.onSecondary,
                            )),
                      ),
                      contentPadding: EdgeInsets.only(top: 10)),
                ),
                SizedBox(
                  height: 20,
                ),
                TipsTextView(S.of(context).notionPrompt),
              ],
            ),
          ),
          Offstage(
            offstage: offStageCard,
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  '${database?.cover?.external?.url ?? ''}',
                                ))),
                      ),
                      Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              // context
                              //     .read<CategoryInfoViewModel>()
                              //     .unlinkNotionDatabase();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey.shade400,
                            ),
                          ))
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Text(
                              '${database?.icon?.type == 'emoji' ? database?.icon?.emoji : ''}'),
                          Text('${database?.title?[0].plainText}'),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TipsTextView extends StatelessWidget {
  final String tips;

  const TipsTextView(this.tips, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Icon(
              Icons.wb_incandescent,
              size: 15,
              color: Colors.grey,
            ),
          ),
          Expanded(
              child: Text(
            tips,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          )),
        ],
      ),
    );
  }
}
