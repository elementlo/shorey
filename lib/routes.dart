import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/pages/root_page.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/23/21
/// Description:
///
class AppRouterDelegate extends RouterDelegate<AppRoutePath?>
    with ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;
  bool show404 = false;
  String currentPage = '';

  static List<MaterialPage> pages = [
    MaterialPage(key: ValueKey('RootPage'), child: RootPage()),
  ];

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppRoutePath get currentConfiguration {
    print("currentConfiguration");
    if (show404) {
      return AppRoutePath.unknown();
    } else {
      switch (currentPage) {
        case AppRoutePath.textEditorPage:
          return AppRoutePath.editorPage('title');
        default:
          return AppRoutePath.home();
      }
    }
  }

  static AppRouterDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is AppRouterDelegate, 'Delegate type must match');
    return delegate as AppRouterDelegate;
  }

  void push(MaterialPage newPage) {
    pages.add(newPage);
    notifyListeners();
  }

  // bool _onPopPage(Route<dynamic> route, dynamic result) {
  //   if (pages.isNotEmpty) {
  //     if (pages.last.name == route.settings.name) {
  //       pages.remove(route.settings);
  //       notifyListeners();
  //     }
  //   }
  //   return route.didPop(result);
  // }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      //key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {} as bool Function(Route<dynamic>, dynamic)?,
    );
  }

  ///监听新页面的到来
  @override
  Future<void> setNewRoutePath(configuration) async {
    print("setNewRoutePath");
    if (configuration?.unknownPage ?? false) {
      show404 = true;
      return;
    }

    if (configuration?.currentPage == AppRoutePath.textEditorPage) {
      currentPage = AppRoutePath.textEditorPage;
      //pages.add(MaterialPage(key: ValueKey('TextEditorPage'), child: TextEditorPage()));
    }
  }

  @override
  Future<bool> popRoute() {
    return Future.value(true);
  }
}

class AppRoutePath {
  static const String textEditorPage = 'text-editor';
  int? id;
  bool unknownPage = false;
  String? title;
  String currentPage = '';

  AppRoutePath.home()
      : id = null,
        unknownPage = false,
        currentPage = '';

  AppRoutePath.details(this.id) : unknownPage = false;

  AppRoutePath.editorPage(this.title)
      : unknownPage = false,
        currentPage = textEditorPage;

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
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.length == 0) {
      return AppRoutePath.home();
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == AppRoutePath.textEditorPage)
        return AppRoutePath.editorPage(uri.pathSegments[1]);
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
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    print("restoreRouteInformation");
    if (configuration.unknownPage) {
      return RouteInformation(location: '/404');
    }
    if (configuration.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (configuration.currentPage == AppRoutePath.textEditorPage) {
      return RouteInformation(
          location: '/${AppRoutePath.textEditorPage}/${configuration.title}');
    }
    // if (configuration.isDetailsPage) {
    //   return RouteInformation(location: '/veggie/${path.id}');
    // }
    return null;
  }
}
