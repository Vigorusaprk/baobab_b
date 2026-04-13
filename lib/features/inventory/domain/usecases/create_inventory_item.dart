import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/inventory_repository.dart';

class CreateInventoryItem {
  final InventoryRepository repository;
  CreateInventoryItem(this.repository);
  Future<Either<Failure, void>> call(String businessId, Map<String, dynamic> data) => repository.createItem(businessId, data);
}