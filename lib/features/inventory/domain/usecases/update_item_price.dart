import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/inventory_repository.dart';

class UpdateItemPrice {
  final InventoryRepository repository;
  UpdateItemPrice(this.repository);
  Future<Either<Failure, void>> call(String businessId, int itemId, double price) => repository.updatePrice(businessId, itemId, price);
}