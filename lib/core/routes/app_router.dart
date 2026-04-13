import 'dart:async';
import 'package:baobab_business/core/di/service_locator.dart' as di;
import 'package:baobab_business/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:baobab_business/features/auth/presentation/screens/login_screen.dart';
import 'package:baobab_business/features/auth/presentation/screens/no_business_screen.dart';
import 'package:baobab_business/features/auth/presentation/screens/register_screen.dart';
import 'package:baobab_business/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:baobab_business/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:baobab_business/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:baobab_business/features/main_screen.dart';
import 'package:baobab_business/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Listenable pour rafraîchir la route quand l'état Auth change
class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier() {
    final authBloc = di.sl<AuthBloc>();
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _authStateNotifier = AuthStateNotifier();

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: _authStateNotifier,
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    print('📍 [ROUTER] Route: ${state.matchedLocation}, AuthState: $authState');

    // Non authentifié → rediriger vers login (sauf si déjà sur login/register)
    if (authState is AuthUnauthenticated || authState is AuthInitial) {
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (!isAuthRoute) return '/login';
      return null;
    }

    // Authentifié
    if (authState is AuthAuthenticated) {
      final businessId = authState.user.businessId;
      if (businessId == null || businessId.isEmpty) {
        // Pas de commerce → redirection vers /no-business
        if (state.matchedLocation != '/no-business') return '/no-business';
        return null;
      }
      // Si on est sur une route d'authentification ou /no-business, aller vers /dashboard
      final isAuthOrNoBiz = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/no-business';
      if (isAuthOrNoBiz) return '/dashboard';
    }
    return null;
  },
  routes: [
    // Routes publiques
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/no-business',
      name: 'no-business',
      builder: (context, state) => const NoBusinessScreen(),
    ),
    // Route principale avec shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Récupérer le businessId une seule fois ici
        final authState = context.read<AuthBloc>().state;
        final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : '';
        return MainScreen(
          navigationShell: navigationShell,
          businessId: businessId,
        );
      },
      branches: [
        // Branche Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state;
                final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : '';
                return DashboardScreen(businessId: businessId);
              },
            ),
          ],
        ),
        // Branche Stock
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              name: 'inventory',
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state;
                final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : '';
                return InventoryScreen(businessId: businessId);
              },
            ),
          ],
        ),
        // Branche Commandes
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookings',
              name: 'bookings',
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state;
                final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : '';
                return BookingsScreen(businessId: businessId);
              },
            ),
          ],
        ),
        // Branche Profil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state;
                final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : '';
                return ProfileScreen(businessId: businessId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);