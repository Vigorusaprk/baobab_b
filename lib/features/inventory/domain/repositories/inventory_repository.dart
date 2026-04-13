import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<InventoryItem>>> getInventory(String businessId);
  Future<Either<Failure, void>> updateAvailability(String businessId, int itemId, bool isAvailable);
  Future<Either<Failure, void>> updatePrice(String businessId, int itemId, double price);
  Future<Either<Failure, void>> createItem(String businessId, Map<String, dynamic> data);
}