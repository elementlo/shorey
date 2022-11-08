import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shorey/generated/l10n.dart';
import 'package:shorey/pages/category_info_page.dart';
import 'package:shorey/view_model/config_view_model.dart';
import 'package:shorey/view_model/home_view_model.dart';
import 'package:shorey/widget/category_list_item.dart';
import 'package:shorey/widget/daily_focus_panel.dart';
import 'package:shorey/widget/home_header.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/23/21
/// Description:
///
class HomePage extends StatefulWidget {
  final AnimationController? animationController;
  final String? title;

  HomePage({Key? key, this.title, required this.animationController})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int? _expandedSettingId = -1;

  @override
  void initState() {
    super.initState();
    widget.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final configViewModel = Provider.of<ConfigViewModel>(context);
    final categoryDemosList = configViewModel.categoryDemosList;
    return ListView(
      restorationId: 'home_list_view',
      children: [
        const SizedBox(
          height: 8,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: HomeHeader(),
        ),
        DailyFocusPanel(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController!,
                  curve:
                      Interval((1 / 9) * 1, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: _CategoriesHeader(),
        ),
        for (int i = 0; i < (categoryDemosList.length); i++)
          CategoryListItem(categoryDemosList[i],
              key: PageStorageKey<String>(
                'CategoryListItem${i}',
              ),
              restorationId: 'home_material_category_list',
              imageString: 'assets/icons/material/material.png',
              demoList: (viewModel.allItemsList
                  ?.where((item) => item?.categoryId == categoryDemosList[i].id)
                  .toList() ??
                  []),
              initiallyExpanded: false,
              isExpanded: _expandedSettingId == categoryDemosList[i].id,
              icon: categoryDemosList[i].icon, onTap: (shouldOpenList) {
            if (shouldOpenList) {
              _expandedSettingId = categoryDemosList[i].id;
            } else {
              _expandedSettingId = -1;
            }
            setState(() {});
          }),
      ],
    );
  }
}

class _CategoriesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Header(
      color: Theme.of(context).colorScheme.primaryVariant,
      text: S.of(context).mainCategory,
      tailing: PopupMenuButton(
        icon: Icon(
          Icons.more_horiz,
          color: colorScheme.primaryVariant,
        ),
        onSelected: (value) {
          switch (value) {
            case 'add':
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoryInfoPage()));
              break;
          }
        },
        elevation: 3,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                height: 28,
                value: 'add',
                child: Text(
                  S.of(context).addCategory,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                )),
          ];
        },
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({this.color, this.tailing, required this.text});

  final Color? color;
  final String? text;
  final Widget? tailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text!,
              style: Theme.of(context).textTheme.headline4!.apply(
                    color: color,
                  ),
            ),
          ),
          if (tailing != null) tailing!
        ],
      ),
    );
  }
}
