// lib/features/staff/presentation/widgets/staff_avatar.dart
//
// Avatar circulaire avec initiales du membre d'équipe.

import 'package:flutter/material.dart';
import '../../data/staff_member.dart';

class StaffAvatar extends StatelessWidget {
  final StaffMember member;
  final double radius;
  const StaffAvatar({super.key, required this.member, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: member.roleColor.withValues(alpha: 0.18),
      child: Text(
        member.initials,
        style: TextStyle(
          color: member.roleColor,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}
