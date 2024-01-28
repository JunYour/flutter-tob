import 'package:flutter/widgets.dart';

// bool isInLoginPage = false;

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) {
    print("didPush->route.settings.name=${route.settings.name}");
    // if (route.settings.name != null && route.settings.name.startsWith(Routes.loginPhone)) {
    //   isInLoginPage = true;
    // }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    // print("didPop->route.settings.name=${route.settings.name}");
    // if (route.settings.name != null && route.settings.name.startsWith(Routes.loginPhone)) {
    //   isInLoginPage = false;
    // }
    super.didPop(route, previousRoute);
  }
}
