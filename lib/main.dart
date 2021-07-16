import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/pages/editor_page.dart';
import 'package:spark_list/pages/list_category_page.dart';
import 'package:spark_list/pages/mantra_edit_page.dart';
import 'package:spark_list/pages/root_page.dart';
import 'package:spark_list/pages/settings_category_page.dart';
import 'package:spark_list/resource/db_provider.dart';
import 'package:spark_list/routes.dart';
import 'package:spark_list/view_model/config_view_model.dart';
import 'package:spark_list/view_model/home_view_model.dart';

import 'config/theme_data.dart';

DbSparkProvider sparkProvider;
bool oneDayPassBy = true;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  sparkProvider = DbSparkProvider();
  await sparkProvider.ready;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AppRouterDelegate _routerDelegate = AppRouterDelegate();
  AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// todo: Navigator 2.0
    // return MaterialApp.router(
    //   routeInformationParser: _routeInformationParser,
    //   routerDelegate: _routerDelegate,
    //   themeMode: ThemeMode.system,
    //   theme: AppThemeData.lightThemeData.copyWith(
    //     platform: defaultTargetPlatform,
    //   ),
    //   darkTheme: AppThemeData.darkThemeData.copyWith(
    //     platform: defaultTargetPlatform,
    //   ),
    // );

    return ProviderWidget2<ConfigViewModel, HomeViewModel>(
      model1: ConfigViewModel(),
      model2: HomeViewModel(),
      onModelReady: (cViewModel, hViewModel){
        cViewModel.initCategoryDemosList();
      },
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: AppThemeData.lightThemeData.copyWith(
          platform: defaultTargetPlatform,
        ),
        // darkTheme: AppThemeData.darkThemeData.copyWith(
        //   platform: defaultTargetPlatform,
        // ),
        routes: {
          Routes.homePage: (context) => RootPage(),
          Routes.listCategoryPage: (context) => ListCategoryPage(),
          Routes.settingsCategoryPage: (context) => SettingsCategoryPage(),
          Routes.mantraEditPage: (context) => MantraEditPage(),
        },
      ),
    );
  }
}
