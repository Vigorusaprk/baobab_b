import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/recent_order.dart';
import '../repositories/dashboard_repository.dart';

class GetRecentOrders {
  final DashboardRepository repository;

  GetRecentOrders(this.repository);

  Future<Either<Failure, List<RecentOrder>>> call(String businessId) {
    return repository.getRecentOrders(businessId);
  }
}