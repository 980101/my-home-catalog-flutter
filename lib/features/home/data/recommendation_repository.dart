import 'package:my_home_catalog_flutter/data/models/item_model.dart';

abstract class RecommendationRepository {
  Future<List<ItemModel>> findItems({
    required String style,
    required String type,
  });
}
