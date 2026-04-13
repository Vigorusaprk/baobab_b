import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/features/inventory/data/data_sources/remote_datasource/inventory_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;
  InventoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<InventoryItem>>> getInventory(String businessId) async {
    try {
      final items = await remoteDataSource.getInventory(businessId);
      return Right(items.map((e) => e.toEntity()).toList());
    } catch (e) { return Left(ServerFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, void>> updateAvailability(String businessId, int itemId, bool isAvailable) async {
    try { await remoteDataSource.updateItemAvailability(businessId, itemId, isAvailable); return const Right(null); }
    catch (e) { return Left(ServerFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, void>> updatePrice(String businessId, int itemId, double price) async {
    try { await remoteDataSource.updateItemPrice(businessId, itemId, price); return const Right(null); }
    catch (e) { return Left(ServerFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, void>> createItem(String businessId, Map<String, dynamic> data) async {
    try { await remoteDataSource.createItem(businessId, data); return const Right(null); }
    catch (e) { return Left(ServerFailure(e.toString())); }
  }
}