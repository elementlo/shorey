import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('列表'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
      ),
      body: Container(
        child: ListView(
          children: [
            for (int i = 0; i <= 5; i++) _CategoryItem(),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
      
      },
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.assignment_outlined,
              size: 30,
              color: Colors.blue,
            ),
            trailing: Icon(
              Icons.check,
              size: 30,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            title: Text('ToDo'),
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
