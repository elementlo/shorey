import 'package:drift/drift.dart' as d;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';
import 'package:provider/provider.dart';
import 'package:shorey/database/database.dart';
import 'package:shorey/generated/l10n.dart';
import 'package:shorey/model/model.dart';
import 'package:shorey/pages/add_new_item_page.dart';
import 'package:shorey/pages/category_info_page.dart';
import 'package:shorey/pages/editor_page.dart';
import 'package:shorey/pages/root_page.dart';
import 'package:shorey/view_model/home_view_model.dart';
import 'package:shorey/workflow/notion_workflow.dart';

import '../pages/sync_workflow_page.dart';
import '../view_model/config_view_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/8/21
/// Description:
///

typedef CategoryHeaderTapCallback = Function(bool shouldOpenList);

final List<int> _cachedItems = [];

class CategoryListItem extends StatefulWidget {
  const CategoryListItem(this.category,
      {Key? key,
      this.restorationId,
      this.imageString,
      this.demos = const [''],
      this.initiallyExpanded = false,
      this.isExpanded = false,
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
  final bool isExpanded;
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

  void _handleExpansion() {
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse().then<void>((value) {
        if (!mounted) {
          return;
        }
      });
    }
  }

  void _handleTap() {
    if (_shouldOpenList()!) {
      _cachedItems.clear();
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
    _handleExpansion();
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
        ..._buildDemoItems(widget.demoList),
        _buildNewTaskField(context),
        const SizedBox(height: 12), // Extra space below.
      ],
    );
  }

  List<Widget> _buildDemoItems(List<ToDo?>? demoList) {
    List<Widget> demoList = [];
    if (widget.demoList != null && widget.demoList!.length > 0) {
      for (int i = 0; i < widget.demoList!.length; i++) {
        if (widget.demoList![i]!.status == 1 || _cachedItems.contains(i))
          demoList.add(CategoryDemoItem(
            index: i,
            model: widget.demoList![i],
            category: widget.category,
          ));
      }
    }
    return demoList;
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
                    });
                  },
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.onSecondary,
                  )),
            )),
        onSubmitted: (input) async {
          if (input != '' && input != null) {
            final dateTime = DateTime.now();
            final index = await viewModel.saveToDo(ToDosCompanion(
                categoryId: d.Value(widget.category.id),
                status: d.Value(1),
                content: d.Value(input),
                createdTime: d.Value(dateTime)));
            _controller.clear();
            if (widget.category.notionDatabaseId != null &&
                context.read<ConfigViewModel>().linkedNotion &&
                widget.category.autoSync) {
              final pageId = await context.read<NotionWorkFlow>().addTaskItem(
                  widget.category.notionDatabaseId!,
                  ToDo(
                      id: index,
                      content: input,
                      createdTime: dateTime,
                      categoryId: widget.category.id,
                      status: 1,
                      tags: widget.category.name),
                  actionType: widget.category.notionDatabaseType);

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
        color: colorScheme.primaryContainer,
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
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
              height: 28,
              value: 'edit',
              child: Text(
                S.of(context).editCategory,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              )),
          PopupMenuDivider(),
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
                                color: colorScheme.primaryContainer,
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

class CategoryDemoItem extends StatefulWidget {
  CategoryDemoItem(
      {Key? key,
      required this.category,
      required this.model,
      required this.index})
      : super(key: key);

  final ToDo? model;
  final CategoryItem category;
  final int index;

  @override
  State<CategoryDemoItem> createState() => _CategoryDemoItemState();
}

class _CategoryDemoItemState extends State<CategoryDemoItem> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return widget.model == null
        ? Container()
        : Material(
            key: ValueKey(widget.model!.id),
            color: Theme.of(context).colorScheme.surface,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TextEditorPage(widget.model!.id, widget.category)));
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
                    if (widget.category.notionDatabaseType != 2)
                      GestureDetector(
                        onTap: () async {
                          if (widget.model!.status == 1) {
                            _cachedItems.add(widget.index);
                          } else {
                            _cachedItems.remove(widget.index);
                          }
                          await context
                              .read<HomeViewModel>()
                              .updateTodoStatus(widget.model!);
                          setState(() {});
                          if (widget.model?.pageId != null &&
                              context.read<ConfigViewModel>().linkedNotion) {
                            context.read<NotionWorkFlow>().updateTaskProperties(
                                widget.model!.pageId,
                                ToDosCompanion(
                                    status: d.Value(widget.model!.status),
                                    createdTime:
                                        d.Value(widget.model!.createdTime),
                                    filedTime: d.Value(DateTime.now())),
                                actionType: widget.category.notionDatabaseType);
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 5, bottom: 5, right: 10),
                          child: Icon(
                            widget.model!.status == 0
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
                            widget.model!.content,
                            style: TextStyle(
                                decoration: widget.model!.status == 0
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: widget.model!.status == 0
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                          if (widget.model!.brief != null &&
                              widget.model!.brief != '')
                            LinkWell(
                              widget.model!.brief ?? '',
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
