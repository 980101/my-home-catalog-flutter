import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';
import 'package:my_home_catalog_flutter/features/initial/domain/initial_navigation_handler.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({required this.navigationHandler, super.key});

  final InitialNavigationHandler navigationHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: IconButton(
                  onPressed: navigationHandler.openFavorites,
                  icon: const Icon(Icons.favorite),
                  color: AppColors.primary,
                  tooltip: '즐겨찾기',
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'My Home\n Catalog',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ElevatedButton(
                      onPressed: navigationHandler.openCustom,
                      child: const Text('맞춤 가구 둘러보기'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: navigationHandler.start,
                      child: const Text('바로 시작'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
