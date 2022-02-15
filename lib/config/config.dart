import 'dart:core';

import 'package:flutter/material.dart';
import 'package:spark_list/generated/l10n.dart';

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

  static List<String> get mantraList => updateMantra();

  static List<String> updateMantra(){
    mantra1 = S.current.mantra1;
    mantra2 = S.current.mantra2;
    mantra3 = S.current.mantra3;
    mantra4 = 'El psy kongroo.';
    return [mantra1, mantra2, mantra3, mantra4];
  }

}

class SColor {
  static const int red = 1;
  static const int blue = 2;
  static const int yellow = 3;
  static const int orangeAccent = 4;
  static const int greenAccent = 5;
  static const int black = 6;
  static const int blueAccent = 7;
  static const int purple = 8;
  static const int pink = 9;
  static const int brown = 10;
  static const int grey = 11;
  static const int brownAccent = 12;

  static const Map<int, int> colorMap = {
    red: 0xFFF44336,
    blue: 0xFF2196F3,
    yellow: 0xFFFFEB3B,
    orangeAccent: 0xFFFFAB40,
    greenAccent: 0xFF69F0AE,
    black: 0xFF000000,
    blueAccent: 0xFF40C4FF,
    purple: 0xFF9C27B0,
    pink: 0xFFE91E63,
    brown: 0xFF795548,
    grey: 0xFF757575,
    brownAccent: 0xFFBCAAA4
  };
// categoryDemosList = List.of([
//   CategoryItem(
//       name: 'To Do',
//       icon: Icon(
//         Icons.article_outlined,
//         color: Colors.blue,
//       ),
//       color: Colors.blue),
//   CategoryItem(
//       name: 'To Watch',
//       icon: Icon(
//         Icons.movie_outlined,
//         color: Colors.yellow,
//       ),
//       color: Colors.yellow),
//   CategoryItem(
//       name: 'To Read',
//       icon: Icon(
//         Icons.menu_book_outlined,
//         color: Colors.red,
//       ),
//       color: Colors.red),
//   CategoryItem(
//       name: 'Alert',
//       icon: Icon(
//         Icons.add_alert,
//         color: Colors.orangeAccent,
//       ),
//       color: Colors.orangeAccent),
//   CategoryItem(
//       name: 'Work',
//       icon: Icon(
//         Icons.work_outline,
//         color: Colors.greenAccent,
//       ),
//       color: Colors.greenAccent),
//   CategoryItem(
//       name: 'To Learn',
//       icon: Icon(
//         Icons.school_outlined,
//         color: Colors.black,
//       ),
//       color: Colors.black),
// ]);
}

class SIcons {
  static const int article_outlined = 1;
  static const int menu_book_outlined = 2;
  static const int add_alert = 3;
  static const int work_outline = 4;
  static const int school_outlined = 5;
  static const int movie_outlined = 6;
  static const int comment = 7;
  static const int wb_incandescent = 8;
  static const int image = 9;
  static const int accessibility_new_rounded = 10;
  static const int add_shopping_cart_sharp = 11;
  static const int sports_baseball = 12;
  static const int sports_basketball_rounded = 13;
  static const int sports_motorsports_rounded = 14;
  static const int emoji_food_beverage_rounded = 15;
  static const int fastfood_rounded = 16;
  static const int card_giftcard_rounded = 17;
  static const int cake_rounded = 18;
  static const int medical_services_rounded = 19;
  static const int filter_drama_sharp = 20;
  static const int directions_run_rounded = 21;
  static const int account_balance_wallet_rounded = 22;
  static const int access_alarms_outlined = 23;
  static const int watch = 24;
  static const int adb_rounded = 25;
  static const int ac_unit_rounded = 26;
  static const int car_rental_rounded = 27;
  static const int star = 28;
  static const int local_fire_department_outlined = 29;
  static const int work_outline_rounded = 30;
  static const int umbrella_outlined = 31;
  static const int houseboat_rounded = 32;
  static const int gamepad_rounded = 33;
  static const int videogame_asset = 34;
  static const int circle = 35;
  static const int shopping_cart_rounded = 36;
  static const int train_rounded = 37;
  static const int headset_rounded = 38;
  static const int music_note_rounded = 39;
  static const int queue_music_rounded = 40;
  static const int toys_rounded = 41;
  static const int smart_toy_rounded = 42;

