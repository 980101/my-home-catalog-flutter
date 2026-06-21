import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_routes.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/features/custom/presentation/controllers/custom_controller.dart';
import 'package:my_home_catalog_flutter/features/custom/presentation/widgets/furniture_type_tile.dart';
import 'package:provider/provider.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomController(),
      child: const _CustomView(),
    );
  }
}

class _CustomView extends StatelessWidget {
  const _CustomView();

  @override
  Widget build(BuildContext context) {
    final selectedType = context.select(
      (CustomController controller) => controller.selectedType,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('맞춤 가구 둘러보기', style: AppTextStyles.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              const Text('가구 선택', style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: GridView.builder(
                  itemCount: CatalogOptions.furnitureTypes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final option = CatalogOptions.furnitureTypes[index];

                    return FurnitureTypeTile(
                      option: option,
                      selected: selectedType == option.value,
                      onTap: () {
                        context.read<CustomController>().selectType(
                          option.value,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _goNext(context),
                  child: const Text('다음'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goNext(BuildContext context) {
    final selectedType = context.read<CustomController>().selectedType;
    if (selectedType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('가구를 선택해주세요!')));
      return;
    }

    Navigator.of(
      context,
    ).pushNamed(AppRoutes.camera, arguments: {'type': selectedType});
  }
}
