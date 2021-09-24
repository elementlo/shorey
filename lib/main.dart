import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

late DbSparkProvider sparkProvider;
bool oneDayPassBy = true;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _configureLocalTimeZone();
  await _initNotificationsSettings();
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

    return ProviderWidget2<ConfigViewModel, HomeViewModel>(ConfigViewModel(),
      HomeViewModel(),
      onModelReady: (cViewModel, hViewModel){
        cViewModel?.initCategoryDemosList();
        _initAlertPeriod(hViewModel);
        //hViewModel?.assembleRetrospectNotification();
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

void _initAlertPeriod(HomeViewModel? viewModel) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.get('alert_period') == null) {
    prefs.setInt('alert_period', 0);
    viewModel?.assembleRetrospectNotification(TimeOfDay(hour: 18, minute: 0), 0);
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

Future<void> _initNotificationsSettings() async{
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
          ) async {
          print('received notification: $id $title $body $payload');
      });
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      });
}