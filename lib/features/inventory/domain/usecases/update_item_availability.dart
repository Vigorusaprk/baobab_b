import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/inventory_repository.dart';

class UpdateItemAvailability {
  final InventoryRepository repository;
  UpdateItemAvailability(this.repository);
  Future<Either<Failure, void>> call(String businessId, int itemId, bool isAvailable) => repository.updateAvailability(businessId, itemId, isAvailable);
}