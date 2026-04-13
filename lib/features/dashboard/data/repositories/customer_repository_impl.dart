import 'package:baobab_business/features/dashboard/data/data_sources/remote_datasource/customer_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';


class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;
  CustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Customer>>> getCustomers(String businessId, {int page = 1, int limit = 20}) async {
    try {
      final customers = await remoteDataSource.getCustomers(businessId, page: page, limit: limit);
      return Right(customers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalCustomersCount(String businessId) async {
    try {
      final count = await remoteDataSource.getTotalCustomersCount(businessId);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}