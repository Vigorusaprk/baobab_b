import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_error_banner.dart';
import '../widgets/login_form.dart';

/// Écran de connexion de l'espace professionnel.
///
/// Un seul layout, centré et limité à 420 px de large : il s'adapte
/// donc au téléphone comme à la tablette, et reste défilable quand le
/// clavier est ouvert. Il n'y a pas de création de compte : les accès
/// sont fournis par Baobabe aux commerces partenaires.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  String? _localError; // Erreur de saisie (champs vides)

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  /// Valide la saisie puis demande la connexion au Bloc.
  void _onLogin() {
    final email = _emailCtrl.text.trim();
    final password = _pwdCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _localError = 'Veuillez remplir tous les champs.');
      return;
    }
    setState(() => _localError = null);
    TextInput.finishAutofillContext(); // Propose d'enregistrer l'identifiant
    context.read<AuthBloc>().add(LoginRequested(email, password));
  }

  /// Redirige selon que le compte possède un commerce ou non.
  void _onAuthChange(BuildContext context, AuthState state) {
    if (state is! AuthAuthenticated) return;
    final hasBusiness = (state.user.businessId ?? '').isNotEmpty;
    context.go(hasBusiness ? '/dashboard' : '/no-business');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: box.maxHeight - 64),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: _onAuthChange,
                    builder: (context, state) => LoginForm(
                      emailCtrl: _emailCtrl,
                      pwdCtrl: _pwdCtrl,
                      isLoading: state is AuthLoading,
                      error: _localError ??
                          (state is AuthError
                              ? friendlyAuthError(state.message)
                              : null),
                      onLogin: _onLogin,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
