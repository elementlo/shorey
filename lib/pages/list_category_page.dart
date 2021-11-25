import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/view_model/category_list_view_model.dart';
import 'package:spark_list/view_model/config_view_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/14/21
/// Description:
///
class ListCategoryPage extends StatefulWidget {
  @override
  _ListCategoryPageState createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CategoryListViewModel>(
      onModelReady: (viewModel) {},
      model: CategoryListViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).categoryList),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
        ),
        body: Container(
          child: ListView(
            children: [
              for (int i = 0; i <= 5; i++)
                _CategoryItem(
                    title: context
                        .read<ConfigViewModel>()
                        .categoryDemosList[i]
                        .name,
                    icon: context
                        .read<ConfigViewModel>()
                        .categoryDemosList[i]
                        .icon,
                    index: i),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String? title;
  final int? index;
  final Icon? icon;

  _CategoryItem({this.title, this.index, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CategoryListViewModel>().selectedCategoryIndex = index;
        Future.delayed(Duration(milliseconds: 200),(){
          Navigator.pop(context, title);
        });
      },
      child: Column(
        children: [
          ListTile(
            leading: icon,
            trailing:
                context.watch<CategoryListViewModel>().selectedCategoryIndex ==
                        index
                    ? Icon(
                        Icons.check,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSecondary,
                      )
                    : null,
            title: Text('${title}'),
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          )
        ],
      ),
    );
  }
}
