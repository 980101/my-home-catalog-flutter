import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_routes.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/home/data/dummy_recommendation_repository.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/controllers/home_controller.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/widgets/furniture_type_filter.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/widgets/recommendation_item_card.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/widgets/style_filter_bar.dart';
import 'package:my_home_catalog_flutter/shared/widgets/bottom_nav_icon_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.initialStyle,
    required this.initialType,
    required this.repository,
    super.key,
  });

  factory HomeScreen.fromRoute(
    RouteSettings settings, {
    RecommendationRepository repository = const DummyRecommendationRepository(),
  }) {
    final arguments = settings.arguments;
    final style = arguments is Map ? arguments['style'] : null;
    final type = arguments is Map ? arguments['type'] : null;

    return HomeScreen(
      initialStyle: style is String ? style : CatalogOptions.allStyle,
      initialType: type is String ? type : CatalogOptions.allType,
      repository: repository,
    );
  }

  final String initialStyle;
  final String initialType;
  final RecommendationRepository repository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(
        repository: repository,
        initialStyle: initialStyle,
        initialType: initialType,
      )..loadItems(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final title = context.select(
      (HomeController controller) => controller.title,
    );
    final items = context.select(
      (HomeController controller) => controller.items,
    );
    final status = context.select(
      (HomeController controller) => controller.status,
    );
    final errorMessage = context.select(
      (HomeController controller) => controller.errorMessage,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(title, style: AppTextStyles.titleLarge),
            ),
            const StyleFilterBar(),
            const SizedBox(height: AppSpacing.md),
            const FurnitureTypeFilter(),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _RecommendationList(
                status: status,
                items: items,
                errorMessage: errorMessage,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _HomeBottomNavigation(),
    );
  }
}

class _RecommendationList extends StatelessWidget {
  const _RecommendationList({
    required this.status,
    required this.items,
    required this.errorMessage,
  });

  final HomeLoadStatus status;
  final List<ItemModel> items;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      HomeLoadStatus.loading => const Center(
        child: CircularProgressIndicator(),
      ),
      HomeLoadStatus.empty => const Center(
        child: Text('추천 상품이 없습니다.', style: AppTextStyles.bodyLarge),
      ),
      HomeLoadStatus.error => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            errorMessage ?? '추천 목록을 불러오지 못했습니다.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
          ),
        ),
      ),
      HomeLoadStatus.data => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = items[index];
          return RecommendationItemCard(
            item: item,
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.detail, arguments: item);
            },
          );
        },
      ),
    };
  }
}

class _HomeBottomNavigation extends StatelessWidget {
  const _HomeBottomNavigation();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomNavIconButton(
              icon: Icons.chair,
              tooltip: '맞춤 가구 둘러보기',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.custom),
            ),
            BottomNavIconButton(
              icon: Icons.home,
              tooltip: '초기 화면',
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.initial, (route) => false),
            ),
            BottomNavIconButton(
              icon: Icons.favorite,
              tooltip: '즐겨찾기',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.favorites),
            ),
          ],
        ),
      ),
    );
  }
}
