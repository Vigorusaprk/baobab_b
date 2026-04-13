import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  final String businessId;
  const ProfileScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            Text(user.name, style: const TextStyle(fontSize: 24)),
            Text(user.email),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
              icon: const Icon(Icons.logout), label: const Text('Se déconnecter'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}