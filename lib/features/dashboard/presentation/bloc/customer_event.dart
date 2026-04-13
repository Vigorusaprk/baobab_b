part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
  @override List<Object> get props => [];
}

class LoadCustomers extends CustomerEvent {
  final String businessId;
  final int page;
  final int limit;
  const LoadCustomers(this.businessId, {this.page = 1, this.limit = 20});
  @override List<Object> get props => [businessId, page, limit];
}