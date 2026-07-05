import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';

class RecommendationQuery {
  const RecommendationQuery({required this.style, required this.type});

  final String style;
  final String type;
}

class RecommendationQueryResolver {
  const RecommendationQueryResolver();

  List<RecommendationQuery> resolve({
    required String style,
    required String type,
  }) {
    final styles = _stylesToQuery(style);
    final types = _typesToQuery(type);

    return [
      for (final styleValue in styles)
        for (final typeValue in types)
          RecommendationQuery(style: styleValue, type: typeValue),
    ];
  }

  Iterable<String> _stylesToQuery(String style) {
    if (style != CatalogOptions.allStyle) {
      return [style];
    }

    return CatalogOptions.styles
        .where((option) => option.value != CatalogOptions.allStyle)
        .map((option) => option.value);
  }

  Iterable<String> _typesToQuery(String type) {
    if (type != CatalogOptions.allType) {
      return [type];
    }

    return CatalogOptions.furnitureTypes
        .where((option) => option.value != CatalogOptions.allType)
        .map((option) => option.value);
  }
}
