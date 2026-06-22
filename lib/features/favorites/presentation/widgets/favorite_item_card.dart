import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/shared/widgets/item_image_placeholder.dart';

class FavoriteItemCard extends StatelessWidget {
  const FavoriteItemCard({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.onSelect,
    super.key,
  });

  final ItemModel item;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onSelect;

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
            ItemImagePlaceholder(label: item.type, size: 80),
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
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton(onPressed: onSelect, child: const Text('선택')),
          ],
        ),
      ),
    );
  }
}
