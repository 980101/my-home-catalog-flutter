import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/detail/data/external_link_launcher.dart';
import 'package:my_home_catalog_flutter/features/detail/presentation/controllers/detail_controller.dart';
import 'package:my_home_catalog_flutter/features/detail/presentation/widgets/detail_info_row.dart';
import 'package:my_home_catalog_flutter/features/favorites/data/favorites_repository.dart';
import 'package:my_home_catalog_flutter/shared/widgets/item_network_image.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    required this.item,
    required this.favoritesRepository,
    super.key,
  });

  factory DetailScreen.fromRoute(
    RouteSettings settings, {
    required FavoritesRepository favoritesRepository,
  }) {
    final arguments = settings.arguments;
    final item = arguments is ItemModel ? arguments : _fallbackItem;
    return DetailScreen(item: item, favoritesRepository: favoritesRepository);
  }

  final ItemModel item;
  final FavoritesRepository favoritesRepository;

  static const _fallbackItem = ItemModel(
    image: 'dummy://unknown',
    name: 'Unknown Item',
    price: '-',
    link: 'https://example.com',
    style: 'all',
    type: 'all',
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailController(
        item: item,
        linkLauncher: const ExternalLinkLauncher(),
        favoritesRepository: favoritesRepository,
      )..loadFavoriteStatus(),
      child: const _DetailView(),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetailController>();
    final item = controller.item;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = controller.message;
      if (message == null || !context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      context.read<DetailController>().clearMessage();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 정보'),
        actions: [
          IconButton(
            onPressed: controller.isSavingFavorite
                ? null
                : controller.toggleFavorite,
            icon: Icon(
              controller.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: controller.isFavorite
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            tooltip: '즐겨찾기 저장',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Center(
              child: ItemNetworkImage(
                imageUrl: item.image,
                placeholderLabel: item.type,
                size: 220,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            DetailInfoRow(label: '제품명', value: item.name),
            const SizedBox(height: AppSpacing.lg),
            DetailInfoRow(label: '가격', value: item.price),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isOpeningLink
                    ? null
                    : controller.openPurchaseLink,
                child: Text(controller.isOpeningLink ? '여는 중' : '구매하기'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              item.link,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
