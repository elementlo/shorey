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
import 'package:spark_list/widget/round_corner_rectangle.dart';

import 'curtain_page.dart';
import 'sync_workflow_page.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/12/15
/// Description:
///

class CategoryInfoPage extends StatefulWidget {
  const CategoryInfoPage({Key? key, this.editingItem}) : super(key: key);

  final CategoryItem? editingItem;

  @override
  _CategoryInfoPageState createState() => _CategoryInfoPageState();
}

class _CategoryInfoPageState extends State<CategoryInfoPage> {
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  var _showConfirm = false;
  String? _notionDatabaseId;
  int _notionDatabaseType = 0;
  bool _autoSync = true;
  String? _typeName;
  String? _databaseName;

  @override
  void initState() {
    super.initState();
    if (widget.editingItem != null) {
      _controller.text = widget.editingItem!.name;
      _notionDatabaseId = widget.editingItem!.notionDatabaseId;
      _notionDatabaseType = widget.editingItem!.notionDatabaseType;
      _autoSync = widget.editingItem!.autoSync;
    }
    _controller.addListener(() {
      _showConfirm = _controller.text.isNotEmpty;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future _saveCategory(BuildContext context) async {
    final viewModel =
        Provider.of<CategoryInfoViewModel>(context, listen: false);
    int colorId = viewModel.selectedColor;
    int iconId = viewModel.selectedIcon;
    return context.read<HomeViewModel>().saveCategory(CategoriesCompanion(
        name: d.Value(_controller.text),
        colorId: d.Value(colorId),
        iconId: d.Value(iconId),
        autoSync: d.Value(_autoSync),
        notionDatabaseId: d.Value(_notionDatabaseId),
        notionDatabaseType: d.Value(_notionDatabaseType)));
  }

  Future _updateCategory(BuildContext context, CategoryItem item) async {
    final viewModel =
        Provider.of<CategoryInfoViewModel>(context, listen: false);
    int colorId = viewModel.selectedColor;
    int iconId = viewModel.selectedIcon;

    return context.read<HomeViewModel>().updateCategory(CategoriesCompanion(
          id: d.Value(item.id),
          name: d.Value(_controller.text),
          iconId: d.Value(iconId),
          colorId: d.Value(colorId),
          autoSync: d.Value(_autoSync),
          notionDatabaseId: d.Value(_notionDatabaseId),
          notionDatabaseType: d.Value(_notionDatabaseType),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ProviderWidget<CategoryInfoViewModel>(
      model: CategoryInfoViewModel(),
      onModelReady: (viewModel) async {
        viewModel.selectedColor = widget.editingItem?.colorId ?? 1;
        viewModel.selectedIcon = widget.editingItem?.iconId ?? 1;
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SettingsRow(
                  title: S.of(context).workFlow,
                  hint: _databaseName == null
                      ? ''
                      : '${_databaseName}(${_typeName})',
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => SyncWorkflowPage(
                                  notionDatabaseId: _notionDatabaseId,
                                  notionDatabaseType: _notionDatabaseType,
                                  autoSyncToggle: _autoSync,
                                )))
                        .then((result) {
                      if (result != null) {
                        _notionDatabaseType = result['notionDatabaseType'];
                        _notionDatabaseId = result['notionDatabaseId'];
                        _autoSync = result['autoSync'];
                        _typeName = result['typeName'];
                        _databaseName = result['databaseName'];
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
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
