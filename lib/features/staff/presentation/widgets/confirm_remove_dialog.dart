// lib/features/staff/presentation/widgets/confirm_remove_dialog.dart
//
// Dialogue de confirmation pour retirer un membre de l'équipe.

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/staff_member.dart';

Future<bool> showConfirmRemoveDialog(BuildContext context, StaffMember member) async {
  final name = member.name ?? member.email ?? 'Ce membre';
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Retirer ce membre ?'),
      content: Text('$name sera définitivement retiré de l\'équipe.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Retirer'),
        ),
      ],
    ),
  );
  return result ?? false;
}
