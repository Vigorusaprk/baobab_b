import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<InventoryItem>>> getInventory(String businessId);
  Future<Either<Failure, void>> updateAvailability(String businessId, String itemId, bool isAvailable);
  Future<Either<Failure, void>> updatePrice(String businessId, String itemId, double price);
  Future<Either<Failure, void>> createItem(String businessId, Map<String, dynamic> data);
  Future<Either<Failure, void>> updateItem(String itemId, Map<String, dynamic> data);
}