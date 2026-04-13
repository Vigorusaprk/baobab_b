import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;
  Register(this.repository);
  Future<Either<Failure, User>> call(String name, String email, String password, String phone) {
    return repository.register(name, email, password, phone);
  }
}