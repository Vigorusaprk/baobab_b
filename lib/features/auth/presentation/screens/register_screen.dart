import 'dart:ui';

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _obscure = true;

  void _onRegister() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final password = _pwdCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      RegisterRequested(name, email, password, phone),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return isTablet ? _buildTabletLayout() : _buildMobileLayout();
  }

  // ---------- BLOC CONSUMER COMMUN ----------
  Widget _buildBlocConsumer({
    required Widget Function(BuildContext context, AuthState state) builder,
  }) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final businessId = state.user.businessId;
          if (businessId != null && businessId.isNotEmpty) {
            context.go('/dashboard');
          } else {
            context.go('/no-business');
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: builder,
    );
  }

  // ---------- LAYOUT MOBILE ----------
  Widget _buildMobileLayout() {
    return authBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildBlocConsumer(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMobileHeader(),
                    const SizedBox(height: 32),
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPhoneField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 24),
                    _buildRegisterButton(state),
                    if (state is AuthError)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _buildLoginLink(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ---------- LAYOUT TABLETTE ----------
  Widget _buildTabletLayout() {
    return authBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            // Partie gauche : branding / illustration
            Expanded(
              flex: 1,
              child: Container(
                color: AppColors.primaryDark.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.app_registration,
                        size: 100,
                        color: AppColors.scaffoldBackground,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Rejoignez Baobab',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.scaffoldBackground,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Créez votre compte professionnel\nen quelques instants',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.scaffoldBackground.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Partie droite : formulaire
            Expanded(
              flex: 1,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: _buildBlocConsumer(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTabletHeader(),
                          const SizedBox(height: 32),
                          _buildNameField(),
                          const SizedBox(height: 16),
                          _buildEmailField(),
                          const SizedBox(height: 16),
                          _buildPhoneField(),
                          const SizedBox(height: 16),
                          _buildPasswordField(),
                          const SizedBox(height: 24),
                          _buildRegisterButton(state),
                          if (state is AuthError)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 16),
                          _buildLoginLink(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- WIDGETS D'EN-TÊTE ----------
  Widget _buildMobileHeader() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 17, sigmaY: 17),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.scaffoldBackground,
              width: 2.5,
            ),
            color: Colors.green.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: MediaQuery.of(context).size.width * 0.15,
                color: AppColors.scaffoldBackground,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenue',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      "Créez un compte pour commencer l'aventure",
                      style: TextStyle(
                        color: AppColors.scaffoldBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletHeader() {
    return Column(
      children: [
        Icon(
          Icons.person_add,
          size: 60,
          color: AppColors.primaryDark,
        ),
        const SizedBox(height: 16),
        Text(
          'Inscription',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Remplissez les informations ci-dessous',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primaryDark.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // ---------- CHAMPS DE FORMULAIRE ----------
  Widget _buildNameField() {
    return TextField(
      controller: _nameCtrl,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.scaffoldBackground,
        labelText: 'Nom complet',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1A371F), width: 2.5),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailCtrl,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.scaffoldBackground,
        labelText: 'Email',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1A371F), width: 2.5),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneCtrl,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.scaffoldBackground,
        labelText: 'Téléphone',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1A371F), width: 2.5),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _pwdCtrl,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        filled: true,
        fillColor: AppColors.scaffoldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1A371F), width: 2.5),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: state is AuthLoading ? null : _onRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state is AuthLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          "S'inscrire",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.scaffoldBackground,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () => context.go('/login'),
      child: Text(
        'Déjà un compte ? Se connecter',
        style: TextStyle(color: AppColors.primaryLight),
      ),
    );
  }
}
