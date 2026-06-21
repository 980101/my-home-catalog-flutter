import 'package:flutter/foundation.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/home/data/dummy_recommendation_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required DummyRecommendationRepository repository,
    String initialStyle = CatalogOptions.allStyle,
    String initialType = CatalogOptions.allType,
  }) : _repository = repository,
       _selectedStyle = CatalogOptions.containsStyle(initialStyle)
           ? initialStyle
           : CatalogOptions.allStyle,
       _selectedType = CatalogOptions.containsType(initialType)
           ? initialType
           : CatalogOptions.allType {
    _loadItems();
  }

  final DummyRecommendationRepository _repository;

  String _selectedStyle;
  String _selectedType;
  List<ItemModel> _items = const [];

  String get selectedStyle => _selectedStyle;
  String get selectedType => _selectedType;
  String get title => CatalogOptions.styleTitle(_selectedStyle);
  List<ItemModel> get items => _items;

  void selectStyle(String style) {
    if (_selectedStyle == style) {
      return;
    }

    _selectedStyle = style;
    _selectedType = CatalogOptions.allType;
    _loadItems();
    notifyListeners();
  }

  void selectType(String type) {
    if (_selectedType == type) {
      return;
    }

    _selectedType = type;
    _loadItems();
    notifyListeners();
  }

  void _loadItems() {
    _items = _repository.findItems(style: _selectedStyle, type: _selectedType);
  }
}
