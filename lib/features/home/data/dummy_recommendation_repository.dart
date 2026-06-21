import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';

class DummyRecommendationRepository {
  const DummyRecommendationRepository();

  List<ItemModel> findItems({required String style, required String type}) {
    final styles = style == CatalogOptions.allStyle
        ? CatalogOptions.styles
              .where((option) => option.value != CatalogOptions.allStyle)
              .map((option) => option.value)
        : [style];
    final types = type == CatalogOptions.allType
        ? CatalogOptions.furnitureTypes
              .where((option) => option.value != CatalogOptions.allType)
              .map((option) => option.value)
        : [type];

    return _items
        .where((item) {
          return styles.contains(item.style) && types.contains(item.type);
        })
        .toList(growable: false);
  }

  static const _items = [
    ItemModel(
      image: 'dummy://natural-chair',
      name: 'Natural Chair',
      price: '120,000원',
      link: 'https://example.com/natural-chair',
      style: 'natural',
      type: 'chair',
    ),
    ItemModel(
      image: 'dummy://modern-bed',
      name: 'Modern Bed',
      price: '420,000원',
      link: 'https://example.com/modern-bed',
      style: 'modern',
      type: 'bed',
    ),
    ItemModel(
      image: 'dummy://classic-sofa',
      name: 'Classic Sofa',
      price: '380,000원',
      link: 'https://example.com/classic-sofa',
      style: 'classic',
      type: 'sofa',
    ),
    ItemModel(
      image: 'dummy://industrial-dresser',
      name: 'Industrial Dresser',
      price: '260,000원',
      link: 'https://example.com/industrial-dresser',
      style: 'industrial',
      type: 'dresser',
    ),
    ItemModel(
      image: 'dummy://zen-table',
      name: 'Zen Table',
      price: '190,000원',
      link: 'https://example.com/zen-table',
      style: 'zen',
      type: 'table',
    ),
  ];
}
