import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_router.dart';
import 'package:my_home_catalog_flutter/app/theme/app_theme.dart';

class MyHomeCatalogApp extends StatelessWidget {
  const MyHomeCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Home Catalog',
      theme: AppTheme.light,
      initialRoute: AppRoutes.initial,
      routes: AppRouter.routes,
    );
  }
}
