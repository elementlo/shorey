import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/routes.dart';

import 'config/theme_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AppRouterDelegate _routerDelegate = AppRouterDelegate();
  AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _routeInformationParser,
      routerDelegate: _routerDelegate,
      themeMode: ThemeMode.system,
      theme: AppThemeData.lightThemeData.copyWith(
        platform: defaultTargetPlatform,
      ),
      darkTheme: AppThemeData.darkThemeData.copyWith(
        platform: defaultTargetPlatform,
      ),
    );
  }
}
