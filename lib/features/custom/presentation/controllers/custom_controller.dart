import 'package:flutter/foundation.dart';

class CustomController extends ChangeNotifier {
  String? _selectedType;

  String? get selectedType => _selectedType;

  void selectType(String type) {
    _selectedType = type;
    notifyListeners();
  }
}
