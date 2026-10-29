// lib/features/staff/presentation/widgets/staff_actions_sheet.dart
//
// Feuille d'actions contextuelles par membre (selon les permissions).

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/staff_member.dart';
import 'change_role_dialog.dart';

class StaffActionsSheet extends StatelessWidget {
  final StaffMember member;
  final String callerRole;
  final String callerUserId;
  final void Function(String? role, String? status) onUpdate;
  final VoidCallback onRemove;

  const StaffActionsSheet({
    super.key,
    required this.member,
    required this.callerRole,
    required this.callerUserId,
    required this.onUpdate,
    required this.onRemove,
  });

  bool get _isSelf => member.userId == callerUserId;
  bool get _managerOnOwner => callerRole == 'manager' && member.role == 'owner';
  bool get _canManage => !_isSelf && !_managerOnOwner;

  @override
  Widget build(BuildContext context) {
    if (!_canManage) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          _isSelf
              ? 'Vous ne pouvez pas modifier votre propre compte.'
              : 'Un gérant ne peut pas modifier un propriétaire.',
          style: const TextStyle(color: AppColors.textMuted),
          textAlign: TextAlign.center,
        ),
      );
    }

    final newStatus = member.isActive ? 'suspended' : 'active';
    final statusLabel = member.isActive ? 'Suspendre' : 'Réactiver';

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined),
            title: const Text('Changer le rôle'),
            onTap: () async {
              Navigator.pop(context);
              final newRole = await showChangeRoleDialog(
                context,
                member: member,
                callerRole: callerRole,
              );
              if (newRole != null) onUpdate(newRole, null);
            },
          ),
          ListTile(
            leading: Icon(
              member.isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
            ),
            title: Text(statusLabel),
            onTap: () {
              Navigator.pop(context);
              onUpdate(null, newStatus);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove_outlined, color: AppColors.error),
            title: const Text('Retirer de l\'équipe', style: TextStyle(color: AppColors.error)),
            onTap: () {
              Navigator.pop(context);
              onRemove();
            },
          ),
        ],
      ),
    );
  }
}
