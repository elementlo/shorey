import 'dart:core';

import 'package:spark_list/generated/l10n.dart';
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
	static String mantra1 = S.current.mantra1;
	static String mantra2 = S.current.mantra2;
	static String mantra3 = S.current.mantra3;
	static String mantra4 = 'El psy kongroo.';
	
	static List<String> mantraList = [mantra1, mantra2, mantra3, mantra4];
}

///Database
class DatabaseRef{
	static const String DbName = 'spark_list_db.db';
	static const int kVersion = 1;
	static const String columnId = '_id';
	
	///table - to_do_table
	static const String tableToDo = 'to_do';
	static const String toDoContent = 'content';
	static const String toDoBrief = 'brief';
	static const String toDoCreatedTime = 'created_time';
	static const String status = 'status';
	static const String category = 'category';
	static const String alertTime = 'alert_time';
	static const String notificationId = 'notification_id';
	static const String filedTime = 'filed_time';
	static const String categoryId = 'category_id';

	///table - heat_map_table
	static const String tableHeatMap = 'heat_map';
	static const String heatPointlevel = 'level';
	static const String heatPointId = '_id';
	static const String heatPointcreatedTime = 'created_time';

	///table - action_history_table
	static const String tableActionHistory = 'action_history';
	static const String actionId = '_id';
	static const String action = 'action';
	static const String earlyContent = 'early_content';
	static const String updatedContent = 'updated_content';
	static const String updatedTime = 'updated_time';

	///table - category_list
	static const String tableCategoryList = 'category_list';
	static const String categoryName = 'category_name';
}

class NotificationId{
	static const String mainChannelId = 'todo-alert';
	static const String retrospectChannelId = 'retrospect-alert';
	static const int retrospectId = 20210601;
}
