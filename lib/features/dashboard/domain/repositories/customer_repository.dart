import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<Customer>>> getCustomers(String businessId, {int page = 1, int limit = 20});
  Future<Either<Failure, int>> getTotalCustomersCount(String businessId);
}