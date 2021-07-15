import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/model/model.dart';
import 'package:spark_list/view_model/config_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/12/21
/// Description:
///

class TextEditorPage extends StatefulWidget {
  final ToDoModel todoModel;

  TextEditorPage(this.todoModel);

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _briefController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todoModel.content ??= '';
    _briefController.text = widget.todoModel.brief ??= '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: '${widget.todoModel.category}',
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: colorScheme.onSecondary,
              ),
              onPressed: () {})
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: Column(
                children: [
                  InputField(
                    hintText: '标题',
                    textEditingController: _titleController,
                  ),
                  Divider(
                    color: colorScheme.background,
                  ),
                  InputField(
                    hintText: '备注',
                    maxLines: 8,
                    textEditingController: _briefController,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _EditorTableRow(todoModel: widget.todoModel,)
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final TextEditingController textEditingController;

  InputField({this.hintText, this.maxLines = 1, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '$hintText',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}

class _EditorTableRow extends StatefulWidget {
  const _EditorTableRow({Key key, this.todoModel}) : super(key: key);

  final ToDoModel todoModel;

  @override
  _EditorTableRowState createState() => _EditorTableRowState();
}

class _EditorTableRowState extends State<_EditorTableRow> {
  Color _color = Colors.white;

  @override
  void initState() {
    super.initState();
    _color = _mapCategoryColor();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.listCategoryPage);
        },
        child: Container(
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Text('列表')),
              Container(
                height: 10,
                width: 10,
                decoration:
                BoxDecoration(shape: BoxShape.circle, color: _color),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '${widget.todoModel.category}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Theme
                    .of(context)
                    .colorScheme
                    .onSecondary,
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _mapCategoryColor() {
    for (CategoryItem item in context
        .read<ConfigViewModel>()
        .categoryDemosList) {
      if (widget.todoModel.category == item.name){
        return item.color;
      }
    }
    return Colors.white;
  }
}
