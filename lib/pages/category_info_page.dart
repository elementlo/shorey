import 'package:flutter/material.dart';
import 'package:spark_list/generated/l10n.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: S.of(context).categoryInformation,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _EditNameArea(),
            SizedBox(
              height: 20,
            ),
            _ColorSelector(),
          ],
        ),
      ),
    );
  }
}

class _EditNameArea extends StatefulWidget {
  const _EditNameArea({Key? key}) : super(key: key);

  @override
  _EditNameAreaState createState() => _EditNameAreaState();
}

class _EditNameAreaState extends State<_EditNameArea> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: S.of(context).addCategoryName,
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 0, top: 6)),
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
    final spacing = (MediaQuery.of(context).size.width - 16 * 4 - 35 * 6) / 5;
    return RoundCornerRectangle(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: spacing,
        runSpacing: 12,
        children: [
          for (int i = 0; i < 12; i++) _buildCell(i),
        ],
      ),
    );
  }

  Widget _buildCell(int index) {
    return ClipOval(
      child: Container(
        width: 35,
        height: 35,
        color: Colors.greenAccent,
      ),
    );
  }
}
