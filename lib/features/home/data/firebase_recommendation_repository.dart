import 'package:firebase_database/firebase_database.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_query.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';

class FirebaseRecommendationRepository implements RecommendationRepository {
  FirebaseRecommendationRepository({
    DatabaseReference? rootReference,
    RecommendationQueryResolver queryResolver =
        const RecommendationQueryResolver(),
  }) : _rootReference = rootReference ?? FirebaseDatabase.instance.ref('all'),
       _queryResolver = queryResolver;

  final DatabaseReference _rootReference;
  final RecommendationQueryResolver _queryResolver;

  @override
  Future<List<ItemModel>> findItems({
    required String style,
    required String type,
  }) async {
    final queries = _queryResolver.resolve(style: style, type: type);
    final items = <ItemModel>[];

    for (final query in queries) {
      final snapshot = await _rootReference
          .child(query.style)
          .child(query.type)
          .get();
      items.addAll(_itemsFromSnapshot(snapshot, query.style, query.type));
    }

    return items;
  }

  List<ItemModel> _itemsFromSnapshot(
    DataSnapshot snapshot,
    String style,
    String type,
  ) {
    final value = snapshot.value;
    if (value is! Map<Object?, Object?>) {
      return const [];
    }

    return value.values
        .whereType<Map<Object?, Object?>>()
        .map(
          (data) =>
              ItemModel.fromFirebaseMap(data: data, style: style, type: type),
        )
        .toList(growable: false);
  }
}
