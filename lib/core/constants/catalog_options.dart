import 'package:flutter/material.dart';

class CatalogOption {
  const CatalogOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;
}

class CatalogOptions {
  const CatalogOptions._();

  static const allStyle = 'all';
  static const allType = 'all';

  static const styles = [
    CatalogOption(value: 'all', label: '전체', icon: Icons.apps),
    CatalogOption(value: 'natural', label: '내추럴', icon: Icons.eco),
    CatalogOption(value: 'modern', label: '모던', icon: Icons.weekend),
    CatalogOption(value: 'classic', label: '클래식', icon: Icons.chair),
    CatalogOption(value: 'zen', label: '젠', icon: Icons.spa),
    CatalogOption(value: 'industrial', label: '인더스트리얼', icon: Icons.factory),
  ];

  static const furnitureTypes = [
    CatalogOption(value: 'all', label: '전체', icon: Icons.dashboard),
    CatalogOption(value: 'chair', label: '의자', icon: Icons.chair),
    CatalogOption(value: 'bed', label: '침대', icon: Icons.bed),
    CatalogOption(value: 'sofa', label: '소파', icon: Icons.weekend),
    CatalogOption(value: 'dresser', label: '서랍장', icon: Icons.inventory_2),
    CatalogOption(value: 'table', label: '테이블', icon: Icons.table_restaurant),
  ];

  static String styleTitle(String value) {
    return switch (value) {
      'natural' => '내추럴',
      'modern' => '모던',
      'classic' => '클래식',
      'industrial' => '인더스트리얼',
      'zen' => '젠',
      _ => '모든 스타일',
    };
  }

  static String styleLabel(String value) {
    for (final option in styles) {
      if (option.value == value) {
        return option.label;
      }
    }
    return value;
  }

  static String furnitureTypeLabel(String value) {
    for (final option in furnitureTypes) {
      if (option.value == value) {
        return option.label;
      }
    }
    return value;
  }

  static bool containsStyle(String value) {
    return styles.any((option) => option.value == value);
  }

  static bool containsType(String value) {
    return furnitureTypes.any((option) => option.value == value);
  }
}
