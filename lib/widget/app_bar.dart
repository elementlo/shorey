import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/14/21
/// Description: 
///

class SparkAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onPressedAction;

  SparkAppBar({this.title, this.onPressedAction});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Todo'),
      iconTheme:
      IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
      actions: [
        IconButton(icon: Icon(Icons.check, color: Theme.of(context).colorScheme.onSecondary,), onPressed: onPressedAction)
      ],
    );
  }
}
