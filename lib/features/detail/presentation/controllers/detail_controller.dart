import 'package:flutter/foundation.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/detail/data/external_link_launcher.dart';
import 'package:my_home_catalog_flutter/features/favorites/data/favorites_repository.dart';

class DetailController extends ChangeNotifier {
  DetailController({
    required this.item,
    required ExternalLinkLauncher linkLauncher,
    required FavoritesRepository favoritesRepository,
  }) : _linkLauncher = linkLauncher,
       _favoritesRepository = favoritesRepository;

  final ItemModel item;
  final ExternalLinkLauncher _linkLauncher;
  final FavoritesRepository _favoritesRepository;

  bool _isFavorite = false;
  bool _isOpeningLink = false;
  bool _isSavingFavorite = false;
  String? _message;

  bool get isFavorite => _isFavorite;
  bool get isOpeningLink => _isOpeningLink;
  bool get isSavingFavorite => _isSavingFavorite;
  String? get message => _message;

  Future<void> loadFavoriteStatus() async {
    try {
      _isFavorite = await _favoritesRepository.isSaved(item);
      notifyListeners();
    } on Object catch (error) {
      _message = '즐겨찾기 정보를 읽을 수 없습니다: $error';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    if (_isSavingFavorite) {
      return;
    }

    _isSavingFavorite = true;
    _message = null;
    notifyListeners();

    try {
      final result = await _favoritesRepository.saveItem(item);
      _isFavorite = true;
      _message = switch (result) {
        FavoriteSaveResult.saved => null,
        FavoriteSaveResult.duplicate => '이미 존재하는 아이템입니다.',
      };
    } on Object catch (error) {
      _message = '즐겨찾기를 저장할 수 없습니다: $error';
    } finally {
      _isSavingFavorite = false;
      notifyListeners();
    }
  }

  Future<void> openPurchaseLink() async {
    _isOpeningLink = true;
    _message = null;
    notifyListeners();

    final opened = await _linkLauncher.open(item.link);

    _isOpeningLink = false;
    _message = opened ? null : '구매 링크를 열 수 없습니다.';
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
  }
}
