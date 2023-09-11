import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shorey/config/config.dart';
import 'package:shorey/generated/l10n.dart';
import 'package:shorey/pages/alert_period_page.dart';
import 'package:shorey/pages/link_notion_page.dart';
import 'package:shorey/view_model/config_view_model.dart';
import 'package:shorey/view_model/home_view_model.dart';
import 'package:shorey/widget/app_bar.dart';

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
  var _switchOn = false;

  @override
  void initState() {
    super.initState();
    context.read<ConfigViewModel>().getDefaultLocale().then((locale) {
      _switchOn = locale == 'en';
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
          SettingItem(
            title: S.of(context).editMantra,
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.mantraEditPage);
            },
          ),
          SettingItem(
            title: S.of(context).retrospect,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AlertPeriodPage()));
            },
          ),
          SettingItem(
            title: S.of(context).bindNotion,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LinkNotionPage()));
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(S.of(context).languages,
                        style: TextStyle(color: Colors.black))),
                Text(_switchOn ? '中文' : 'English'),
                Switch(
                  value: _switchOn,
                  activeColor: colorScheme.primary,
                  inactiveTrackColor:
                      colorScheme.primaryContainer.withOpacity(0.8),
                  onChanged: (isOn) async {
                    setState(() {
                      _switchOn = isOn;
                      print('switch is on: ${isOn}');
                      S
                          .load(Locale(isOn ? 'en' : 'zh', ''))
                          .then((value) async {
                        await context
                            .read<ConfigViewModel>()
                            .savePerfLocale(Locale(isOn ? 'en' : 'zh', ''));
                        Mantra.updateMantra();
                        await context.read<HomeViewModel>().initMantra();
                      });
                    });
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

class SettingItem extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;

  SettingItem({this.title, this.onPressed});

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
