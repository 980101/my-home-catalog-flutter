import 'package:shared_preferences/shared_preferences.dart';

class StyleHistoryRepository {
  const StyleHistoryRepository();

  static const preferencesName = 'file';
  static const _stylesKey = 'recognition_styles';

  Future<List<String>> loadStyles() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(_stylesKey) ?? const [];
  }

  Future<List<String>> saveStyle(String style) async {
    final preferences = await SharedPreferences.getInstance();
    final styles = await loadStyles();
    final updatedStyles = <String>[
      style,
      ...styles.where((savedStyle) => savedStyle != style),
    ];
    await preferences.setStringList(_stylesKey, updatedStyles);
    await preferences.setString(style, style);
    return updatedStyles;
  }

  Future<List<String>> deleteStyle(String style) async {
    final preferences = await SharedPreferences.getInstance();
    final styles = await loadStyles();
    final updatedStyles = styles
        .where((savedStyle) => savedStyle != style)
        .toList(growable: false);
    await preferences.setStringList(_stylesKey, updatedStyles);
    await preferences.remove(style);
    return updatedStyles;
  }
}
