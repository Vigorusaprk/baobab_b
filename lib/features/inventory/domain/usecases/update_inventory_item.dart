import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/inventory_repository.dart';

/// Modifie une offre existante (nom, prix, catégorie, description, image).
class UpdateInventoryItem {
  final InventoryRepository repository;
  UpdateInventoryItem(this.repository);
  Future<Either<Failure, void>> call(String itemId, Map<String, dynamic> data) =>
      repository.updateItem(itemId, data);
}
