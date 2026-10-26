import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'login_button.dart';
import 'login_error_banner.dart';
import 'login_header.dart';
import 'login_text_field.dart';

/// Formulaire de connexion complet : en-tête, champs, erreur éventuelle,
/// bouton et note d'accès. Widget "bête" : les contrôleurs, l'état de
/// chargement et l'action de connexion sont fournis par l'écran parent.
class LoginForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController pwdCtrl;
  final bool isLoading;
  final String? error; // Message déjà lisible, ou null
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.emailCtrl,
    required this.pwdCtrl,
    required this.isLoading,
    required this.error,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoginHeader(),
          const SizedBox(height: 36),
          LoginTextField(
            controller: emailCtrl,
            label: 'Email',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.username],
          ),
          const SizedBox(height: 14),
          LoginTextField(
            controller: pwdCtrl,
            label: 'Mot de passe',
            icon: Icons.lock_outline,
            isPassword: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) => onLogin(),
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            LoginErrorBanner(message: error!),
          ],
          const SizedBox(height: 24),
          LoginButton(isLoading: isLoading, onPressed: onLogin),
          const SizedBox(height: 24),
          // Pas d'inscription : les accès sont fournis par Baobabe.
          const Center(
            child: Text(
              'Accès réservé aux commerces partenaires.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
