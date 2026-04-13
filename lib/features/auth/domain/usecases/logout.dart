import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;
  Logout(this.repository);
  Future<Either<Failure, void>> call() => repository.logout();
}