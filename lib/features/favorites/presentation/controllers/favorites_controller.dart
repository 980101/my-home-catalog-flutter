import 'package:flutter/foundation.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/favorites/data/dummy_favorites_repository.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController({required DummyFavoritesRepository repository})
    : _items = repository.loadItems().toList();

  final List<ItemModel> _items;
  int? _selectedIndex;
  String? _message;

  List<ItemModel> get items => List.unmodifiable(_items);
  int? get selectedIndex => _selectedIndex;
  String? get message => _message;
  bool get isEmpty => _items.isEmpty;

  void selectItem(int index) {
    _selectedIndex = index;
    _message = null;
    notifyListeners();
  }

  void deleteSelected() {
    final index = _selectedIndex;
    if (index == null || index < 0 || index >= _items.length) {
      _message = '즐겨찾기한 항목이 없습니다 !';
      notifyListeners();
      return;
    }

    _items.removeAt(index);
    _selectedIndex = null;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
  }
}
