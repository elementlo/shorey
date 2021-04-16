import 'package:flutter/material.dart';
import 'package:spark_list/config/config.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.white12,
      // color: colorScheme.secondaryVariant,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Header(
              color: Colors.black,
              text: 'Spark Moment',
            ),
          ),
          SizedBox(height: 16,),
          _MomentGrid(),
          Divider(
            indent: 16,
            endIndent: 16,
          ),
        _SettingsRow(title: '设置'),
        ],
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
    final width = MediaQuery.of(context).size.width;
    final cellWidth = (width - 32 - 25 * 13) / 2;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white
          // color: Theme.of(context).scaffoldBackgroundColor
          ),
      child: Container(
        padding: EdgeInsets.fromLTRB(cellWidth, 8, cellWidth, 16),
        child: Column(
          children: [
            for (int i = 0; i <= 6; i++)
              Row(
                children: [
                  for (int i = 0; i <= 12; i++)
                    _buildCell(i, context)
                ],
              ),
            SizedBox(height: 10,),
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

  Color _randomColor(int i, BuildContext context) {
    if (i % 3 == 0) {
      return Theme.of(context).colorScheme.primaryVariant.withOpacity(0.6);
    } else if (i % 6 == 5) {
      return Color(0xFF1ab4bc).withOpacity(0.5);
    } else if (i % 4 == 3) {
      return Color(0xFF2ad8e2).withOpacity(0.2);
    }
    else {
      return Colors.black12.withOpacity(0.1);
    }
  }

  Widget _buildCell(int i, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8, top: 8),
      height: 17,
      width: 17,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: _randomColor(i, context)),
    );
  }
  
  Widget _buildCutline(BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.only(top:8, right: 8),
            child: Text('Completed Less', style: TextStyle(fontSize: 12, color: Colors.grey),)),
        _buildCell(1, context),
        _buildCell(7, context),
        _buildCell(11, context),
        _buildCell(3, context),
        Padding(padding: EdgeInsets.only(top:8),
            child: Text('More', style: TextStyle(fontSize: 12, color: Colors.grey),)),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  
  _SettingsRow({this.title});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(Routes.settingsCategoryPage);
          },
          child: Container(
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: Text('${title}')),
                SizedBox(width: 8,),
                Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).colorScheme.onSecondary,)
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
