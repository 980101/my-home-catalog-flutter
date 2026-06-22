import 'package:my_home_catalog_flutter/data/models/item_model.dart';

class DummyFavoritesRepository {
  const DummyFavoritesRepository();

  List<ItemModel> loadItems() {
    return const [
      ItemModel(
        image: 'dummy://favorite-chair',
        name: 'Favorite Chair',
        price: '130,000원',
        link: 'https://example.com/favorite-chair',
        style: 'natural',
        type: 'chair',
      ),
      ItemModel(
        image: 'dummy://favorite-table',
        name: 'Favorite Table',
        price: '210,000원',
        link: 'https://example.com/favorite-table',
        style: 'zen',
        type: 'table',
      ),
    ];
  }
}
