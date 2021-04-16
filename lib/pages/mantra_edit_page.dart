import 'package:flutter/material.dart';
import 'package:spark_list/widget/app_bar.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/16/21
/// Description: 
///

class MantraEditPage extends StatefulWidget {
  @override
  _MantraEditPageState createState() => _MantraEditPageState();
}

class _MantraEditPageState extends State<MantraEditPage> {
  @override
  Widget build(BuildContext context) {
	  final colorScheme = Theme.of(context).colorScheme;
	  return Scaffold(
	    appBar: SparkAppBar(
		    context: context,
		    title: '编辑Mantra',
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
		    child: TextField(
			    decoration: InputDecoration(
				    suffixIcon: Icon(Icons.edit),
			    ),
		    ),
	    ),
    );
  }
}

