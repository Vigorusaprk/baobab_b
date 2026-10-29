// lib/features/staff/presentation/widgets/staff_list_body.dart
//
// Corps de la liste du personnel avec gestion de l'état vide et pull-to-refresh.

import 'package:flutter/material.dart';
import '../../data/staff_member.dart';
import 'staff_card.dart';
import 'staff_empty_view.dart';

class StaffListBody extends StatelessWidget {
  final List<StaffMember> members;
  final String callerRole;
  final String callerUserId;
  final Future<void> Function() onRefresh;
  final void Function(StaffMember member, String? role, String? status) onUpdate;
  final void Function(StaffMember member) onRemove;

  const StaffListBody({
    super.key,
    required this.members,
    required this.callerRole,
    required this.callerUserId,
    required this.onRefresh,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return StaffEmptyView(onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 12, bottom: 88),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          return StaffCard(
            member: m,
            callerRole: callerRole,
            callerUserId: callerUserId,
            onUpdate: (r, s) => onUpdate(m, r, s),
            onRemove: () => onRemove(m),
          );
        },
      ),
    );
  }
}
