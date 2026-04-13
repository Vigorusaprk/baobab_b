import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository repository;
  CustomerBloc({required this.repository}) : super(CustomerInitial()) {
    on<LoadCustomers>(_onLoad);
  }

  Future<void> _onLoad(LoadCustomers event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await repository.getCustomers(event.businessId, page: event.page, limit: event.limit);
    result.fold(
          (failure) => emit(CustomerError(failure.message)),
          (customers) => emit(CustomerLoaded(customers)),
    );
  }
}