import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Traduit une erreur technique d'authentification en message lisible.
String friendlyAuthError(String raw) {
  if (raw.contains('invalid_credentials')) {
    return 'Email ou mot de passe incorrect.';
  }
  if (raw.contains('SocketException') || raw.contains('ClientException')) {
    return 'Connexion impossible. Vérifiez votre accès internet.';
  }
  return 'Une erreur est survenue. Réessayez dans un instant.';
}

/// Bandeau d'erreur discret affiché au-dessus du bouton de connexion.
class LoginErrorBanner extends StatelessWidget {
  final String message;

  const LoginErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
