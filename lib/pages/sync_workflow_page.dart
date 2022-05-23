import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/model/notion_database_model.dart' as database;
import 'package:spark_list/model/notion_page_model.dart' as page;
import 'package:spark_list/view_model/config_view_model.dart';

import '../base/provider_widget.dart';
import '../generated/l10n.dart';
import '../view_model/sync_view_model.dart';
import '../widget/app_bar.dart';
import '../widget/settings_list_item.dart';
import '../workflow/notion_workflow.dart';
import 'category_info_page.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/5/19
/// Description:
///
enum _ExpandableSetting { linkNotionDatabase, categoryType }

class SyncWorkflowPage extends StatefulWidget {
  final String? notionDatabaseId;
  int notionDatabaseType;
  final bool autoSyncToggle;

  SyncWorkflowPage(
      {Key? key,
      this.notionDatabaseId,
      this.notionDatabaseType = 0,
      this.autoSyncToggle = true})
      : super(key: key);

  @override
  State<SyncWorkflowPage> createState() => _SyncWorkflowPageState();
}

class _SyncWorkflowPageState extends State<SyncWorkflowPage>
    with TickerProviderStateMixin {
  late Animation<double> _staggerSettingsItemsAnimation;
  late AnimationController _settingsPanelController;
  late List<String> _templateTypes;

  final TextEditingController _databaseController = TextEditingController();

  var _linked = false;
  double _topPadding = 0;
  _ExpandableSetting? _expandedSettingId;

  @override
  void initState() {
    super.initState();
    _linked = context.read<ConfigViewModel>().linkedNotion;
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
  void dispose() {
    super.dispose();
    _databaseController.dispose();
    _settingsPanelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _templateTypes = [
      S.of(context).simpleList,
      S.of(context).taskList,
      S.of(context).templateDiaryTitle,
    ];
    final colorScheme = Theme.of(context).colorScheme;
    return ProviderWidget<SyncWorkflowViewModel>(
      model: SyncWorkflowViewModel(),
      onModelReady: (viewModel) {
        viewModel.autoSyncToggle = widget.autoSyncToggle;
      },
      child: Scaffold(
          appBar: SparkAppBar(
            context: context,
            title: S.of(context).workFlow,
            actions: [
              Consumer(builder: (BuildContext context, value, Widget? child) {
                return IconButton(
                    icon: Icon(
                      Icons.check,
                      color: colorScheme.onSecondary,
                    ),
                    onPressed: () async {
                      final notionDatabaseId =
                          context.read<SyncWorkflowViewModel>().database?.id;
                      final autoSync =
                          context.read<SyncWorkflowViewModel>().autoSyncToggle;
                      final database =
                          context.read<SyncWorkflowViewModel>().database;
                      Navigator.pop(context, {
                        'notionDatabaseType': widget.notionDatabaseType,
                        'notionDatabaseId': notionDatabaseId,
                        'autoSync': autoSync,
                        'typeName': _templateTypes[widget.notionDatabaseType],
                        'databaseName': database?.title?[0].plainText
                      });
                    });
              })
            ],
          ),
          body: ListView(
            children: [
              if (_linked) ...[
                AnimateSettingsListItems(
                  animation: _staggerSettingsItemsAnimation,
                  children: [
                    SettingsListItem<double>(
                      title: S.of(context).categoryType,
                      optionsMap: LinkedHashMap.of({
                        1.0: DisplayOption(
                            '${_templateTypes[widget.notionDatabaseType]}'),
                      }),
                      selectedOption: 1.0,
                      onOptionChanged: (newTextScale) {
                        print(newTextScale);
                      },
                      onTapSetting: () =>
                          _onTapSetting(_ExpandableSetting.categoryType),
                      isExpanded:
                          _expandedSettingId == _ExpandableSetting.categoryType,
                      child: _optionChildList(colorScheme),
                    ),
                    Consumer<SyncWorkflowViewModel>(
                      builder: (context, viewModel, _) {
                        return SettingsListItem<double>(
                          title: S.of(context).linkNotionDatabase,
                          selectedOption: 1.0,
                          optionsMap: LinkedHashMap.of({
                            1.0: DisplayOption(
                                '${viewModel.database?.title?[0].plainText ?? ''}')
                          }),
                          showHeaderInfoButton: viewModel.database == null,
                          onToggleInfo: (toggled) {
                            toggled ? _topPadding = 70 : _topPadding = 0;
                            setState(() {});
                          },
                          onOptionChanged: (newTextScale) {},
                          onTapSetting: () => _onTapSetting(
                              _ExpandableSetting.linkNotionDatabase),
                          isExpanded: _expandedSettingId ==
                              _ExpandableSetting.linkNotionDatabase,
                          child: _CollapsedMenu(
                              notionDatabaseType: widget.notionDatabaseType,
                              topPadding: _topPadding,
                              controller: _databaseController,
                              notionDatabaseId: widget.notionDatabaseId),
                        );
                      },
                    ),
                  ],
                ),
              ] else ...[
                Divider(
                  indent: 16,
                  endIndent: 16,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: TipsTextView(S.of(context).linkNotionIfYouWant)),
              ],
              SizedBox(
                height: 20,
              ),
            ],
          )),
    );
  }

  void _onTapSetting(_ExpandableSetting settingId) {
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
    return Consumer<SyncWorkflowViewModel>(builder: (context, viewModel, _) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          itemCount: _templateTypes.length + 1,
          itemExtent: 45,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == 0) {
              return TipsTextView(S.of(context).categoryTypeTips);
            } else {
              return RadioListTile<String>(
                value: _templateTypes[index - 1],
                title: Text(_templateTypes[index - 1],
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                groupValue: _templateTypes[widget.notionDatabaseType],
                onChanged: (option) {
                  widget.notionDatabaseType = _templateTypes.indexOf(option!);
                  setState(() {});
                },
                activeColor: colorScheme.onSecondary,
                dense: true,
              );
            }
          },
        ),
      );
    });
  }
}

