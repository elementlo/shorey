import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/pages/action_history_page.dart';
import 'package:spark_list/pages/filed_events_page.dart';
import 'package:spark_list/view_model/home_view_model.dart';


import 'about_page.dart';
import 'home_page.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/24/21
/// Description:
///
class CurtainPage extends StatefulWidget {
  @override
  _CurtainPageState createState() => _CurtainPageState();
}

class _CurtainPageState extends State<CurtainPage> {
  @override
  Widget build(BuildContext context) {
   Provider.of<HomeViewModel>(context);
    return Material(
      color: Colors.white12,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            Header(
              color: Colors.black,
              text: S.of(context).shoreyMomment,
            ),
            SizedBox(
              height: 16,
            ),
            _MomentGrid(),
            SizedBox(height: 8),
            SizedBox(height: 8),
            SettingsRow(
              title: S.of(context).actionHistory,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ActionHistoryPage()));
              },
            ),
            SizedBox(height: 8),
            SettingsRow(
              title: S.of(context).actionArchived,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FiledEventsPage()));
              },
            ),
            SizedBox(height: 8),
            SettingsRow(
              title: S.of(context).settings,
              onTap: () {
                Navigator.of(context).pushNamed(Routes.settingsCategoryPage);
              },
            ),
            SizedBox(height: 20),
            Divider(),
            _aboutView(),
            Divider(),
            SizedBox(height: 40),
            Image.asset(
              'assets/images/img_logo_grey.png',
              width: 30,
              height: 30,
              isAntiAlias: true,
              filterQuality: FilterQuality.medium,
            ),
            SizedBox(height: 8,),
            Align(
                child: Text('@Elemen', style: TextStyle(color: Colors.grey, fontSize: 12),),
            )
          ],
        ),
      ),
    );
  }

  Widget _aboutView() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AboutPage()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.announcement_outlined, color: Colors.grey),
            SizedBox(
              width: 20,
            ),
            Text(
              S.of(context).aboutShorey,
              style: TextStyle(color: Colors.grey, height: 1.2, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

///Colors.black12
///Theme.of(context).colorScheme.primaryVariant
///Color(0xFF1ab4bc)
///Color(0xFF2ad8e2)
class _MomentGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final cellWidth = (width - 32 - 25 * 13) / 2;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(cellWidth, 8, cellWidth, 16),
        child: Column(
          children: [
            Row(
              children: [
                for (int i = 0; i <= 12; i++)
                  Column(
                    children: [
                      for (int j = 0; j <= 6; j++)
                        _buildCell(i, j, context, useRandomColor: false)
                    ],
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCutline(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _randomColor(int row, int col, BuildContext context) {
    if (row % 3 == 0) {
      return Theme
          .of(context)
          .colorScheme
          .primaryVariant
          .withOpacity(0.6);
    } else if (row % 6 == 5) {
      return Color(0xFF1ab4bc).withOpacity(0.5);
    } else if (row % 4 == 3) {
      return Color(0xFF2ad8e2).withOpacity(0.2);
    } else {
      return Colors.black12.withOpacity(0.1);
    }
  }

  Color _tintColor(BuildContext context, DateTime dateTime) {
    final map = context
        .watch<HomeViewModel>()
        .heatPointsMap;
    String key = '${dateTime.year}${dateTime.month}${dateTime.day}';
    if (map.containsKey(key)) {
      int value = map[key]!;
      if (value > 0 && value <= 2) {
        return Color(0xFF2ad8e2).withOpacity(0.2);
      } else if (value > 2 && value <= 4) {
        return Color(0xFF1ab4bc).withOpacity(0.5);
      } else if (value > 4) {
        return Theme
            .of(context)
            .colorScheme
            .primaryVariant
            .withOpacity(0.6);
      } else {
        return Colors.black12.withOpacity(0.1);
      }
    } else {
      return Colors.black12.withOpacity(0.1);
    }
  }

  Widget _buildCell(int row, int col, BuildContext context,
      {bool useRandomColor = true}) {
    final dateTime = DateTime.now().add(
        Duration(days: -(DateTime
            .now()
            .weekday - 1 - col + (12 - row) * 7)));
    return Container(
      margin: EdgeInsets.only(right: 8, top: 8),
      height: 17,
      width: 17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: col == DateTime
            .now()
            .weekday - 1 && row == 12
            ? Border.all(color: Color(0xFF1ab4bc).withOpacity(0.5))
            : null,
        color: useRandomColor
            ? _randomColor(row, col, context)
            : _tintColor(context, dateTime),
      ),
    );
  }

  Widget _buildCutline(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(top: 8, right: 8),
            child: Text(
              S.of(context).archivedLess,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )),
        _buildCell(1, 1, context),
        _buildCell(7, 1, context),
        _buildCell(11, 1, context),
        _buildCell(3, 1, context),
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              S.of(context).archivedMore,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )),
      ],
    );
  }
}

class SettingsRow extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  SettingsRow({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            onTap?.call();
          },
          child: Container(
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: Text('${title}')),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onSecondary,
                )
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
