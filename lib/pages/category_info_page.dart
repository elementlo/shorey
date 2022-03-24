import 'dart:collection';
import 'dart:ui';

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/view_model/category_info_view_model.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';
import 'package:spark_list/widget/category_list_item.dart';
import 'package:spark_list/widget/round_corner_rectangle.dart';
import 'package:spark_list/widget/settings_list_item.dart';
import 'package:spark_list/workflow/notion_workflow.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/12/15
/// Description:
///

enum _ExpandableSetting { linkNotionDatabase, categoryType }

class CategoryInfoPage extends StatefulWidget {
  const CategoryInfoPage({Key? key, this.editingItem}) : super(key: key);

  final CategoryItem? editingItem;

  @override
  _CategoryInfoPageState createState() => _CategoryInfoPageState();
}

class _CategoryInfoPageState extends State<CategoryInfoPage>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final TextEditingController _databaseController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Animation<double> _staggerSettingsItemsAnimation;
  _ExpandableSetting? _expandedSettingId;
  late AnimationController _settingsPanelController;

  late List<String> _categoryTypes;
  late int _selectedOption;
  var _showConfirm = false;
  var _linked = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingItem != null) {
      _controller.text = widget.editingItem!.name;
    }
    _controller.addListener(() {
      _showConfirm = _controller.text.isNotEmpty;
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _settingsPanelController.dispose();
    _databaseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTapSetting(_ExpandableSetting settingId) {
    Future.delayed(Duration(milliseconds: 300), () {
      final extent = _scrollController.position.maxScrollExtent;
      if (extent > 0)
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
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

  Future _saveCategory(BuildContext context) async {
    final viewModel =
        Provider.of<CategoryInfoViewModel>(context, listen: false);
    int colorId = viewModel.selectedColor;
    int iconId = viewModel.selectedIcon;
    String? notionDatabaseId = viewModel.database?.id;
    int? notionDatabaseType;
    if (notionDatabaseId != null && notionDatabaseId.isNotEmpty) {
      notionDatabaseType = _selectedOption;
    }
    return context.read<HomeViewModel>().saveCategory(CategoriesCompanion(
        name: d.Value(_controller.text),
        colorId: d.Value(colorId),
        iconId: d.Value(iconId),
        notionDatabaseId: d.Value(notionDatabaseId),
        notionDatabaseType: d.Value(notionDatabaseType)));
  }

  Future _updateCategory(BuildContext context, CategoryItem item) async {
    final viewModel =
        Provider.of<CategoryInfoViewModel>(context, listen: false);
    int colorId = viewModel.selectedColor;
    int iconId = viewModel.selectedIcon;
    String? notionDatabaseId = viewModel.database?.id;
    int? notionDatabaseType;
    if (notionDatabaseId != null && notionDatabaseId.isNotEmpty) {
      notionDatabaseType = _selectedOption;
    }
    return context.read<HomeViewModel>().updateCategory(CategoriesCompanion(
          id: d.Value(item.id),
          name: d.Value(_controller.text),
          iconId: d.Value(iconId),
          colorId: d.Value(colorId),
          notionDatabaseId: d.Value(notionDatabaseId),
          notionDatabaseType: d.Value(notionDatabaseType),
        ));
  }

  Widget _optionChildList(ColorScheme colorScheme) {
    return Consumer<CategoryInfoViewModel>(builder: (context, viewModel, _) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _categoryTypes = [
      S.of(context).taskList,
      S.of(context).templateDiaryTitle,
    ];
    return ProviderWidget<CategoryInfoViewModel>(
      model: CategoryInfoViewModel(),
      onModelReady: (viewModel) async {
        _linked = await viewModel.checkLinkingStatus();
        _selectedOption = widget.editingItem?.notionDatabaseType ?? 0;
        setState(() {});
      },
      child: Scaffold(
        appBar: SparkAppBar(
          context: context,
          title: S.of(context).categoryInformation,
          actions: [
            Consumer<CategoryInfoViewModel>(
              builder: (BuildContext context, value, Widget? child) {
                return IconButton(
                    icon: Icon(
                      Icons.check,
                      color:
                          _showConfirm ? colorScheme.onSecondary : Colors.grey,
                    ),
                    onPressed: () async {
                      if (_showConfirm) {
                        if (widget.editingItem != null) {
                          await _updateCategory(context, widget.editingItem!);
                        } else {
                          await _saveCategory(context);
                        }
                        Navigator.pop(context);
                      }
                    });
              },
            ),
          ],
        ),
        body: Container(
          child: ListView(
            controller: _scrollController,
            children: [
              _EditNameArea(_controller),
              SizedBox(
                height: 20,
              ),
              _ColorSelector(),
              SizedBox(
                height: 20,
              ),
              _IconSelector(),
              SizedBox(
                height: 20,
              ),
              if (_linked) ...[
                AnimateSettingsListItems(
                  animation: _staggerSettingsItemsAnimation,
                  children: [
                    SettingsListItem<double>(
                      title: S.of(context).categoryType,
                      optionsMap: LinkedHashMap.of({
                        1.0:
                            DisplayOption('${_categoryTypes[_selectedOption]}'),
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
                    Consumer<CategoryInfoViewModel>(
                      builder: (context, viewModel, _) {
                        return SettingsListItem<double>(
                          title: S.of(context).linkNotionDatabase,
                          selectedOption: 1.0,
                          optionsMap: LinkedHashMap.of({
                            1.0: DisplayOption(
                                '${viewModel.database?.title?[0].plainText ?? ''}')
                          }),
                          onOptionChanged: (newTextScale) {},
                          onTapSetting: () => _onTapSetting(
                              _ExpandableSetting.linkNotionDatabase),
                          isExpanded: _expandedSettingId ==
                              _ExpandableSetting.linkNotionDatabase,
                          child: _NotionDatabaseCard(
                              controller: _databaseController,
                              notionDatabaseId:
                                  widget.editingItem?.notionDatabaseId),
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
          ),
        ),
      ),
    );
  }
}

class _EditNameArea extends StatefulWidget {
  final TextEditingController controller;

  const _EditNameArea(this.controller, {Key? key}) : super(key: key);

  @override
  _EditNameAreaState createState() => _EditNameAreaState();
}

class _EditNameAreaState extends State<_EditNameArea> {
  @override
  Widget build(BuildContext context) {
    return RoundCornerRectangle(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          Container(
            child: TextField(
              onSubmitted: (String finalInput) async {
                print('onsubmit: ${finalInput}');
                if (finalInput.isNotEmpty) {}
              },
              controller: widget.controller,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: S.of(context).addCategoryName,
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 6)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSelector extends StatefulWidget {
  const _ColorSelector({Key? key}) : super(key: key);

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<_ColorSelector> {
  @override
  Widget build(BuildContext context) {
    final spacing = (MediaQuery.of(context).size.width - 16 * 4 - 45 * 6) / 5;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: RoundCornerRectangle(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: 12,
          children: [
            for (int i = 1; i <= 12; i++)
              GestureDetector(
                  onTap: () {
                    context.read<CategoryInfoViewModel>().selectedColor = i;
                  },
                  child: _buildCell(i)),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: context.watch<CategoryInfoViewModel>().selectedColor == index
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 2))
          : null,
      width: 45,
      height: 45,
      child: ClipOval(
        child: Container(
          color: Color(SColor.colorMap[index]!),
        ),
      ),
    );
  }
}

class _IconSelector extends StatefulWidget {
  const _IconSelector({Key? key}) : super(key: key);

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<_IconSelector> {
  @override
  Widget build(BuildContext context) {
    final spacing = (MediaQuery.of(context).size.width - 16 * 4 - 45 * 6) / 5;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: RoundCornerRectangle(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: 12,
          children: [
            for (int i = 1; i <= 42; i++)
              GestureDetector(
                  onTap: () {
                    context.read<CategoryInfoViewModel>().selectedIcon = i;
                  },
                  child: _buildCell(i)),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    return Container(
      width: 45,
      height: 45,
      decoration: context.watch<CategoryInfoViewModel>().selectedIcon == index
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 2))
          : null,
      child: ClipOval(
        child: Container(
          child: Icon(
            SIcons.iconMap[index]!,
            color: context.watch<CategoryInfoViewModel>().selectedIcon == index
                ? Color(SColor.colorMap[
                    context.watch<CategoryInfoViewModel>().selectedColor]!)
                : Colors.grey.shade700,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _NotionDatabaseCard extends StatefulWidget {
  final TextEditingController controller;
  final String? notionDatabaseId;

  const _NotionDatabaseCard(
      {Key? key, required this.controller, this.notionDatabaseId})
      : super(key: key);

  @override
  State<_NotionDatabaseCard> createState() => _NotionDatabaseCardState();
}

class _NotionDatabaseCardState extends State<_NotionDatabaseCard> {
  var offStageCard = true;

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
            context.read<CategoryInfoViewModel>().setDatabase = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = Provider.of<CategoryInfoViewModel>(context);
    final database = viewModel.database;
    offStageCard = database == null;
    final showNetImage = database?.cover?.external?.url != null &&
        database?.cover?.external?.url != '';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      height: 230,
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
                    //labelText: S.of(context).notionPageId,
                    prefixIconConstraints: BoxConstraints(maxHeight: 25, maxWidth: 25),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey,
                    ),
                    hintText: S.of(context).typeKeyWordsForSearchDB,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    // suffix: Container(
                    //   width: 25,
                    //   height: 25,
                    //   child: IconButton(
                    //       padding: EdgeInsets.all(0),
                    //       onPressed: () async {
                    //         if (widget.controller.text.isNotEmpty) {
                    //           FocusScope.of(context).requestFocus(FocusNode());
                    //           EasyLoading.show();
                    //           final result = await context
                    //               .read<NotionWorkFlow>()
                    //               .linkDatabase(widget.controller.text);
                    //           if (result != null) {
                    //             offStageCard = false;
                    //             viewModel.setDatabase = result;
                    //             setState(() {});
                    //           } else {
                    //             EasyLoading.show();
                    //             final result = await context
                    //                 .read<NotionWorkFlow>()
                    //                 .createDatabase(widget.controller.text);
                    //             if (result != null) {
                    //               offStageCard = false;
                    //               viewModel.setDatabase = result;
                    //               setState(() {});
                    //             }
                    //           }
                    //           EasyLoading.dismiss();
                    //         }
                    //       },
                    //       icon: Icon(
                    //         Icons.check,
                    //         color: colorScheme.onSecondary,
                    //       )),
                    // ),
                  ),
                ),
                SizedBox(
                  height: 12,
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
                                        '${database?.cover?.external?.url}',
                                      ))
                                  : DecorationImage(
                                      scale: 5,
                                      opacity: 0.7,
                                      image: AssetImage(
                                          'assets/images/bg_database.jpg'),
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
                                    .read<CategoryInfoViewModel>()
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
                          '${database?.icon?.type == 'emoji' ? database?.icon?.emoji : ''}${database?.title?[0].plainText}'))
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
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
