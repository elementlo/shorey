import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/generated/l10n.dart';
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
      appBar: SparkAppBar(context: context, title: S.of(context).actionHistoryTitle),
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
    return userAction != null
        ? Padding(
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
                      _buildRichText(userAction!, context),
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
          )
        : Container();
  }

  Widget _buildRichText(UserAction action, BuildContext context) {
    final spanList = <TextSpan>[];
    switch (action.action) {
      case 0:
        final span1 =
            TextSpan(text: '${S.of(context).actionAdd}  ', style: TextStyle(color: Color(0xffc9cba3)));
        final span2 = TextSpan(
            text: '${userAction?.updatedContent ?? ''}',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ));
        spanList.add(span1);
        spanList.add(span2);
        break;
      case 1:
        final span1 =
            TextSpan(text: '${S.of(context).actionArchived}  ', style: TextStyle(color: Color(0xffffe1a8)));
        final span2 = TextSpan(
            text: '${userAction?.updatedContent ?? ''}',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ));
        spanList.add(span1);
        spanList.add(span2);
        break;
      case 2:
        final span1 = TextSpan(
            text: '${userAction?.earlyContent ?? ''}  ',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ));
        final span2 =
            TextSpan(text: '${S.of(context).actionUpdate}  ', style: TextStyle(color: Color(0xffe26d5c)));
        final span3 = TextSpan(
            text: '${userAction?.updatedContent ?? ''}',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ));
        spanList.add(span1);
        spanList.add(span2);
        spanList.add(span3);
        break;
    }
    return RichText(
        text: TextSpan(
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            children: [...spanList]));
  }
}
