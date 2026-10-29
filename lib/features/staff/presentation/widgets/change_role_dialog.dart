// lib/features/staff/presentation/widgets/change_role_dialog.dart
//
// Dialogue de sélection d'un nouveau rôle pour un membre.

import 'package:flutter/material.dart';
import '../../data/staff_member.dart';

Future<String?> showChangeRoleDialog(
  BuildContext context, {
  required StaffMember member,
  required String callerRole,
}) {
  final roles = [
    if (callerRole == 'owner') ('owner', 'Propriétaire'),
    ('manager', 'Gérant'),
    ('staff', 'Employé'),
    ('kitchen', 'Cuisine'),
  ];

  return showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text('Changer le rôle de ${member.name ?? member.email ?? ''}'),
      children: roles.map((r) {
        final isCurrent = r.$1 == member.role;
        return SimpleDialogOption(
          onPressed: isCurrent ? null : () => Navigator.pop(ctx, r.$1),
          child: Row(
            children: [
              Icon(
                isCurrent ? Icons.check_circle : Icons.circle_outlined,
                size: 20,
                color: isCurrent ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                r.$2,
                style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
