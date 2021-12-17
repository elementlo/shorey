import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/view_model/category_info_view_model.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';
import 'package:spark_list/widget/round_corner_rectangle.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/12/15
/// Description:
///

class CategoryInfoPage extends StatefulWidget {
  const CategoryInfoPage({Key? key}) : super(key: key);

  @override
  _CategoryInfoPageState createState() => _CategoryInfoPageState();
}

class _CategoryInfoPageState extends State<CategoryInfoPage> {
  final _controller = TextEditingController();
  var _showConfirm = false;
  late CategoryInfoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _showConfirm = _controller.text.isNotEmpty;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future _saveCategory() async {
    // int colorId = context.read<CategoryInfoViewModel>().selectedColor;
    // int iconId = context.read<CategoryInfoViewModel>().selectedIcon;
    int colorId = viewModel.selectedColor;
    int iconId = viewModel.selectedIcon;
    return context.read<HomeViewModel>().saveCategory(CategoriesCompanion(
        name: d.Value(_controller.text),
        colorId: d.Value(colorId),
        iconId: d.Value(iconId)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ProviderWidget<CategoryInfoViewModel>(
      model: CategoryInfoViewModel(),
      onModelReady: (vm) {
        viewModel = vm;
      },
      child: Scaffold(
        appBar: SparkAppBar(
          context: context,
          title: S.of(context).categoryInformation,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.check,
                  color: _showConfirm ? colorScheme.onSecondary : Colors.grey,
                ),
                onPressed: () async {
                  if (_showConfirm) {
                    await _saveCategory();
                    Navigator.pop(context);
                  }
                }),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              _EditNameArea(_controller),
              SizedBox(
                height: 20,
              ),
              _ColorSelector(),
              SizedBox(
                height: 20,
              ),
              _IconSelector()
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarActionButton extends StatelessWidget {
  const _ToolbarActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
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
    return RoundCornerRectangle(
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
    return RoundCornerRectangle(
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
