import 'package:baobab_business/features/inventory/domain/entities/inventory_item.dart';
import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_inventory.dart';
import '../../domain/usecases/update_item_availability.dart';
import '../../domain/usecases/update_item_price.dart';
import '../../domain/usecases/create_inventory_item.dart';
import '../../domain/usecases/update_inventory_item.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetInventory getInventory;
  final UpdateItemAvailability updateItemAvailability;
  final UpdateItemPrice updateItemPrice;
  final CreateInventoryItem createInventoryItem;
  final UpdateInventoryItem updateInventoryItem;
  List<InventoryItem> _items = []; // dernière liste connue, pour la restaurer après une erreur

  InventoryBloc({
    required this.getInventory,
    required this.updateItemAvailability,
    required this.updateItemPrice,
    required this.createInventoryItem,
    required this.updateInventoryItem,
  }) : super(InventoryInitial()) {
    on<LoadInventory>(_onLoad);
    on<ToggleAvailability>(_onToggle);
    on<UpdateItemPriceEvent>(_onUpdatePrice);
    on<CreateInventoryItemEvent>(_onCreate);
    on<UpdateInventoryItemEvent>(_onUpdate);
  }

  Future<void> _onLoad(LoadInventory event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await getInventory(event.businessId);
    result.fold((f) => emit(InventoryError(f.message)), (items) { _items = items; emit(InventoryLoaded(items)); });
  }

  Future<void> _onToggle(ToggleAvailability event, Emitter<InventoryState> emit) async {
    final result = await updateItemAvailability(event.businessId, event.itemId, event.isAvailable);
    result.fold((f) => emit(InventoryError(f.message)), (_) => add(LoadInventory(event.businessId)));
  }

  Future<void> _onUpdatePrice(UpdateItemPriceEvent event, Emitter<InventoryState> emit) async {
    final result = await updateItemPrice(event.businessId, event.itemId, event.price);
    result.fold((f) => emit(InventoryError(f.message)), (_) => add(LoadInventory(event.businessId)));
  }

  Future<void> _onCreate(CreateInventoryItemEvent event, Emitter<InventoryState> emit) async {
    final result = await createInventoryItem(event.businessId, event.data);
    _afterSave(result, event.businessId, emit);
  }

  Future<void> _onUpdate(UpdateInventoryItemEvent event, Emitter<InventoryState> emit) async {
    final result = await updateInventoryItem(event.itemId, event.data);
    _afterSave(result, event.businessId, emit);
  }

  /// Succès : prévient le formulaire puis recharge. Échec : prévient le
  /// formulaire et remet la liste précédente (au lieu d'un écran d'erreur).
  void _afterSave(Either<Failure, void> result, String businessId, Emitter<InventoryState> emit) {
    result.fold(
      (f) { emit(InventorySaveFailed(f.message)); emit(InventoryLoaded(_items)); },
      (_) { emit(InventorySaved()); add(LoadInventory(businessId)); },
    );
  }
}
