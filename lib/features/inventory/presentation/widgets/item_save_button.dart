import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Bouton « Enregistrer » ; affiche un spinner et se désactive pendant l'envoi.
class ItemSaveButton extends StatelessWidget {
  final bool saving;
  final VoidCallback onPressed;
  const ItemSaveButton({super.key, required this.saving, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: saving ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.secondary,
        minimumSize: const Size.fromHeight(48),
      ),
      child: saving
          ? const SizedBox(
              height: 20, width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Text('Enregistrer'),
    );
  }
}
