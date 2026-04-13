import 'package:baobab_business/features/business/domain/entities/business_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';


abstract class BusinessRepository {
  Future<Either<Failure, Business>> getBusiness(String businessId);
}