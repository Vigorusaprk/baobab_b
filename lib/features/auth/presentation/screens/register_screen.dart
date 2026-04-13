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

  @override
  Widget build(BuildContext context) {
    return authBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BackdropFilter(
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
                              Icons.person,
                              size:
                                  MediaQuery.of(context).size.width *
                                  0.15, // 15% de la largeur
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
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          0.07,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                    softWrap: true,
                                  ),

                                  Text(
                                    "Créér un compte pour commencé votre avnture ",
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
                    const SizedBox(height: 32),
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.scaffoldBackground,
                        labelText: 'Nom',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF1A371F), width: 2.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
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
                    ),
                    const SizedBox(height: 16),
                    TextField(
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
                    ),
                    const SizedBox(height: 16),
                    TextField(
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
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () => context.read<AuthBloc>().add(
                                RegisterRequested(
                                  _nameCtrl.text.trim(),
                                  _emailCtrl.text.trim(),
                                  _pwdCtrl.text.trim(),
                                  _phoneCtrl.text.trim(),
                                ),
                              ),
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
                                "S'inscrire",
                                style: TextStyle(fontSize: 16, color: AppColors.scaffoldBackground),
                              ),
                      ),
                    ),
                    if (state is AuthError)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text('Déjà un compte ? Se connecter', style: TextStyle(color: AppColors.primaryLight),),
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
