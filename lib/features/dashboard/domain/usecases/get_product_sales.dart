import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:baobab_business/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/sales_pie_chart.dart';

class GetProductSales {
  final DashboardRepository repository;

  GetProductSales(this.repository);

  Future<Either<Failure, List<ProductSalesData>>> call(String businessId) async {
    return await repository.getProductSales(businessId);
  }
}