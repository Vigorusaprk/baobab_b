// lib/features/staff/presentation/widgets/staff_fab.dart
//
// Bouton flottant pour inviter un collaborateur dans l'équipe.

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'invite_staff_sheet.dart';

class StaffFab extends StatelessWidget {
  final String businessId;
  final String callerRole;
  final VoidCallback onInvited;

  const StaffFab({
    super.key,
    required this.businessId,
    required this.callerRole,
    required this.onInvited,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final ok = await showInviteStaffSheet(
          context,
          businessId: businessId,
          callerRole: callerRole,
        );
        if (ok == true) onInvited();
      },
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.person_add_outlined),
      label: const Text('Inviter'),
    );
  }
}
