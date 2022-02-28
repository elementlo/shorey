import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/16/21
/// Description:
///

class MantraEditPage extends StatefulWidget {
  @override
  _MantraEditPageState createState() => _MantraEditPageState();
}

class _MantraEditPageState extends State<MantraEditPage> {
  TextEditingController _controller = TextEditingController();
  String mantra = '';

  void _fetchMantra() async {
    mantra = await context.read<HomeViewModel>().getMantra() ?? '';
    _controller.text = mantra;
    setState(() {});
  }

  Future _saveMantra(String text) async {
    await context.read<HomeViewModel>().saveMantra(text);
  }

  @override
  void initState() {
    super.initState();
    _fetchMantra();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: S.of(context).mantraEditTitle,
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: colorScheme.onSecondary,
              ),
              onPressed: () async {
                mantra = _controller.text;
                await _saveMantra(_controller.text);
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            suffixIcon: Icon(Ionicons.create_outline),
          ),
        ),
      ),
    );
  }
}
