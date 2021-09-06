import 'package:flutter/material.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/pages/push_frequency_page.dart';
import 'package:spark_list/widget/app_bar.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/16/21
/// Description:
///

class SettingsCategoryPage extends StatefulWidget {
  @override
  _SettingsCategoryPageState createState() => _SettingsCategoryPageState();
}

class _SettingsCategoryPageState extends State<SettingsCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: '设置',
      ),
      body: ListView(
        children: [
          _SettingItem(
            title: '编辑Mantra',
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.mantraEditPage);
            },
          ),
          _SettingItem(
            title: '默认推送频率',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PushFrequencyPage()));
            },
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;

  _SettingItem({this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        child: Column(
          children: [
            ListTile(
              title: Text('${title}'),
            ),
            Divider(
              indent: 16,
              endIndent: 16,
            )
          ],
        ),
      ),
    );
  }
}
