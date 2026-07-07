import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_routes.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';
import 'package:my_home_catalog_flutter/features/favorites/data/favorites_repository.dart';
import 'package:my_home_catalog_flutter/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:my_home_catalog_flutter/features/favorites/presentation/widgets/favorite_item_card.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({required this.repository, super.key});

  final FavoritesRepository repository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesController(repository: repository)..loadItems(),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FavoritesController>();
    final items = controller.items;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = controller.message;
      if (message == null || !context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      context.read<FavoritesController>().clearMessage();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        actions: [
          IconButton(
            onPressed: context.read<FavoritesController>().deleteSelected,
            icon: const Icon(Icons.delete, color: AppColors.error),
            tooltip: '삭제',
          ),
        ],
      ),
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.errorMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    controller.errorMessage!,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : items.isEmpty
            ? const _EmptyFavorites()
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return FavoriteItemCard(
                    item: item,
                    selected: controller.selectedIndex == index,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.detail, arguments: item);
                    },
                    onSelect: () {
                      context.read<FavoritesController>().selectItem(index);
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('즐겨찾기한 항목이 없습니다 !', style: AppTextStyles.bodyLarge),
    );
  }
}
