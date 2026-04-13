part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
  @override List<Object> get props => [];
}

class LoadInventory extends InventoryEvent {
  final String businessId;
  const LoadInventory(this.businessId);
  @override List<Object> get props => [businessId];
}

class ToggleAvailability extends InventoryEvent {
  final String businessId; final int itemId; final bool isAvailable;
  const ToggleAvailability(this.businessId, this.itemId, this.isAvailable);
  @override List<Object> get props => [businessId, itemId, isAvailable];
}

class UpdateItemPriceEvent extends InventoryEvent {
  final String businessId; final int itemId; final double price;
  const UpdateItemPriceEvent(this.businessId, this.itemId, this.price);
  @override List<Object> get props => [businessId, itemId, price];
}

class CreateInventoryItemEvent extends InventoryEvent {
  final String businessId; final Map<String, dynamic> data;
  const CreateInventoryItemEvent(this.businessId, this.data);
  @override List<Object> get props => [businessId, data];
}