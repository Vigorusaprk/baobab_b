import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/features/dashboard/domain/entities/product_sale.dart';
import 'package:baobab_business/features/dashboard/domain/entities/recent_order.dart';
import 'package:baobab_business/features/dashboard/domain/entities/stats.dart';
import 'package:baobab_business/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';
import '../data_sources/remote_datasource/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardStats>> getStats(String businessId) async {
    try {
      final statsModel = await remoteDataSource.getStats(businessId);
      return Right(statsModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductSale>>> getProductSales(String businessId) async {
    try {
      final models = await remoteDataSource.getProductSales(businessId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecentOrder>>> getRecentOrders(String businessId) async {
    try {
      final models = await remoteDataSource.getRecentOrders(businessId);
      return Right(models.map((m) => m as RecentOrder).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}