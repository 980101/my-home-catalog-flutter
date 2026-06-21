import 'package:flutter/widgets.dart';
import 'package:my_home_catalog_flutter/app/router/app_routes.dart';

class InitialNavigationHandler {
  InitialNavigationHandler({required NavigatorState navigator})
    : _navigator = navigator;

  final NavigatorState _navigator;

  void openFavorites() {
    _navigator.pushNamed(AppRoutes.favorites);
  }

  void start() {
    _navigator.pushNamed(AppRoutes.home);
  }

  void openCustom() {
    _navigator.pushNamed(AppRoutes.custom);
  }
}
