part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email, password;
  const LoginRequested(this.email, this.password);
  @override List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name, email, password, phone;
  const RegisterRequested(this.name, this.email, this.password, this.phone);
  @override List<Object> get props => [name, email, password, phone];
}

class CheckAuthStatusRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}