import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/12/21
/// Description:
///

class TextEditorPage extends StatefulWidget {
  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Todo'),
        iconTheme:
            IconThemeData(color: colorScheme.onSecondary),
        actions: [
          IconButton(icon: Icon(Icons.check, color: colorScheme.onSecondary,), onPressed: (){})
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
                  ),
                  Divider(
                    color: colorScheme.background,
                  ),
                  InputField(
                    hintText: '备注',
                    maxLines: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _EditorTableRow()
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hintText;
  final int maxLines;

  InputField({this.hintText, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
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

class _EditorTableRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushNamed('/list_category_page');
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
                ),
              ),
              SizedBox(width: 8,),
              Text('To Do', style: TextStyle(color: Colors.grey),),
              SizedBox(width: 8,),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey,)
            ],
          ),
        ),
      ),
    );
  }
}
