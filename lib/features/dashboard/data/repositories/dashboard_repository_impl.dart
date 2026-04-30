import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/features/dashboard/data/data_sources/remote_datasource/dashboard_remote_datasource.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/sales_pie_chart.dart';
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
  @override
  Future<List<ProductSalesData>> getProductSales(String businessId) async {
    try {
      final response = await dio.get('$baseUrl/businesses/$businessId/sales-stats');
      final List data = response.data;
      return data.map((json) => ProductSalesData(
        productName: json['product_name'],
        salesAmount: (json['total_revenue'] as num).toDouble(),
      )).toList();
    } catch (e) {
      // Si l'API n'est pas encore prête, retourner une liste vide pour éviter de bloquer l'UI
      return [];
    }
  }
}