import 'package:flutter/cupertino.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/19/21
/// Description: 
///
class ToDoModel{
	int createdTime;
	String content;
	int status;
	
	ToDoModel({this.content, @required this.createdTime, this.status});
}


class HeatMapModel{
	int createdTime;
	int level;
	
	HeatMapModel({this.level, @required this.createdTime});
}