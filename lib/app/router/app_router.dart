import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_routes.dart';
import 'package:my_home_catalog_flutter/features/initial/domain/initial_navigation_handler.dart';
import 'package:my_home_catalog_flutter/features/initial/presentation/initial_screen.dart';

export 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.initial: (context) => InitialScreen(
        navigationHandler: InitialNavigationHandler(
          navigator: Navigator.of(context),
        ),
      ),
      AppRoutes.home: (_) => const _RouteStubScreen(title: 'MainActivity'),
      AppRoutes.custom: (_) => const _RouteStubScreen(title: 'CustomActivity'),
      AppRoutes.favorites: (_) =>
          const _RouteStubScreen(title: 'FavoritesActivity'),
    };
  }
}

class _RouteStubScreen extends StatelessWidget {
  const _RouteStubScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const SizedBox.expand(),
    );
  }
}
