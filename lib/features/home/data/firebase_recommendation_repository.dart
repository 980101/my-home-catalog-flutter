import 'package:firebase_database/firebase_database.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_query.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';
import 'package:my_home_catalog_flutter/features/home/data/public_image_url_resolver.dart';

class FirebaseRecommendationRepository implements RecommendationRepository {
  FirebaseRecommendationRepository({
    DatabaseReference? rootReference,
    RecommendationQueryResolver queryResolver =
        const RecommendationQueryResolver(),
    PublicImageUrlResolver? imageUrlResolver,
  }) : _rootReference = rootReference ?? FirebaseDatabase.instance.ref('all'),
       _queryResolver = queryResolver,
       _imageUrlResolver = imageUrlResolver ?? PublicImageUrlResolver();

  final DatabaseReference _rootReference;
  final RecommendationQueryResolver _queryResolver;
  final PublicImageUrlResolver _imageUrlResolver;

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
      for (final entry in _childMaps(snapshot.value)) {
        final item = ItemModel.fromFirebaseMap(
          data: entry.value,
          style: query.style,
          type: query.type,
        );
        final image = await _imageUrlResolver.resolve(
          path: 'all/${query.style}/${query.type}/${entry.key}',
          fallbackUrl: item.image,
        );
        items.add(
          ItemModel(
            image: image,
            name: item.name,
            price: item.price,
            link: item.link,
            style: item.style,
            type: item.type,
          ),
        );
      }
    }

    return items;
  }

  Iterable<MapEntry<String, Map<Object?, Object?>>> _childMaps(Object? value) {
    return switch (value) {
      Map<Object?, Object?> map =>
        map.entries
            .where((entry) => entry.value is Map<Object?, Object?>)
            .map(
              (entry) => MapEntry(
                entry.key.toString(),
                entry.value as Map<Object?, Object?>,
              ),
            ),
      List<Object?> list =>
        list.indexed
            .where((entry) => entry.$2 is Map<Object?, Object?>)
            .map(
              (entry) => MapEntry(
                'Item_${entry.$1.toString().padLeft(2, '0')}',
                entry.$2 as Map<Object?, Object?>,
              ),
            ),
      _ => const Iterable<MapEntry<String, Map<Object?, Object?>>>.empty(),
    };
  }
}
