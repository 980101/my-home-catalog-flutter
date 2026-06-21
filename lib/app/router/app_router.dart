import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_routes.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/custom/presentation/custom_screen.dart';
import 'package:my_home_catalog_flutter/features/initial/domain/initial_navigation_handler.dart';
import 'package:my_home_catalog_flutter/features/initial/presentation/initial_screen.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/home_screen.dart';

export 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => _buildPage(context, settings),
    );
  }

  static Widget _buildPage(BuildContext context, RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.initial => InitialScreen(
        navigationHandler: InitialNavigationHandler(
          navigator: Navigator.of(context),
        ),
      ),
      AppRoutes.home => HomeScreen.fromRoute(settings),
      AppRoutes.custom => const CustomScreen(),
      AppRoutes.camera => _RouteStubScreen(
        title: 'CameraPage',
        description: _cameraDescription(settings.arguments),
      ),
      AppRoutes.detail => _RouteStubScreen(
        title: 'DetailPage',
        description: _detailDescription(settings.arguments),
      ),
      AppRoutes.favorites => const _RouteStubScreen(
        title: 'FavoritesPage',
        description: 'TODO: FavoritesActivity migration pending.',
      ),
      _ => const _RouteStubScreen(
        title: 'Unknown route',
        description: 'TODO: Route is not defined.',
      ),
    };
  }

  static String _cameraDescription(Object? arguments) {
    final type = arguments is Map ? arguments['type'] : null;
    return 'TODO: CameraActivity migration pending. type=${type ?? 'none'}';
  }

  static String _detailDescription(Object? arguments) {
    final item = arguments is ItemModel ? arguments : null;
    if (item == null) {
      return 'TODO: DetailActivity migration pending.';
    }

    return 'TODO: DetailActivity migration pending. '
        'image=${item.image}, name=${item.name}, price=${item.price}, '
        'link=${item.link}';
  }
}

class _RouteStubScreen extends StatelessWidget {
  const _RouteStubScreen({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(description, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
