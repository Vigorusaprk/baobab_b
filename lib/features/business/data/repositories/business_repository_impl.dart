import 'package:baobab_business/features/business/domain/entities/business_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/business_repository.dart';
import '../data_sources/remote_datasource/business_remote_datasource.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessRemoteDataSource remoteDataSource;
  BusinessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Business>> getBusiness(String businessId) async {
    try {
      final business = await remoteDataSource.getBusiness(businessId);
      return Right(business);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}