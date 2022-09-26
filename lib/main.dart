import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amap_flutter_location/amap_location_option.dart';
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
import 'package:permission_handler/permission_handler.dart';

import 'config/theme_data.dart';
import 'generated/l10n.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';

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

  requestPermission();

  //Replace your key below
  AMapFlutterLocation.setApiKey("", "0");

  if (Platform.isIOS) {
    _requestAccuracyAuthorization();
  }
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
  StreamSubscription<Map<String, Object>>? _locationListener;

  @override
  void initState(){
    super.initState();
    _locationListener = _locationPlugin.onLocationChanged().listen((Map<String, Object> result) {
      setState(() {
        print(result);
      });
    });
    _startLocation();
  }

  void _startLocation() {
    ///开始定位之前设置定位参数
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  void _setLocationOption() {
    AMapLocationOption locationOption = new AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = true;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode = AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
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
          return context.read<ConfigViewModel>().initLocale(locale, supportedLocales);
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

void requestPermission() async {
  bool hasLocationPermission = await requestLocationPermission();
  if (hasLocationPermission) {
    print("Location permission granted!");
  } else {
    print("Location permission not granted!");
  }
}

Future<bool> requestLocationPermission() async {
  var status = await Permission.location.status;
  if (status == PermissionStatus.granted) {
    return true;
  } else {
    status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();


void _requestAccuracyAuthorization() async {
  AMapAccuracyAuthorization currentAccuracyAuthorization = await _locationPlugin.getSystemAccuracyAuthorization();
  if (currentAccuracyAuthorization == AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
    print("FullAccuracy");
  } else if (currentAccuracyAuthorization == AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
    print("ReducedAccuracy");
  } else {
    print("UnKnown");
  }
}
