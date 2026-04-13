import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';

class GetInventory {
  final InventoryRepository repository;
  GetInventory(this.repository);
  Future<Either<Failure, List<InventoryItem>>> call(String businessId) => repository.getInventory(businessId);
}