import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shorey/base/provider_widget.dart';
import 'package:shorey/generated/l10n.dart';
import 'package:shorey/view_model/category_list_view_model.dart';
import 'package:shorey/view_model/config_view_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/14/21
/// Description:
///
class ListCategoryPage extends StatefulWidget {
  int categoryId;

  ListCategoryPage(this.categoryId);

  @override
  _ListCategoryPageState createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final categoryList = context.read<ConfigViewModel>().categoryDemosList;
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
              for (int i = 0; i < categoryList.length; i++)
                _CategoryItem(
                  title: categoryList[i].name,
                  icon: categoryList[i].icon,
                  selected: categoryList[i].id == widget.categoryId,
                  onTap: () {
                    widget.categoryId = categoryList[i].id;
                    setState(() {});
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.pop(context, widget.categoryId);
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatefulWidget {
  final String? title;
  final Icon? icon;
  final bool selected;
  final VoidCallback? onTap;

  _CategoryItem({this.title, this.icon, required this.selected, this.onTap});

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          ListTile(
            leading: widget.icon,
            trailing: widget.selected
                ? Icon(
                    Icons.check,
                    size: 30,
                    color: Theme.of(context).colorScheme.onSecondary,
                  )
                : null,
            title: Text('${widget.title}'),
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
