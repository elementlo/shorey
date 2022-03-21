import 'package:drift/drift.dart' as d;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/pages/add_new_item_page.dart';
import 'package:spark_list/pages/category_info_page.dart';
import 'package:spark_list/pages/editor_page.dart';
import 'package:spark_list/pages/root_page.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/workflow/notion_workflow.dart';

import '../view_model/config_view_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/8/21
/// Description:
///

typedef CategoryHeaderTapCallback = Function(bool shouldOpenList);

class CategoryListItem extends StatefulWidget {
  const CategoryListItem(this.category,
      {Key? key,
      this.restorationId,
      this.imageString,
      this.demos = const [''],
      this.initiallyExpanded = false,
      this.onTap,
      this.icon,
      this.demoList})
      : assert(initiallyExpanded != null),
        super(key: key);

  final String? restorationId;
  final String? imageString;
  final CategoryItem category;

  final List<String> demos;
  final List<ToDo?>? demoList;
  final bool initiallyExpanded;
  final CategoryHeaderTapCallback? onTap;
  final Icon? icon;

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static const _expandDuration = Duration(milliseconds: 200);
  late AnimationController _controller;
  late Animation<double> _childrenHeightFactor;
  late Animation<double> _headerChevronOpacity;
  late Animation<double> _headerHeight;
  late Animation<EdgeInsetsGeometry> _headerMargin;
  late Animation<EdgeInsetsGeometry> _headerImagePadding;
  late Animation<EdgeInsetsGeometry> _childrenPadding;
  late Animation<BorderRadius?> _headerBorderRadius;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: _expandDuration, vsync: this);
    _controller.addStatusListener((status) {
      setState(() {});
    });

    _childrenHeightFactor = _controller.drive(_easeInTween);
    _headerChevronOpacity = _controller.drive(_easeInTween);
    _headerHeight = Tween<double>(
      begin: 55,
      end: 76,
    ).animate(_controller);
    _headerMargin = EdgeInsetsGeometryTween(
      begin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      end: EdgeInsets.zero,
    ).animate(_controller);
    _headerImagePadding = EdgeInsetsGeometryTween(
      begin: const EdgeInsets.all(8),
      end: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
    ).animate(_controller);
    _childrenPadding = EdgeInsetsGeometryTween(
      begin: const EdgeInsets.symmetric(horizontal: 16),
      end: EdgeInsets.zero,
    ).animate(_controller);
    _headerBorderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(10),
      end: BorderRadius.zero,
    ).animate(_controller);

    if (widget.initiallyExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool? _shouldOpenList() {
    switch (_controller.status) {
      case AnimationStatus.completed:
      case AnimationStatus.forward:
        return false;
      case AnimationStatus.dismissed:
      case AnimationStatus.reverse:
        return true;
    }
  }

  void _handleTap() {
    if (_shouldOpenList()!) {
      _controller.forward();
      if (widget.onTap != null) {
        widget.onTap!(true);
      }
    } else {
      _controller.reverse();
      if (widget.onTap != null) {
        widget.onTap!(false);
      }
    }
  }

  Widget _buildHeaderWithChildren(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CategoryHeader(
          widget.category,
          margin: _headerMargin.value,
          imagePadding: _headerImagePadding.value,
          borderRadius: _headerBorderRadius.value,
          height: _headerHeight.value,
          chevronOpacity: _headerChevronOpacity.value,
          imageString: widget.imageString,
          icon: widget.icon,
          onTap: _handleTap,
        ),
        Padding(
          padding: _childrenPadding.value,
          child: ClipRect(
            child: Align(
              heightFactor: _childrenHeightFactor.value,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildHeaderWithChildren,
      child: _shouldOpenList()!
          ? null
          : _ExpandedCategoryDemos(
              category: widget.category,
              demos: widget.demos,
              demoList: widget.demoList),
    );
  }
}

class _ExpandedCategoryDemos extends StatefulWidget {
  _ExpandedCategoryDemos({
    Key? key,
    required this.category,
    this.demos,
    this.demoList,
  }) : super(key: key);

  final CategoryItem category;

  final List<String>? demos;

  final List<ToDo?>? demoList;

  @override
  State<_ExpandedCategoryDemos> createState() => _ExpandedCategoryDemosState();
}

class _ExpandedCategoryDemosState extends State<_ExpandedCategoryDemos> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('${widget.category}DemoList'),
      children: [
        if (widget.demoList != null && widget.demoList!.length > 0)
          for (int i = 0; i < widget.demoList!.length; i++)
            CategoryDemoItem(
              model: widget.demoList![i],
              category: widget.category,
            ),
        _buildNewTaskField(context),
        const SizedBox(height: 12), // Extra space below.
      ],
    );
  }

  Future _updatePageId(int index, String? pageId) async {
    if (pageId != null) {
      final companion =
          ToDosCompanion(id: d.Value(index), pageId: d.Value(pageId));
      await appContext
          .read<HomeViewModel>()
          .updateTodoItem(companion, companion);
    }
  }

  Widget _buildNewTaskField(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.only(bottom: 5, left: 32, right: 8),
      child: TextField(
        controller: _controller,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
            hintText: 'Write something...',
            contentPadding: EdgeInsets.only(
              left: 5,
            ),
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 14,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.background),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.background),
            ),
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.background),
            ),
            suffix: Container(
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () async {
                    /// unsave item now
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => AddNewItemPage(
                                widget.category,
                                title: _controller.text)))
                        .then((result) {
                      if (result == 0) {
                        _controller.clear();
                      }
                      context
                          .read<HomeViewModel>()
                          .queryToDoList(categoryId: widget.category.id);
                    });
                  },
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.onSecondary,
                  )),
            )),
        onSubmitted: (input) async {
          print(input);
          if (input != '' && input != null) {
            final dateTime = DateTime.now();
            final index = await viewModel.saveToDo(ToDosCompanion(
                categoryId: d.Value(widget.category.id),
                status: d.Value(1),
                content: d.Value(input),
                createdTime: d.Value(dateTime)));
            await viewModel.queryToDoList(categoryId: widget.category.id);
            _controller.clear();
            if (widget.category.notionDatabaseId != null &&
                context.read<ConfigViewModel>().linkedNotion) {
              final pageId = await context.read<NotionWorkFlow>().addTaskItem(
                  widget.category.notionDatabaseId!,
                  ToDo(
                      id: index,
                      content: input,
                      createdTime: dateTime,
                      categoryId: widget.category.id,
                      status: 1,
                      tags: widget.category.name));
              await _updatePageId(index, pageId);
            }
          }
        },
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader(
    this.category, {
    Key? key,
    this.margin,
    this.imagePadding,
    this.borderRadius,
    this.height,
    this.chevronOpacity,
    this.imageString,
    this.onTap,
    this.icon,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? imagePadding;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final String? imageString;
  final CategoryItem category;
  final double? chevronOpacity;
  final GestureTapCallback? onTap;
  final Icon? icon;

  Widget _buildPopupMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton(
      icon: Icon(
        Icons.more_horiz,
        color: colorScheme.primaryVariant,
      ),
      elevation: 3,
      padding: EdgeInsets.zero,
      onSelected: (value) async {
        switch (value) {
          case 'delete':
            await context.read<HomeViewModel>().deleteCategory(category.id);
            break;
          case 'edit':
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CategoryInfoPage(
                      editingItem: category,
                    )));
            break;
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              height: 28,
              value: 'edit',
              child: Text(
                S.of(context).editCategory,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              )),
          PopupMenuItem(height: 1, child: Divider()),
          PopupMenuItem(
              height: 28,
              value: 'delete',
              child: Text(
                S.of(context).deleteCategory,
                style: TextStyle(fontSize: 14, color: Colors.red),
              )),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      margin: margin,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: borderRadius!),
        color: colorScheme.onBackground,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            // Makes integration tests possible.
            key: ValueKey('${category}CategoryHeader'),
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Padding(
                        padding: imagePadding!,
                        child: icon,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: Text(
                          category.name,
                          // style: Theme.of(context).textTheme.headline5.apply(
                          // 	color: colorScheme.onSurface,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                Opacity(
                  opacity: chevronOpacity!,
                  child: chevronOpacity != 0
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 8,
                            end: 32,
                          ),
                          child: Row(
                            children: [
                              _buildPopupMenu(context),
                              Icon(
                                Icons.keyboard_arrow_up,
                                color: colorScheme.primaryVariant,
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryDemoItem extends StatelessWidget {
  CategoryDemoItem({Key? key, required this.category, required this.model})
      : super(key: key);

  final ToDo? model;
  final CategoryItem category;
  int? _cachedCategoryId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return model == null
        ? Container()
        : Material(
            key: ValueKey(model!.id),
            color: Theme.of(context).colorScheme.surface,
            child: InkWell(
              onTap: () {
                _cachedCategoryId = model!.categoryId;
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) =>
                            TextEditorPage(model!.id, category)))
                    .then((result) {
                  context
                      .read<HomeViewModel>()
                      .queryToDoList(categoryId: _cachedCategoryId);
                });
              },
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 16,
                  top: 18,
                  end: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await context
                            .read<HomeViewModel>()
                            .updateTodoStatus(model!);
                        if (model?.pageId != null &&
                            context.read<ConfigViewModel>().linkedNotion) {
                          context.read<NotionWorkFlow>().updateTaskProperties(
                              model!.pageId,
                              ToDosCompanion(
                                  status: d.Value(model!.status),
                                  createdTime: d.Value(model!.createdTime),
                                  filedTime: d.Value(DateTime.now())));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 5, bottom: 5, right: 10),
                        child: Icon(
                          model!.status == 0
                              ? Icons.check_circle_outline
                              : Icons.brightness_1_outlined,
                          color: colorScheme.onSecondary,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinkWell(
                            model!.content,
                            style: TextStyle(
                                decoration: model!.status == 0
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: model!.status == 0
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                          if (model!.brief != null && model!.brief != '')
                            LinkWell(
                              model!.brief ?? '',
                              maxLines: 3,
                              linkStyle:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                              style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      colorScheme.onSurface.withOpacity(0.5)),
                            ),
                          const SizedBox(height: 10),
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
          );
  }
}

class AnimateSettingsListItems extends StatelessWidget {
  const AnimateSettingsListItems({
    Key? key,
    required this.animation,
    required this.children,
  }) : super(key: key);

  final Animation<double> animation;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final dividingPadding = 4.0;
    final topPaddingTween = Tween<double>(
      begin: 0,
      end: children.length * dividingPadding,
    );
    final dividerTween = Tween<double>(
      begin: 0,
      end: dividingPadding,
    );

    return Padding(
      padding: EdgeInsets.only(top: topPaddingTween.animate(animation).value),
      child: Column(
        children: [
          for (Widget child in children)
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: dividerTween.animate(animation).value,
                  ),
                  child: child,
                );
              },
              child: child,
            ),
        ],
      ),
    );
  }
}
