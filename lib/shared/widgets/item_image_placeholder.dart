import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';

class ItemImagePlaceholder extends StatelessWidget {
  const ItemImagePlaceholder({
    required this.label,
    required this.size,
    super.key,
  });

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.labelLarge,
      ),
    );
  }
}
