import 'dart:core';

import 'package:sqflite/sqflite.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/26/21
/// Description: 
///

const double galleryHeaderHeight = 64;

///pages
class Routes {
	static const String homePage = '/';
	static const String textEditorPage = '/text_editor_page';
	static const String listCategoryPage = '/list_category_page';
	static const String settingsCategoryPage = '/settings_category_page';
	static const String mantraEditPage = '/mantra_edit_page';
}


///mantra
class Mantra {
	static const String mantra1 = '我们称之为路的, 只不过是彷徨.';
	static const String mantra2 = '心脏是一座有两间卧室的房子, 一间住着痛苦, 另一间住着欢乐, 人不能笑得太响. 否则笑声会吵醒隔壁房间的痛苦.';
	static const String mantra3 = '我是自由的, 那就是我迷失的原因.';
	static const String mantra4 = 'El psy kongroo.';
	
	static const List<String> mantraList = [mantra1, mantra2, mantra3, mantra4];
}

///Database
class DatabaseRef{
	static const String DbName = 'spark_list_db.db';
	static const int kVersion = 1;
	static const String columnId = '_id';
	
	///table - to_do_table
	static const String tableToDo = 'to_do';
	static const String toDoContent = 'content';
	static const String toDoCreatedTime = 'created_time';
	static const String status = 'status';
	
	///table - heat_map_table
	static const String tableHeatMap = 'heat_map';
	static const String heatPointlevel = 'level';
	static const String heatPointId = '_id';
	static const String heatPointcreatedTime = 'created_time';
}
