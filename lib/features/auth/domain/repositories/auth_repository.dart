import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String name, String email, String password, String phone);
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> logout();
}