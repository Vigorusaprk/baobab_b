// lib/features/staff/presentation/widgets/invite_role_dropdown.dart
//
// Sélecteur de rôle avec texte explicatif pour l'invitation.

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'role_descriptions.dart';

class InviteRoleDropdown extends StatelessWidget {
  final String selectedRole;
  final String callerRole;
  final ValueChanged<String> onChanged;

  const InviteRoleDropdown({
    super.key,
    required this.selectedRole,
    required this.callerRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final roles = RoleDescription.allowedFor(callerRole);
    final current = roles.firstWhere(
      (r) => r.key == selectedRole,
      orElse: () => roles.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedRole,
          decoration: InputDecoration(
            labelText: 'Rôle attribué',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: roles
              .map((r) => DropdownMenuItem(value: r.key, child: Text(r.title)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
        const SizedBox(height: 6),
        Text(
          current.hint,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
