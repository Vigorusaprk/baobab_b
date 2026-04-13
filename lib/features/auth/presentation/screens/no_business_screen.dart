import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class NoBusinessScreen extends StatelessWidget {
  const NoBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Baobabe Business'), backgroundColor: Colors.green),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_basket, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Bienvenue ${user.name} !'),
            const Text('Aucun commerce associé.'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}