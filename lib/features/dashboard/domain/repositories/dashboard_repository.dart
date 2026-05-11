import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/stats.dart';
import '../entities/product_sale.dart';
import '../entities/recent_order.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getStats(String businessId);
  Future<Either<Failure, List<ProductSale>>> getProductSales(String businessId);
  Future<Either<Failure, List<RecentOrder>>> getRecentOrders(String businessId);
}