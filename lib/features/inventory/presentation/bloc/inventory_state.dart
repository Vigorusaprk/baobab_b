part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();
  @override List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}
class InventoryLoading extends InventoryState {}
class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;
  const InventoryLoaded(this.items);
  @override List<Object> get props => [items];
}
class InventoryError extends InventoryState {
  final String message;
  const InventoryError(this.message);
  @override List<Object> get props => [message];
}

/// Enregistrement réussi : le formulaire peut se fermer.
class InventorySaved extends InventoryState {}

/// Enregistrement refusé : le formulaire reste ouvert et affiche le message.
class InventorySaveFailed extends InventoryState {
  final String message;
  const InventorySaveFailed(this.message);
  @override List<Object> get props => [message];
}
