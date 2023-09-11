import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shorey/config/config.dart';
import 'package:shorey/main.dart';
import 'package:shorey/pages/curtain_page.dart';
import 'package:shorey/resource/http_provider.dart';
import 'package:shorey/view_model/config_view_model.dart';
import 'package:shorey/view_model/home_view_model.dart';
import 'package:shorey/widget/settings_icon/icon.dart' as settings_icon;
import 'package:shorey/workflow/notion_workflow.dart';

import 'home_page.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/25/21
/// Description:

const double _settingsButtonWidth = 64;
const double _settingsButtonHeightMobile = 40;

late BuildContext appContext;

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  AnimationController? _settingsPanelController;
  AnimationController? _iconController;
  AnimationController? homePageFadeController;

  @override
  void initState() {
    super.initState();
    appContext = context;
    _requestPermissions();
    _configDio();
    EasyLoading.instance..dismissOnTap = true;
    _settingsPanelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    homePageFadeController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
  }

  @override
  void dispose() {
    _settingsPanelController?.dispose();
    _iconController?.dispose();
    homePageFadeController?.dispose();
    super.dispose();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future _configDio() async {
    dio.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      EasyLoading.dismiss();
      if (e.response != null || e.message != null) {
        Fluttertoast.showToast(
            msg: e.response?.data['message'] ?? e.message);
        handler.next(e);
      } else {
        handler.next(e);
      }
    }));
    final user = await context.read<NotionWorkFlow>().getUser();
    context.read<ConfigViewModel>().configDio(user);
  }

  void _toggleSettings(BuildContext context) {
    final cfVModel = Provider.of<ConfigViewModel>(context, listen: false);
    if (cfVModel.isSettingsOpenNotifier) {
      _settingsPanelController!.reverse();
      _iconController!.reverse();
      homePageFadeController!.reset();
      homePageFadeController!.forward();
    } else {
      context.read<HomeViewModel>().queryAllHeatPoints();
      _settingsPanelController!.forward();
      _iconController!.forward();
    }
    cfVModel.settingsOpenNotifier = !cfVModel.isSettingsOpenNotifier;
  }

  Animation<RelativeRect> _slideDownSettingsPageAnimation(
      BuildContext context) {
    return RelativeRectTween(
      begin:
          RelativeRect.fromLTRB(0, -(MediaQuery.of(context).size.height), 0, 0),
      end: const RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(
      CurvedAnimation(
        parent: _settingsPanelController!,
        curve: const Interval(
          0.0,
          0.4,
          curve: Curves.ease,
        ),
      ),
    );
  }

  Animation<RelativeRect> _slideDownHomePageAnimation(BuildContext context) {
    return RelativeRectTween(
      begin: const RelativeRect.fromLTRB(0, 0, 0, 0),
      end: RelativeRect.fromLTRB(
        0,
        MediaQuery.of(context).size.height - galleryHeaderHeight,
        0,
        -galleryHeaderHeight,
      ),
    ).animate(
      CurvedAnimation(
        parent: _settingsPanelController!,
        curve: const Interval(
          0.0,
          0.4,
          curve: Curves.ease,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildStack(context),
    );
  }

  Widget _buildStack(BuildContext context) {
    return Stack(
      children: [
        PositionedTransition(
            rect: _slideDownSettingsPageAnimation(context),
            child: CurtainPage()),
        PositionedTransition(
            rect: _slideDownHomePageAnimation(context),
            child: HomePage(
              animationController: homePageFadeController,
            )),
        _SettingsIcon(
          toggleSettings: _toggleSettings,
          animationController: _iconController!,
        )
      ],
    );
  }
}

class _SettingsIcon extends AnimatedWidget {
  _SettingsIcon({required this.animationController, this.toggleSettings})
      : super(listenable: animationController);

  final AnimationController animationController;
  final Function? toggleSettings;

  @override
  Widget build(BuildContext context) {
    final safeAreaTopPadding = MediaQuery.of(context).padding.top;
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: SizedBox(
        width: _settingsButtonWidth,
        height: _settingsButtonHeightMobile + safeAreaTopPadding,
        child: Material(
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
          ),
          color: context.watch<ConfigViewModel>().isSettingsOpenNotifier &
                  !animationController.isAnimating
              ? Colors.transparent
              : Theme.of(context).colorScheme.secondaryContainer,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              toggleSettings!(context);
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 3, end: 18),
              child: settings_icon.SettingsIcon(animationController.value),
            ),
          ),
        ),
      ),
    );
  }
}
