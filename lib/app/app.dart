import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_router.dart';
import 'package:my_home_catalog_flutter/app/theme/app_theme.dart';
import 'package:my_home_catalog_flutter/features/favorites/data/favorites_repository.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';

class MyHomeCatalogApp extends StatelessWidget {
  const MyHomeCatalogApp({
    required this.recommendationRepository,
    this.favoritesRepository = const FavoritesRepository(),
    super.key,
  });

  final RecommendationRepository recommendationRepository;
  final FavoritesRepository favoritesRepository;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(
      recommendationRepository: recommendationRepository,
      favoritesRepository: favoritesRepository,
    );

    return MaterialApp(
      title: 'My Home Catalog',
      theme: AppTheme.light,
      initialRoute: AppRoutes.initial,
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}
