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
    CatalogOption(value: 'all', label: '모두', icon: Icons.apps),
    CatalogOption(value: 'natural', label: '내추럴', icon: Icons.eco),
    CatalogOption(value: 'modern', label: '모던', icon: Icons.weekend),
    CatalogOption(value: 'classic', label: '클래식', icon: Icons.chair),
    CatalogOption(value: 'zen', label: '젠', icon: Icons.spa),
    CatalogOption(value: 'industrial', label: '인더스트리얼', icon: Icons.factory),
  ];

  static const furnitureTypes = [
    CatalogOption(value: 'all', label: 'All', icon: Icons.dashboard),
    CatalogOption(value: 'chair', label: 'Chair', icon: Icons.chair),
    CatalogOption(value: 'bed', label: 'Bed', icon: Icons.bed),
    CatalogOption(value: 'sofa', label: 'Sofa', icon: Icons.weekend),
    CatalogOption(value: 'dresser', label: 'Dresser', icon: Icons.inventory_2),
    CatalogOption(value: 'table', label: 'Table', icon: Icons.table_restaurant),
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

  static bool containsStyle(String value) {
    return styles.any((option) => option.value == value);
  }

  static bool containsType(String value) {
    return furnitureTypes.any((option) => option.value == value);
  }
}
