import 'package:flutter/foundation.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/favorites/data/favorites_repository.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController({required FavoritesRepository repository})
    : _repository = repository;

  final FavoritesRepository _repository;
  final List<ItemModel> _items = [];
  int? _selectedIndex;
  bool _isLoading = true;
  String? _message;
  String? _errorMessage;

  List<ItemModel> get items => List.unmodifiable(_items);
  int? get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  String? get message => _message;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _items.isEmpty;

  Future<void> loadItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedItems = await _repository.loadItems();
      _items
        ..clear()
        ..addAll(loadedItems);
      _selectedIndex = null;
    } on Object catch (error) {
      _items.clear();
      _selectedIndex = null;
      _errorMessage = '즐겨찾기 목록을 읽을 수 없습니다: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectItem(int index) {
    _selectedIndex = index;
    _message = null;
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    final index = _selectedIndex;
    if (index == null || index < 0 || index >= _items.length) {
      _message = '즐겨찾기한 항목이 없습니다 !';
      notifyListeners();
      return;
    }

    try {
      await _repository.deleteAt(index);
      _items
        ..clear()
        ..addAll(await _repository.loadItems());
      _selectedIndex = null;
    } on Object catch (error) {
      _message = '즐겨찾기 항목을 삭제할 수 없습니다: $error';
    } finally {
      notifyListeners();
    }
  }

  void clearMessage() {
    _message = null;
  }
}
