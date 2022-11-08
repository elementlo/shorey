import 'dart:async';
import 'dart:convert';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:shorey/base/provider_widget.dart';
import 'package:shorey/config/config.dart';
import 'package:shorey/database/database.dart';
import 'package:shorey/pages/mantra_edit_page.dart';
import 'package:shorey/pages/root_page.dart';
import 'package:shorey/pages/settings_page.dart';
import 'package:shorey/resource/data_provider.dart';
import 'package:shorey/resource/http_provider.dart';
import 'package:shorey/view_model/config_view_model.dart';
import 'package:shorey/view_model/home_view_model.dart';
import 'package:shorey/workflow/notion_workflow.dart';
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

  AMapFlutterLocation.updatePrivacyShow(true, true);
  AMapFlutterLocation.updatePrivacyAgree(true);

  //Replace your key below
  AMapFlutterLocation.setApiKey("", "0");

  runApp(ProviderWidget2<ConfigViewModel, HomeViewModel>(
      ConfigViewModel(), HomeViewModel(),
      onModelReady: (cViewModel, hViewModel) async {
    await cViewModel?.initCategoryDemosList();
    cViewModel?.getCategoryList();
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
  dio.options.headers.addAll({'Notion-Version': notionApiVersion});
  dio.options.connectTimeout = 5000;
  dio.options.receiveTimeout = 7000;
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
}

void _configLoading() {
  EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.threeBounce;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }


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

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
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
          return context
              .read<ConfigViewModel>()
              .initLocale(locale, supportedLocales);
        },
        // darkTheme: AppThemeData.darkThemeData.copyWith(
        //   platform: defaultTargetPlatform,
        // ),
        routes: {
          Routes.homePage: (context) => RootPage(),
          Routes.settingsCategoryPage: (context) => SettingsCategoryPage(),
          Routes.mantraEditPage: (context) => MantraEditPage(),
        },
      ),
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

Future<void> _initNotificationsSettings() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
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
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
}