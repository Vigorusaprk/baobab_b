import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Choix du type d'offre : à commander, à réserver ou en boutique.
class FulfilmentPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const FulfilmentPicker({super.key, required this.value, required this.onChanged});

  static const _options = {
    'order': 'À commander',
    'booking': 'À réserver',
    'in_store': 'En boutique',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 8,
        children: _options.entries.map((e) {
          return ChoiceChip(
            label: Text(e.value),
            selected: value == e.key,
            selectedColor: AppColors.secondary.withOpacity(0.15),
            onSelected: (_) => onChanged(e.key),
          );
        }).toList(),
      ),
    );
  }
}
