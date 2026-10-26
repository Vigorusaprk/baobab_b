import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Champ de saisie plat et réutilisable (email ou mot de passe).
///
/// Si [isPassword] est vrai, le texte est masqué et un bouton œil
/// permet de l'afficher. Le champ gère lui-même cet état.
class LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String> autofillHints;
  final ValueChanged<String>? onSubmitted;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.autofillHints = const [],
    this.onSubmitted,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _hidden = true;

  // Bordure unique, seule la couleur/épaisseur change selon l'état.
  OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _hidden,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      onSubmitted: widget.onSubmitted,
      autocorrect: false,
      enableSuggestions: !widget.isPassword,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 15),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        floatingLabelStyle: const TextStyle(color: AppColors.secondary),
        prefixIcon: Icon(widget.icon, size: 20, color: AppColors.textMuted),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _hidden ? 'Afficher' : 'Masquer',
                icon: Icon(
                  _hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.textMuted,
                ),
                onPressed: () => setState(() => _hidden = !_hidden),
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: _border(AppColors.primaryDark),
        enabledBorder: _border(AppColors.primaryDark),
        focusedBorder: _border(AppColors.secondary, 1.5),
      ),
    );
  }
}
