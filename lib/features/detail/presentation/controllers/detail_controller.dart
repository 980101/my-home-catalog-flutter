import 'package:flutter/foundation.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/detail/data/external_link_launcher.dart';

class DetailController extends ChangeNotifier {
  DetailController({
    required this.item,
    required ExternalLinkLauncher linkLauncher,
  }) : _linkLauncher = linkLauncher;

  final ItemModel item;
  final ExternalLinkLauncher _linkLauncher;

  bool _isFavorite = false;
  bool _isOpeningLink = false;
  String? _message;

  bool get isFavorite => _isFavorite;
  bool get isOpeningLink => _isOpeningLink;
  String? get message => _message;

  void toggleFavorite() {
    _isFavorite = true;
    _message = '실제 즐겨찾기 저장은 이후 단계에서 구현합니다.';
    notifyListeners();
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
