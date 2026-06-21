import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/controllers/home_controller.dart';
import 'package:my_home_catalog_flutter/shared/widgets/selectable_option_chip.dart';
import 'package:provider/provider.dart';

class FurnitureTypeFilter extends StatelessWidget {
  const FurnitureTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedType = context.select(
      (HomeController controller) => controller.selectedType,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          for (final option in CatalogOptions.furnitureTypes) ...[
            SelectableOptionChip(
              label: option.label,
              icon: option.icon,
              selected: selectedType == option.value,
              onTap: () {
                context.read<HomeController>().selectType(option.value);
              },
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
