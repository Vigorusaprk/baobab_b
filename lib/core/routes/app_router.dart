import 'dart:async';
import 'package:baobab_business/core/di/service_locator.dart' as di; //[cite: 19]
import 'package:baobab_business/features/auth/presentation/bloc/auth_bloc.dart'; //[cite: 19]
import 'package:baobab_business/features/auth/presentation/screens/login_screen.dart'; //[cite: 19]
import 'package:baobab_business/features/auth/presentation/screens/no_business_screen.dart'; //[cite: 19]
import 'package:baobab_business/features/auth/presentation/screens/register_screen.dart'; //[cite: 19]
import 'package:baobab_business/features/bookings/presentation/screens/bookings_screen.dart'; //[cite: 19]
import 'package:baobab_business/features/dashboard/presentation/screens/dashboard_screen.dart'; //[cite: 19]
import 'package:baobab_business/features/inventory/presentation/screens/inventory_screen.dart'; //[cite: 19]
import 'package:baobab_business/features/main/presentation/screens/main_screen.dart'; //[cite: 19]
import 'package:baobab_business/features/profile/presentation/screens/profile_screen.dart'; //[cite: 19]
import 'package:flutter/material.dart'; //[cite: 19]
import 'package:flutter_bloc/flutter_bloc.dart'; //[cite: 19]
import 'package:go_router/go_router.dart'; //[cite: 19]

// Listenable pour rafraîchir la route quand l'état Auth change[cite: 19]
class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier() {
    final authBloc = di.sl<AuthBloc>(); //[cite: 19]
    _subscription = authBloc.stream.listen((_) => notifyListeners()); //[cite: 19]
  }
  late final StreamSubscription _subscription; //[cite: 19]

  @override
  void dispose() {
    _subscription.cancel(); //[cite: 19]
    super.dispose(); //[cite: 19]
  }
}

final _authStateNotifier = AuthStateNotifier(); //[cite: 19]

final GoRouter appRouter = GoRouter(
  initialLocation: '/login', //[cite: 19]
  refreshListenable: _authStateNotifier, //[cite: 19]
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state; //[cite: 19]
    print('📍 [ROUTER] Route: ${state.matchedLocation}, AuthState: $authState'); //[cite: 19]

    // ✅ CORRECTION : On ne cible plus AuthInitial ici pour éviter l'expulsion au Hot Reload
    // Non authentifié → rediriger vers login (sauf si déjà sur login/register)[cite: 19]
    if (authState is AuthUnauthenticated) {
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register'; //[cite: 19]
      if (!isAuthRoute) return '/login'; //[cite: 19]
      return null; //[cite: 19]
    }

    // Authentifié[cite: 19]
    if (authState is AuthAuthenticated) {
      final businessId = authState.user.businessId; //[cite: 19]
      if (businessId == null || businessId.isEmpty) { //[cite: 19]
        // Pas de commerce → redirection vers /no-business[cite: 19]
        if (state.matchedLocation != '/no-business') return '/no-business'; //[cite: 19]
        return null; //[cite: 19]
      }
      // Si on est sur une route d'authentification ou /no-business, aller vers /dashboard[cite: 19]
      final isAuthOrNoBiz = state.matchedLocation == '/login' || //[cite: 19]
          state.matchedLocation == '/register' || //[cite: 19]
          state.matchedLocation == '/no-business'; //[cite: 19]
      if (isAuthOrNoBiz) return '/dashboard'; //[cite: 19]
    }

    // Si l'état est AuthInitial ou AuthLoading, on reste neutre (on attend la vérification)[cite: 7, 19]
    return null; //[cite: 19]
  },
  routes: [
    // Routes publiques[cite: 19]
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(), //[cite: 19]
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(), //[cite: 19]
    ),
    GoRoute(
      path: '/no-business',
      name: 'no-business',
      builder: (context, state) => const NoBusinessScreen(), //[cite: 19]
    ),
    // Route principale avec shell[cite: 19]
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Récupérer le businessId une seule fois ici[cite: 19]
        final authState = context.read<AuthBloc>().state; //[cite: 19]
        final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : ''; //[cite: 19]
        return MainScreen(
          navigationShell: navigationShell, //[cite: 19]
          businessId: businessId, //[cite: 19]
        );
      },
      branches: [
        // Branche Dashboard[cite: 19]
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state; //[cite: 19]
                final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : ''; //[cite: 19]
                return DashboardScreen(businessId: businessId); //[cite: 19]
              },
            ),
          ],
        ),
        // Branche Stock[cite: 19]
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              name: 'inventory',
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state; //[cite: 19]
                final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : ''; //[cite: 19]
                return InventoryScreen(businessId: businessId); //[cite: 19]
              },
            ),
          ],
        ),
        // Branche Commandes[cite: 19]
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookings',
              name: 'bookings',
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state; //[cite: 19]
                final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : ''; //[cite: 19]
                return BookingsScreen(businessId: businessId); //[cite: 19]
              },
            ),
          ],
        ),
        // Branche Profil[cite: 19]
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state; //[cite: 19]
                final businessId = (authState is AuthAuthenticated) ? authState.user.businessId ?? '' : ''; //[cite: 19]
                return ProfileScreen(businessId: businessId); //[cite: 19]
              },
            ),
          ],
        ),
      ],
    ),
  ],
);