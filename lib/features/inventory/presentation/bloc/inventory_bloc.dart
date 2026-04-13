import 'package:baobab_business/features/inventory/domain/entities/inventory_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_inventory.dart';
import '../../domain/usecases/update_item_availability.dart';
import '../../domain/usecases/update_item_price.dart';
import '../../domain/usecases/create_inventory_item.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetInventory getInventory;
  final UpdateItemAvailability updateItemAvailability;
  final UpdateItemPrice updateItemPrice;
  final CreateInventoryItem createInventoryItem;

  InventoryBloc({
    required this.getInventory,
    required this.updateItemAvailability,
    required this.updateItemPrice,
    required this.createInventoryItem,
  }) : super(InventoryInitial()) {
    on<LoadInventory>(_onLoad);
    on<ToggleAvailability>(_onToggle);
    on<UpdateItemPriceEvent>(_onUpdatePrice);
    on<CreateInventoryItemEvent>(_onCreate);
  }

  Future<void> _onLoad(LoadInventory event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await getInventory(event.businessId);
    result.fold((f) => emit(InventoryError(f.message)), (items) => emit(InventoryLoaded(items)));
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
    result.fold((f) => emit(InventoryError(f.message)), (_) => add(LoadInventory(event.businessId)));
  }
}