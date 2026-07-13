import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/features/home/presentation/controllers/home_controller.dart';
import 'package:my_home_catalog_flutter/shared/widgets/selectable_option_chip.dart';
import 'package:provider/provider.dart';

class StyleFilterBar extends StatefulWidget {
  const StyleFilterBar({super.key});

  @override
  State<StyleFilterBar> createState() => _StyleFilterBarState();
}

class _StyleFilterBarState extends State<StyleFilterBar> {
  final ScrollController _scrollController = ScrollController();
  late final Map<String, GlobalKey> _chipKeys = {
    for (final option in CatalogOptions.styles) option.value: GlobalKey(),
  };
  String? _lastVisibleStyle;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedStyle = context.select(
      (HomeController controller) => controller.selectedStyle,
    );
    _scrollSelectedChipIntoView(selectedStyle);

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          for (final option in CatalogOptions.styles) ...[
            SelectableOptionChip(
              key: _chipKeys[option.value],
              label: option.label,
              icon: option.icon,
              selected: selectedStyle == option.value,
              onTap: () {
                context.read<HomeController>().selectStyle(option.value);
              },
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  void _scrollSelectedChipIntoView(String selectedStyle) {
    if (_lastVisibleStyle == selectedStyle) {
      return;
    }
    _lastVisibleStyle = selectedStyle;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      final chipContext = _chipKeys[selectedStyle]?.currentContext;
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
