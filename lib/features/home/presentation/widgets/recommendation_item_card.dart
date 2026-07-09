import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/shared/widgets/item_summary_card.dart';

class RecommendationItemCard extends StatelessWidget {
  const RecommendationItemCard({
    required this.item,
    required this.onTap,
    super.key,
  });

  final ItemModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ItemSummaryCard(item: item, onTap: onTap);
  }
}
