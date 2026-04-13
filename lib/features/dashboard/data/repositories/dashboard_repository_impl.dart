import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/features/dashboard/data/data_sources/remote_datasource/dashboard_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/stats.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  DashboardRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats(String businessId) async {
    try {
      final stats = await remoteDataSource.getDashboardStats(businessId);
      return Right(stats.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}