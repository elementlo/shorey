import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/10/13
/// Description:
///

class FiledEventsPage extends StatefulWidget {
  const FiledEventsPage({Key? key}) : super(key: key);

  @override
  _FiledEventsPageState createState() => _FiledEventsPageState();
}

class _FiledEventsPageState extends State<FiledEventsPage> {
  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();
    EasyLoading.show();
    context.read<HomeViewModel>().queryFiledList().whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: S.of(context).achievedItemsTitle,
        actions: [
          IconButton(
              icon: Icon(
                Icons.clear_all_rounded,
                color: colorScheme.onSecondary,
              ),
              onPressed: () async {
                showConfirmDialog();
              })
        ],
      ),
      body: ListView.builder(
          itemCount: viewModel.filedListModel?.length ?? 0,
          itemBuilder: (context, index) {
            return FiledItem(model: viewModel.filedListModel![index]);
          }),
    );
  }

  void showConfirmDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              '确定要删除所有归档条目吗?',
              style: TextStyle(color: colorScheme.onSecondary),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    context.read<HomeViewModel>().clearFiledItems();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }
}

class FiledItem extends StatelessWidget {
  const FiledItem({Key? key, this.model}) : super(key: key);

  final ToDo? model;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: 20,
              top: 8,
              end: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.where_to_vote_rounded,
                      color: colorScheme.primaryVariant,
                      size: 22,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${model?.content ?? ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Text(
                            '${DateFormat('yyyy-MM-dd').format(model!.filedTime!)}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.withOpacity(0.5)),
                          ),
                        ],
                      ),
                      Text('${model?.brief ?? ''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.withOpacity(0.8))),
                      const SizedBox(
                        height: 6,
                      ),
                      Text('${model?.category ?? ''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.withOpacity(0.8))),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
