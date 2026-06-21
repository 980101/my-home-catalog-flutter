import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/controllers/home_controller.dart';
import 'package:my_home_catalog_flutter/shared/widgets/selectable_option_chip.dart';
import 'package:provider/provider.dart';

class StyleFilterBar extends StatelessWidget {
  const StyleFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedStyle = context.select(
      (HomeController controller) => controller.selectedStyle,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          for (final option in CatalogOptions.styles) ...[
            SelectableOptionChip(
              label: option.label,
              icon: option.icon,
              selected: selectedStyle == option.value,
              onTap: () {
                context.read<HomeController>().selectStyle(option.value);
              },
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
