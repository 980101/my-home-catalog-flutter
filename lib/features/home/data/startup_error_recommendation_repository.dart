import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';

class StartupErrorRecommendationRepository implements RecommendationRepository {
  const StartupErrorRecommendationRepository(this.error);

  final Object error;

  @override
  Future<List<ItemModel>> findItems({
    required String style,
    required String type,
  }) async {
    throw StateError('Firebase 초기화 실패: $error');
  }
}
