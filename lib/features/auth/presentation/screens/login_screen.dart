import 'dart:ui';

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _obscure = true;

  void _onLogin() {
    final email = _emailCtrl.text.trim();
    final password = _pwdCtrl.text.trim();
    print('🔐 [LOGIN_SCREEN] Tentative de connexion avec : $email');
    if (email.isEmpty || password.isEmpty) {
      print('⚠️ [LOGIN_SCREEN] Champs vides');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }
    context.read<AuthBloc>().add(LoginRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return authBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                print('🔊 [LOGIN_SCREEN] Nouvel état : $state');
                if (state is AuthAuthenticated) {
                  print('✅ [LOGIN_SCREEN] Authentifié, redirection...');
                  final businessId = state.user.businessId;
                  if (businessId != null && businessId.isNotEmpty) {
                    context.go('/dashboard');
                  } else {
                    context.go('/no-business');
                  }
                } else if (state is AuthError) {
                  print('❌ [LOGIN_SCREEN] Erreur : ${state.message}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.login,
                                size:
                                    MediaQuery.of(context).size.width *
                                    0.15, // 15% de la largeur
                                color: AppColors.scaffoldBackground,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Heureux de vous revoir',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.07,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                      softWrap: true,
                                    ),

                                    Text(
                                      "Conecter vous avotre compte pour continué l'avnture ",
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
                    ),
                    const SizedBox(height: 48),
                    TextField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.scaffoldBackground,
                        labelText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1A371F), width: 2.5,),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _pwdCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.scaffoldBackground,
                        labelText: 'Mot de passe',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1A371F), width: 2.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading ? null : _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Se connecter',
                                style: TextStyle(fontSize: 16, color: AppColors.scaffoldBackground),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text('Créer un compte', style: TextStyle(fontSize: 16, color: AppColors.primary),),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
