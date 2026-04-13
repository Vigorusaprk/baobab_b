import 'package:baobab_business/features/auth/domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final CheckAuthStatus checkAuthStatus;
  final Logout logout;

  AuthBloc({
    required this.login,
    required this.register,
    required this.checkAuthStatus,
    required this.logout,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    print('📡 [AUTH_BLOC] LoginRequested reçu : ${event.email}');
    emit(AuthLoading());
    final result = await login(event.email, event.password);
    print('📦 [AUTH_BLOC] Résultat de login : $result');
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    print('📡 [AUTH_BLOC] RegisterRequested reçu : ${event.email}');
    emit(AuthLoading());
    final result = await register(event.name, event.email, event.password, event.phone);
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onCheckAuthStatusRequested(CheckAuthStatusRequested event, Emitter<AuthState> emit) async {
    print('🔍 [AUTH_BLOC] Vérification du statut d’authentification...');
    emit(AuthLoading());
    final result = await checkAuthStatus();
    print('📦 [AUTH_BLOC] Résultat checkAuthStatus : $result');
    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    print('🚪 [AUTH_BLOC] Déconnexion demandée');
    await logout();
    emit(AuthUnauthenticated());
  }
}