class _CollapsedMenu extends StatefulWidget {
  final TextEditingController controller;
  final String? notionDatabaseId;
  final double topPadding;
  final int notionDatabaseType;

  const _CollapsedMenu(
      {Key? key,
      required this.controller,
      required this.notionDatabaseType,
      this.notionDatabaseId,
      required this.topPadding})
      : super(key: key);

  @override
  State<_CollapsedMenu> createState() => _CollapsedMenuState();
}

class _CollapsedMenuState extends State<_CollapsedMenu> {
  var _offStageCard = true;
  var _showLoading = false;

  @override
  void initState() {
    super.initState();
    final notionDatabaseId = widget.notionDatabaseId;
    if (notionDatabaseId != null && notionDatabaseId.isNotEmpty) {
      context
          .read<NotionWorkFlow>()
          .linkDatabase(notionDatabaseId)
          .then((result) {
        if (result != null) {
          if (mounted)
            context.read<SyncWorkflowViewModel>().setDatabase = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SyncWorkflowViewModel>(context);
    final bindDatabase = viewModel.database;
    _offStageCard = bindDatabase == null;
    final showNetImage = bindDatabase?.cover?.external?.url != null &&
        bindDatabase?.cover?.external?.url != '';
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        width: double.infinity,
        child: Column(
          children: [
            _buildToggleRow(context),
            Divider(
              height: 1,
            ),
            SizedBox(
              height: 8,
            ),
            _offStageCard
                ? Column(
                    children: [
                      TextField(
                        controller: widget.controller,
                        maxLines: 1,
                        onSubmitted: (input) async {
                          if (input == null || input.isEmpty) {
                            Fluttertoast.showToast(
                                msg: S.of(context).pleaseInputKeywords);
                          } else {
                            _showLoading = true;
                            setState(() {});
                            viewModel.setObjectList = await context
                                .read<NotionWorkFlow>()
                                .searchObjects(keywords: input);
                            _showLoading = false;
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          prefixIconConstraints:
                              BoxConstraints(maxHeight: 25, maxWidth: 25),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                          ),
                          hintText: S.of(context).typeKeyWordsForSearchDB,
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          suffixIconConstraints:
                              BoxConstraints(maxHeight: 25, maxWidth: 25),
                          suffixIcon: Visibility(
                            visible: _showLoading,
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  strokeWidth: 2,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.topCenter,
                          curve: Curves.easeIn,
                          child: Container(
                              height: widget.topPadding,
                              child: TipsTextView(
                                S.of(context).notionPrompt,
                                showIcon: widget.topPadding != 0,
                              ))),
                      if (viewModel.notionObjectList.length == 0)
                        Container(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              S.of(context).haveNotFindAnything,
                              style: TextStyle(color: Colors.grey),
                            )),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.notionObjectList.length,
                          itemExtent: 52,
                          itemBuilder: (context, index) {
                            final object = viewModel.notionObjectList[index];
                            String? leading;
                            String? title;
                            String type = '';
                            if (object is database.NotionDatabase) {
                              type = 'Database';
                              leading = object.icon?.emoji ?? '\u{1F4D4}';
                              title = object.title?[0].text?.content;
                            } else if (object is page.NotionPage) {
                              type = 'Page';
                              leading = object.icon?.emoji ?? '\u{1F4C4}';
                              title = object
                                  .properties?.brief?.title?[0].text?.content;
                            }
                            viewModel.title = title ?? '';
                            return NotionObjectsListItem(
                              title: title,
                              leading: leading,
                              type: type,
                              onTap: () async {
                                EasyLoading.show();
                                if (object is database.NotionDatabase) {
                                  viewModel.setDatabase = object;
                                } else if (object is page.NotionPage) {
                                  final result = await context
                                      .read<NotionWorkFlow>()
                                      .createDatabase(object.id!,
                                          actionType:
                                              widget.notionDatabaseType);
                                  if (result != null) {
                                    viewModel.setDatabase = result;
                                  }
                                }
                                EasyLoading.dismiss();
                                setState(() {});
                              },
                            );
                          }),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  )
                : Container(
                    height: 210,
                    padding: EdgeInsets.only(bottom: 16),
                    child: NotionCardView(
                      title: '${bindDatabase?.title?[0].plainText}',
                      showNetImage: showNetImage,
                      coverUrl: '${bindDatabase?.cover?.external?.url}',
                      emoji:
                          '${bindDatabase?.icon?.type == 'emoji' ? bindDatabase?.icon?.emoji : ''}',
                      onTap: () {
                        context
                            .read<SyncWorkflowViewModel>()
                            .unlinkNotionDatabase();
                      },
                    ),
                  )
          ],
        ));
  }

  Widget _buildToggleRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = Provider.of<SyncWorkflowViewModel>(context);
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            S.of(context).autoSyncNotion,
            style: TextStyle(fontSize: 14),
          )),
          Container(
            width: 45,
            child: Switch(
              value: viewModel.autoSyncToggle,
              activeColor: colorScheme.primary,
              onChanged: (isOn) {
                viewModel.setAutoSyncToggle = isOn;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotionCardView extends StatelessWidget {
  final String title;
  final bool showNetImage;
  final String? coverUrl;
  final String? emoji;
  final VoidCallback? onTap;

  const NotionCardView(
      {Key? key,
      required this.title,
      required this.showNetImage,
      this.coverUrl,
      this.onTap,
      this.emoji})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        image: showNetImage
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  '${coverUrl}',
                                  //'${bindDatabase?.cover?.external?.url}',
                                ))
                            : DecorationImage(
                                scale: 5,
                                opacity: 0.7,
                                image:
                                    AssetImage('assets/images/bg_database.jpg'),
                              )),
                  ),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        iconSize: 25,
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          context
                              .read<SyncWorkflowViewModel>()
                              .unlinkNotionDatabase();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade400,
                        ),
                      ))
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              height: 40,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                  //'${bindDatabase?.icon?.type == 'emoji' ? bindDatabase?.icon?.emoji : ''}${bindDatabase?.title?[0].plainText}',
                  '${emoji ?? ''}${title}'),
            )
          ],
        ),
      ),
    );
  }
}
