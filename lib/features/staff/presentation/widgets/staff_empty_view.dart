// lib/features/staff/presentation/widgets/staff_empty_view.dart
//
// Vue affichée lorsque l'équipe ne contient encore aucun membre.

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class StaffEmptyView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const StaffEmptyView({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Icon(Icons.people_outline, size: 64, color: AppColors.textMuted),
          SizedBox(height: 16),
          Text(
            'Aucun membre pour l\'instant',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Invitez vos collaborateurs pour leur donner accès au commerce.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
