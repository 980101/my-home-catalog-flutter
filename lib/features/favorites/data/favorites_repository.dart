import 'dart:convert';
import 'dart:io';

import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:path_provider/path_provider.dart';

class FavoritesRepository {
  const FavoritesRepository({Directory? storageDirectory})
    : _storageDirectory = storageDirectory;

  static const fileName = 'savedItem.json';

  final Directory? _storageDirectory;

  Future<List<ItemModel>> loadItems() async {
    final file = await _file();
    if (!await file.exists()) {
      return const [];
    }

    final contents = await file.readAsString();
    if (contents.trim().isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(contents);
    if (decoded is! List) {
      throw const FormatException('savedItem.json must contain a JSON array.');
    }

    return decoded
        .whereType<Map>()
        .map(
          (data) =>
              ItemModel.fromSavedItemJson(Map<String, dynamic>.from(data)),
        )
        .toList(growable: false);
  }

  Future<bool> isSaved(ItemModel item) async {
    final items = await loadItems();
    return items.any((savedItem) => savedItem.name == item.name);
  }

  Future<FavoriteSaveResult> saveItem(ItemModel item) async {
    final items = await loadItems();
    if (items.any((savedItem) => savedItem.name == item.name)) {
      return FavoriteSaveResult.duplicate;
    }

    await _writeItems([...items, item]);
    return FavoriteSaveResult.saved;
  }

  Future<void> deleteAt(int index) async {
    final items = await loadItems();
    if (index < 0 || index >= items.length) {
      return;
    }

    final updatedItems = List<ItemModel>.of(items)..removeAt(index);
    await _writeItems(updatedItems);
  }

  Future<File> _file() async {
    final directory =
        _storageDirectory ?? await getApplicationDocumentsDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return File('${directory.path}/$fileName');
  }

  Future<void> _writeItems(List<ItemModel> items) async {
    final file = await _file();
    final encoded = jsonEncode(
      items.map((item) => item.toSavedItemJson()).toList(growable: false),
    );
    await file.writeAsString(encoded);
  }
}

enum FavoriteSaveResult { saved, duplicate }
