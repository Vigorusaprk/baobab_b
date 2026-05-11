// lib/features/dashboard/domain/usecases/get_dashboard_stats.dart
import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/stats.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStats {
  final DashboardRepository repository;
  GetDashboardStats(this.repository);

  Future<Either<Failure, DashboardStats>> call(String businessId) =>
      repository.getStats(businessId); // ✅ appel correct
}