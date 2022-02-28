import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/database/database.dart';
import 'package:spark_list/pages/list_category_page.dart';
import 'package:spark_list/pages/mantra_edit_page.dart';
import 'package:spark_list/pages/root_page.dart';
import 'package:spark_list/pages/settings_page.dart';
import 'package:spark_list/resource/data_provider.dart';
import 'package:spark_list/resource/http_provider.dart';
import 'package:spark_list/routes.dart';
import 'package:spark_list/view_model/config_view_model.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/workflow/notion_workflow.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'config/theme_data.dart';
import 'generated/l10n.dart';

late DataStoreProvider dsProvider;
late DatabaseProvider dbProvider;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureLocalTimeZone();
  await _initNotificationsSettings();
  dsProvider = DataStoreProvider();
  await dsProvider.ready;
  await dsProvider.getLocale();
  dbProvider = DatabaseProvider();
  _configHttpClient();
  runApp(ProviderWidget2<ConfigViewModel, HomeViewModel>(
      ConfigViewModel(), HomeViewModel(),
      onModelReady: (cViewModel, hViewModel) async {
    await cViewModel?.initCategoryDemosList();
    await cViewModel?.getCategoryList();
    hViewModel?.initDefaultSettings();
  },
      child: ChangeNotifierProvider(
          create: (context) => NotionWorkFlow(), child: MyApp())));
  _configLoading();
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

void _configHttpClient() {
  dio.interceptors
      .add(LogInterceptor(responseBody: true, responseHeader: false));
  dio.options.baseUrl = 'https://api.notion.com/';
  dio.options.headers.addAll({'Notion-Version': '2021-05-13'});
  dio.options.connectTimeout = 5000;
  dio.options.receiveTimeout = 7000;
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
}

void _configLoading() {
  EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.threeBounce;
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

    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: AppThemeData.lightThemeData.copyWith(
        platform: defaultTargetPlatform,
      ),
      builder: EasyLoading.init(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        print(locale);
        return context.read<ConfigViewModel>().initLocale(locale, supportedLocales);
      },
      // darkTheme: AppThemeData.darkThemeData.copyWith(
      //   platform: defaultTargetPlatform,
      // ),
      routes: {
        Routes.homePage: (context) => RootPage(),
        Routes.listCategoryPage: (context) => ListCategoryPage(),
        Routes.settingsCategoryPage: (context) => SettingsCategoryPage(),
        Routes.mantraEditPage: (context) => MantraEditPage(),
      },
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

Future<void> _initNotificationsSettings() async {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
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
