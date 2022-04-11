import 'dart:collection';
import 'dart:ui';

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/model/notion_database_model.dart' as database;
import 'package:spark_list/model/notion_page_model.dart' as page;
import 'package:spark_list/view_model/category_info_view_model.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';
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

GlobalKey? _searchKey = GlobalKey();

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
  double _topPadding = 0;

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
    if (_searchKey?.currentContext != null)
      Future.delayed(Duration(milliseconds: 300), () {
        Scrollable.ensureVisible(_searchKey!.currentContext!,
            duration: const Duration(milliseconds: 200));
        // final extent = _scrollController.position.maxScrollExtent;
        // if (extent > 0)
        //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        //       duration: Duration(milliseconds: 200), curve: Curves.ease);
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
                      key: _searchKey,
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
                              topPadding: _topPadding,
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

class _CollapsedMenu extends StatefulWidget {
  final TextEditingController controller;
  final String? notionDatabaseId;
  final double topPadding;

  const _CollapsedMenu(
      {Key? key,
      required this.controller,
      this.notionDatabaseId,
      required this.topPadding})
      : super(key: key);

  @override
  State<_CollapsedMenu> createState() => _CollapsedMenuState();
}

class _CollapsedMenuState extends State<_CollapsedMenu>
    with AutomaticKeepAliveClientMixin {
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
            context.read<CategoryInfoViewModel>().setDatabase = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = Provider.of<CategoryInfoViewModel>(context);
    final bindDatabase = viewModel.database;
    _offStageCard = bindDatabase == null;
    final showNetImage = bindDatabase?.cover?.external?.url != null &&
        bindDatabase?.cover?.external?.url != '';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      child: _offStageCard
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
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
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
                      height: MediaQuery.of(context).size.height - 200,
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
                        title =
                            object.properties?.brief?.title?[0].text?.content;
                      }
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
                                .createDatabase(object.id!);
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
                  height: 16,
                )
              ],
            )
          : Container(
              height: 200,
              padding: EdgeInsets.symmetric(vertical: 14),
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
                                          '${bindDatabase?.cover?.external?.url}',
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
                          '${bindDatabase?.icon?.type == 'emoji' ? bindDatabase?.icon?.emoji : ''}${bindDatabase?.title?[0].plainText}'),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TipsTextView extends StatelessWidget {
  final String tips;
  final bool showIcon;

  const TipsTextView(this.tips, {Key? key, this.showIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon)
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

class NotionObjectsListItem extends StatelessWidget {
  final String? title;
  final String? leading;
  final String type;
  final VoidCallback? onTap;

  const NotionObjectsListItem(
      {Key? key, this.title, this.leading, required this.type, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 30, child: Text('${leading}')),
              Text(
                '${title ?? 'untitled'}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Text(type,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          const Divider(height: 10)
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
    return Card(
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
              //'${bindDatabase?.icon?.type == 'emoji' ? bindDatabase?.icon?.emoji : ''}${bindDatabase?.title?[0].plainText}',
              '${emoji??''}${title}'
            ),
          )
        ],
      ),
    );
  }
}
