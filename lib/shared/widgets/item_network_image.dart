import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/shared/widgets/item_image_placeholder.dart';

class ItemNetworkImage extends StatelessWidget {
  const ItemNetworkImage({
    required this.imageUrl,
    required this.size,
    this.placeholderLabel = '',
    super.key,
  });

  final String imageUrl;
  final double size;
  final String placeholderLabel;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(imageUrl);
    final canLoadNetworkImage =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (!canLoadNetworkImage) {
      return ItemImagePlaceholder(label: placeholderLabel, size: size);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return DecoratedBox(
              decoration: const BoxDecoration(color: AppColors.primaryLight),
              child: Center(
                child: SizedBox(
                  width: size * 0.28,
                  height: size * 0.28,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return ItemImagePlaceholder(label: placeholderLabel, size: size);
          },
        ),
      ),
    );
  }
}
