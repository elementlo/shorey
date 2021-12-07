import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/pages/alert_period_page.dart';
import 'package:spark_list/view_model/config_view_model.dart';
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
  var switchOn = false;

  @override
  void initState() {
    super.initState();
    context.read<ConfigViewModel>().getDefaultLocale().then((locale) {
      switchOn = locale == 'en';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: S.of(context).settings,
      ),
      body: ListView(
        children: [
          _SettingItem(
            title: S.of(context).editMantra,
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.mantraEditPage);
            },
          ),
          _SettingItem(
            title: S.of(context).retrospect,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AlertPeriodPage()));
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(S.of(context).languages,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                Text(switchOn ? 'English' : '中文'),
                Switch(
                  value: switchOn,
                  activeColor: colorScheme.primary,
                  inactiveTrackColor:
                      colorScheme.primaryVariant.withOpacity(0.8),
                  onChanged: (isOn) async {
                    setState(() {
                      switchOn = isOn;
                      S.load(Locale(isOn ? 'en' : 'zh', ''));
                    });
                    context
                        .read<ConfigViewModel>()
                        .savePerfLocale(Locale(isOn ? 'en' : 'zh', ''));
                  },
                ),
              ],
            ),
          ),
          Divider(
            indent: 16,
            endIndent: 16,
          )
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
