import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/controllers/home_controller.dart';
import 'package:my_home_catalog_flutter/shared/widgets/selectable_option_chip.dart';
import 'package:provider/provider.dart';

class FurnitureTypeFilter extends StatefulWidget {
  const FurnitureTypeFilter({super.key});

  @override
  State<FurnitureTypeFilter> createState() => _FurnitureTypeFilterState();
}

class _FurnitureTypeFilterState extends State<FurnitureTypeFilter> {
  final ScrollController _scrollController = ScrollController();
  late final Map<String, GlobalKey> _chipKeys = {
    for (final option in CatalogOptions.furnitureTypes)
      option.value: GlobalKey(),
  };
  String? _lastVisibleType;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = context.select(
      (HomeController controller) => controller.selectedType,
    );
    _scrollSelectedChipIntoView(selectedType);

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          for (final option in CatalogOptions.furnitureTypes) ...[
            SelectableOptionChip(
              key: _chipKeys[option.value],
              label: option.label,
              icon: option.icon,
              selected: selectedType == option.value,
              onTap: () {
                context.read<HomeController>().selectType(option.value);
              },
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  void _scrollSelectedChipIntoView(String selectedType) {
    if (_lastVisibleType == selectedType) {
      return;
    }
    _lastVisibleType = selectedType;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      final chipContext = _chipKeys[selectedType]?.currentContext;
      if (chipContext == null) {
        return;
      }
      Scrollable.ensureVisible(
        chipContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: 0.5,
      );
    });
  }
}
