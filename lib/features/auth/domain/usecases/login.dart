import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  Login(this.repository);
  Future<Either<Failure, User>> call(String email, String password) => repository.login(email, password);
}