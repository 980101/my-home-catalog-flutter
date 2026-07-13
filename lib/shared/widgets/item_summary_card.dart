import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/shared/widgets/item_network_image.dart';

class ItemSummaryCard extends StatelessWidget {
  const ItemSummaryCard({
    required this.item,
    required this.onTap,
    this.selected = false,
    this.imageSize = 88,
    this.trailing,
    super.key,
  });

  final ItemModel item;
  final VoidCallback onTap;
  final bool selected;
  final double imageSize;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            ItemNetworkImage(
              imageUrl: item.image,
              placeholderLabel: CatalogOptions.furnitureTypeLabel(item.type),
              size: imageSize,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(item.price, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