  static const Map<int, IconData> iconMap = {
    article_outlined: Icons.article_outlined,
    movie_outlined: Icons.movie_outlined,
    menu_book_outlined: Icons.menu_book_outlined,
    add_alert: Icons.add_alert,
    work_outline: Icons.work_outline,
    school_outlined: Icons.school_outlined,
    comment:  Icons.comment,
    wb_incandescent: Icons.wb_incandescent,
    image: Icons.image,
    accessibility_new_rounded: Icons.accessibility_new_rounded,
    add_shopping_cart_sharp: Icons.add_shopping_cart_sharp,
    sports_baseball: Icons.sports_baseball,
    sports_basketball_rounded: Icons.sports_basketball_rounded,
    sports_motorsports_rounded: Icons.sports_motorsports_rounded,
    emoji_food_beverage_rounded: Icons.emoji_food_beverage_rounded,
    fastfood_rounded: Icons.fastfood_rounded,
    card_giftcard_rounded: Icons.card_giftcard_rounded,
    cake_rounded: Icons.cake_rounded,
    medical_services_rounded: Icons.medical_services_rounded,
    filter_drama_sharp: Icons.filter_drama_sharp,
    directions_run_rounded: Icons.directions_run_rounded,
    account_balance_wallet_rounded: Icons.account_balance_wallet_rounded,
    access_alarms_outlined: Icons.access_alarms_outlined,
    watch: Icons.watch,
    adb_rounded: Icons.adb_rounded,
    ac_unit_rounded: Icons.ac_unit_rounded,
    car_rental_rounded: Icons.car_rental_rounded,
    star: Icons.star,
    local_fire_department_outlined: Icons.local_fire_department_outlined,
    work_outline_rounded: Icons.work_outline_rounded,
    umbrella_outlined: Icons.umbrella_outlined,
    houseboat_rounded: Icons.houseboat_rounded,
    gamepad_rounded: Icons.gamepad_rounded,
    videogame_asset: Icons.videogame_asset,
    circle: Icons.circle,
    shopping_cart_rounded: Icons.shopping_cart_rounded,
    train_rounded: Icons.train_rounded,
    headset_rounded: Icons.headset_rounded,
    music_note_rounded: Icons.music_note_rounded,
    queue_music_rounded: Icons.queue_music_rounded,
    toys_rounded: Icons.toys_rounded,
    smart_toy_rounded: Icons.smart_toy_rounded,
  };
}

///Database
// class DatabaseRef{
// 	static const String DbName = 'spark_list_db.db';
// 	static const int kVersion = 1;
// 	static const String columnId = '_id';
//
// 	///table - to_do_table
// 	static const String tableToDo = 'to_do';
// 	static const String toDoContent = 'content';
// 	static const String toDoBrief = 'brief';
// 	static const String toDoCreatedTime = 'created_time';
// 	static const String status = 'status';
// 	static const String category = 'category';
// 	static const String alertTime = 'alert_time';
// 	static const String notificationId = 'notification_id';
// 	static const String filedTime = 'filed_time';
// 	static const String categoryId = 'category_id';
//
// 	///table - heat_map_table
// 	static const String tableHeatMap = 'heat_map';
// 	static const String heatPointlevel = 'level';
// 	static const String heatPointId = '_id';
// 	static const String heatPointcreatedTime = 'created_time';
//
// 	///table - action_history_table
// 	static const String tableActionHistory = 'action_history';
// 	static const String actionId = '_id';
// 	static const String action = 'action';
// 	static const String earlyContent = 'early_content';
// 	static const String updatedContent = 'updated_content';
// 	static const String updatedTime = 'updated_time';
//
// 	///table - category_list
// 	static const String tableCategoryList = 'category_list';
// 	static const String categoryName = 'category_name';
// }

class NotificationId {
  static const String mainChannelId = 'todo-alert';
  static const String retrospectChannelId = 'retrospect-alert';
  static const int retrospectId = 20210601;
}
