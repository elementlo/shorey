import 'package:flutter/cupertino.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/19/21
/// Description: 
///
class MainFocusModel{
	final int createdTime;
	final String content;
	
	MainFocusModel({this.content, @required this.createdTime});
}


class HeatMapModel{
	final int createdTime;
	final int level;
	
	HeatMapModel({this.level, @required this.createdTime});
}