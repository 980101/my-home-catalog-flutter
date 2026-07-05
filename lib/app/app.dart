import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_router.dart';
import 'package:my_home_catalog_flutter/app/theme/app_theme.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';

class MyHomeCatalogApp extends StatelessWidget {
  const MyHomeCatalogApp({required this.recommendationRepository, super.key});

  final RecommendationRepository recommendationRepository;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(
      recommendationRepository: recommendationRepository,
    );

    return MaterialApp(
      title: 'My Home Catalog',
      theme: AppTheme.light,
      initialRoute: AppRoutes.initial,
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}
