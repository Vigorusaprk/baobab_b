import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/stats.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats(String businessId);
}