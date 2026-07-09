import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/shared/widgets/item_summary_card.dart';

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
    return ItemSummaryCard(
      item: item,
      onTap: onTap,
      selected: selected,
      imageSize: 80,
      trailing: OutlinedButton(onPressed: onSelect, child: const Text('선택')),
    );
  }
}
