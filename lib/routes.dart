import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/pages/home_page.dart';
import 'package:spark_list/pages/root_page.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/23/21
/// Description:
///
class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  bool show404 = false;

  static List<MaterialPage> pages = [MaterialPage(child: RootPage())];

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppRoutePath get currentConfiguration {
    print("currentConfiguration");
    if (show404) {
      return AppRoutePath.unknown();
    }else{
      return AppRoutePath.home();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {},
    );
  }

  ///监听新页面的到来
  @override
  Future<void> setNewRoutePath(configuration) async{
    print("setNewRoutePath");
    if(configuration.unknownPage){
      show404 = true;
      return;
    }
    
    if(configuration.isHomePage){
      show404 = false;
      return;
    }
  }
}

class AppRoutePath {
  final int id;
  final bool unknownPage;

  AppRoutePath.home()
      : id = null,
        unknownPage = false;

  AppRoutePath.details(this.id) : unknownPage = false;

  AppRoutePath.unknown()
      : id = null,
        unknownPage = true;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print("parseRouteInformation");
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.length == 0) {
      return AppRoutePath.home();
    }

    // if (uri.pathSegments.length == 2) {
    //   if (uri.pathSegments[0] != 'veggie') return AppRoutePath.unknown();
    //   var remaining = uri.pathSegments[1];
    //   var id = int.tryParse(remaining);
    //   if (id == null) return AppRoutePath.unknown();
    //   return AppRoutePath.details(id);
    // }

    return AppRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    print("restoreRouteInformation");
    if (configuration.unknownPage) {
      return RouteInformation(location: '/404');
    }
    if (configuration.isHomePage) {
      return RouteInformation(location: '/');
    }
    // if (configuration.isDetailsPage) {
    //   return RouteInformation(location: '/veggie/${path.id}');
    // }
    return null;
  }
}
