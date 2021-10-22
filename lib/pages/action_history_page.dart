import 'package:flutter/material.dart';
import 'package:spark_list/widget/app_bar.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/10/21
/// Description:
///
class ActionHistoryPage extends StatefulWidget {
  const ActionHistoryPage({Key? key}) : super(key: key);

  @override
  _ActionHistoryPageState createState() => _ActionHistoryPageState();
}

class _ActionHistoryPageState extends State<ActionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SparkAppBar(context: context, title: "行为历史"),
      body: Container(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                child: ListTile(
                  leading: Icon(Icons.wb_incandescent_rounded),
                ),
              );
            }),
      ),
    );
  }
}
