// lib/features/staff/presentation/widgets/staff_card.dart
//
// Carte affichant un membre du personnel et ses actions.

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/staff_member.dart';
import 'role_badge.dart';
import 'staff_actions_sheet.dart';
import 'staff_avatar.dart';

class StaffCard extends StatelessWidget {
  final StaffMember member;
  final String callerRole;
  final String callerUserId;
  final void Function(String? role, String? status) onUpdate;
  final VoidCallback onRemove;

  const StaffCard({
    super.key,
    required this.member,
    required this.callerRole,
    required this.callerUserId,
    required this.onUpdate,
    required this.onRemove,
  });

  void _openActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StaffActionsSheet(
        member: member,
        callerRole: callerRole,
        callerUserId: callerUserId,
        onUpdate: onUpdate,
        onRemove: onRemove,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = member.name?.isNotEmpty == true ? member.name! : (member.email ?? 'Membre');
    final subtitle = member.email ?? member.phone ?? '';

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            StaffAvatar(member: member),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  RoleBadge(member: member),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
              onPressed: () => _openActions(context),
            ),
          ],
        ),
      ),
    );
  }
}
