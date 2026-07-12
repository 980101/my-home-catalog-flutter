import 'dart:convert';

import 'package:flutter/services.dart';

class PublicImageUrlResolver {
  PublicImageUrlResolver({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const _mappingAsset = 'tools/image_url_mapping.json';

  final AssetBundle _bundle;
  Future<Map<String, String>>? _mappingFuture;

  Future<String> resolve({
    required String path,
    required String fallbackUrl,
  }) async {
    final mapping = await (_mappingFuture ??= _loadMapping());
    return mapping[path] ?? fallbackUrl;
  }

  Future<Map<String, String>> _loadMapping() async {
    try {
      final source = await _bundle.loadString(_mappingAsset);
      final json = jsonDecode(source);
      if (json is! Map<String, dynamic>) {
        return const {};
      }

      return {
        for (final MapEntry(:key, :value) in json.entries)
          if (value is Map &&
              value['newImage'] is String &&
              (value['newImage'] as String).startsWith('https://'))
            key: value['newImage'] as String,
      };
    } on Object {
      return const {};
    }
  }
}
