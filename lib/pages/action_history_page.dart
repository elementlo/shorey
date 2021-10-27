import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/view_model/home_view_model.dart';
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
  void initState() {
    super.initState();
    context.read<HomeViewModel>().queryActions();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      appBar: SparkAppBar(context: context, title: "行为历史"),
      body: Container(
        child: ListView.builder(
            itemCount: viewModel.userActionList?.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                  child: _ActionItem(
                userAction: viewModel.userActionList?[index],
              ));
            }),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final UserAction? userAction;

  const _ActionItem({Key? key, this.userAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 20,
        top: 20,
        end: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                Icons.wb_incandescent_rounded,
                color: colorScheme.primaryVariant,
                size: 22,
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        children: [
                      TextSpan(
                          text: '新增  ',
                          style: TextStyle(color: Color(0xffc9cba3))),
                      TextSpan(
                          text: '${userAction?.updatedContent ?? ''}',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ])),
                Text(
                  '${userAction?.formatFiledTime}',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.withOpacity(0.5)),
                ),
                const SizedBox(height: 8),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: Theme.of(context).colorScheme.background,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
