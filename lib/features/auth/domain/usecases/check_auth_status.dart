import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatus {
  final AuthRepository repository;
  CheckAuthStatus(this.repository);
  Future<Either<Failure, User>> call() => repository.getCurrentUser();
}