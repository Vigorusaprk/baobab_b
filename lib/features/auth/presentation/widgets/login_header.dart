import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// En-tête de l'écran de connexion : pastille de marque + titre + sous-titre.
/// Design plat (sans flou ni dégradé) pour un rendu sobre et professionnel.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pastille de marque (icône commerce) sur fond vert
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Espace professionnel',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Connectez-vous pour gérer votre commerce.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
