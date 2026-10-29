// lib/features/staff/data/staff_member.dart
import 'package:flutter/material.dart';

class StaffMember {
  final String id;
  final String userId;
  final String? name;
  final String? phone;
  final String? email;
  final String role;
  final String status;
  final DateTime? invitedAt;

  const StaffMember({
    required this.id,
    required this.userId,
    this.name,
    this.phone,
    this.email,
    required this.role,
    required this.status,
    this.invitedAt,
  });

  factory StaffMember.fromJson(Map<String, dynamic> j) => StaffMember(
        id: (j['id'] ?? '').toString(),
        userId: (j['user_id'] ?? j['userId'] ?? '').toString(),
        name: j['name']?.toString() ?? j['full_name']?.toString(),
        phone: j['phone']?.toString(),
        email: j['email']?.toString(),
        role: (j['role'] ?? 'staff').toString().toLowerCase(),
        status: (j['status'] ?? 'active').toString().toLowerCase(),
        invitedAt: j['invited_at'] != null
            ? DateTime.tryParse(j['invited_at'].toString())
            : (j['created_at'] != null
                ? DateTime.tryParse(j['created_at'].toString())
                : null),
      );

  bool get isActive => status == 'active';

  String get roleLabel => const {
        'owner': 'Propriétaire',
        'manager': 'Gérant',
        'staff': 'Employé',
        'kitchen': 'Cuisine',
      }[role] ?? role;

  String get statusLabel => isActive ? 'Actif' : 'Suspendu';

  Color get roleColor => const {
        'owner': Color(0xFF254D32),
        'manager': Color(0xFF1565C0),
        'staff': Color(0xFF5D4037),
        'kitchen': Color(0xFFE65100),
      }[role] ?? Colors.grey;

  String get initials {
    final n = (name ?? email ?? 'MB').trim();
    final parts = n.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'MB';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
