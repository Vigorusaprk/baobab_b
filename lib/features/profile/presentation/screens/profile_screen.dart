import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/profile/presentation/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Onglet « Boutique » : fiche du commerce (identité, contact, adresse,
/// horaires, photo, fermeture temporaire) et déconnexion.
class ProfileScreen extends StatelessWidget {
  final String businessId;
  const ProfileScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Ma boutique'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
          ),
        ],
      ),
      body: const ShopScreen(),
    );
  }
}
