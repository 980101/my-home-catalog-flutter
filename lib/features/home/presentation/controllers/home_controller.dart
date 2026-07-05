import 'package:flutter/foundation.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';

enum HomeLoadStatus { loading, data, empty, error }

class HomeController extends ChangeNotifier {
  HomeController({
    required RecommendationRepository repository,
    String initialStyle = CatalogOptions.allStyle,
    String initialType = CatalogOptions.allType,
  }) : _repository = repository,
       _selectedStyle = CatalogOptions.containsStyle(initialStyle)
           ? initialStyle
           : CatalogOptions.allStyle,
       _selectedType = CatalogOptions.containsType(initialType)
           ? initialType
           : CatalogOptions.allType;

  final RecommendationRepository _repository;

  String _selectedStyle;
  String _selectedType;
  List<ItemModel> _items = const [];
  HomeLoadStatus _status = HomeLoadStatus.loading;
  String? _errorMessage;

  String get selectedStyle => _selectedStyle;
  String get selectedType => _selectedType;
  String get title => CatalogOptions.styleTitle(_selectedStyle);
  List<ItemModel> get items => _items;
  HomeLoadStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> loadItems() async {
    await _loadItems();
  }

  Future<void> selectStyle(String style) async {
    if (_selectedStyle == style) {
      return;
    }

    _selectedStyle = style;
    _selectedType = CatalogOptions.allType;
    await _loadItems();
  }

  Future<void> selectType(String type) async {
    if (_selectedType == type) {
      return;
    }

    _selectedType = type;
    await _loadItems();
  }

  Future<void> _loadItems() async {
    _status = HomeLoadStatus.loading;
    _items = const [];
    _errorMessage = null;
    notifyListeners();

    try {
      final items = await _repository.findItems(
        style: _selectedStyle,
        type: _selectedType,
      );
      _items = items;
      _status = items.isEmpty ? HomeLoadStatus.empty : HomeLoadStatus.data;
    } catch (error) {
      _items = const [];
      _status = HomeLoadStatus.error;
      _errorMessage = error.toString();
    }

    notifyListeners();
  }
}
