// lib/features/dashboard/domain/usecases/get_product_sales.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/product_sale.dart';
import '../repositories/dashboard_repository.dart';

class GetProductSales {
  final DashboardRepository repository;
  GetProductSales(this.repository);

  Future<Either<Failure, List<ProductSale>>> call(String businessId) {
    return repository.getProductSales(businessId);
  }
}