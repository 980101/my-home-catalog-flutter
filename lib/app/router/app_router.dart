import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_routes.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/features/camera/data/style_history_repository.dart';
import 'package:my_home_catalog_flutter/features/camera/data/tflite_style_classifier.dart';
import 'package:my_home_catalog_flutter/features/camera/presentation/camera_screen.dart';
import 'package:my_home_catalog_flutter/features/custom/presentation/custom_screen.dart';
import 'package:my_home_catalog_flutter/features/detail/presentation/detail_screen.dart';
import 'package:my_home_catalog_flutter/features/favorites/data/favorites_repository.dart';
import 'package:my_home_catalog_flutter/features/favorites/presentation/favorites_screen.dart';
import 'package:my_home_catalog_flutter/features/initial/domain/initial_navigation_handler.dart';
import 'package:my_home_catalog_flutter/features/initial/presentation/initial_screen.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/home_screen.dart';

export 'app_routes.dart';

class AppRouter {
  const AppRouter({
    required RecommendationRepository recommendationRepository,
    required FavoritesRepository favoritesRepository,
    Widget Function(RouteSettings settings)? cameraBuilder,
  }) : _recommendationRepository = recommendationRepository,
       _favoritesRepository = favoritesRepository,
       _cameraBuilder = cameraBuilder;

  final RecommendationRepository _recommendationRepository;
  final FavoritesRepository _favoritesRepository;
  final Widget Function(RouteSettings settings)? _cameraBuilder;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => _buildPage(context, settings),
    );
  }

  Widget _buildPage(BuildContext context, RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.initial => InitialScreen(
        navigationHandler: InitialNavigationHandler(
          navigator: Navigator.of(context),
        ),
      ),
      AppRoutes.home => HomeScreen.fromRoute(
        settings,
        repository: _recommendationRepository,
      ),
      AppRoutes.custom => const CustomScreen(),
      AppRoutes.camera =>
        _cameraBuilder?.call(settings) ??
            CameraScreen.fromRoute(
              settings,
              historyRepository: const StyleHistoryRepository(),
              classifier: TfliteStyleClassifier(),
            ),
      AppRoutes.detail => DetailScreen.fromRoute(
        settings,
        favoritesRepository: _favoritesRepository,
      ),
      AppRoutes.favorites => FavoritesScreen(repository: _favoritesRepository),
      _ => const _RouteStubScreen(
        title: 'Unknown route',
        description: 'TODO: Route is not defined.',
      ),
    };
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
