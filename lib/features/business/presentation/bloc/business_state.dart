part of 'business_bloc.dart';

abstract class BusinessState extends Equatable {
  const BusinessState();
  @override List<Object> get props => [];
}

class BusinessInitial extends BusinessState {}
class BusinessLoading extends BusinessState {}
class BusinessLoaded extends BusinessState {
  final Business business;
  const BusinessLoaded(this.business);
  @override List<Object> get props => [business];
}
class BusinessError extends BusinessState {
  final String message;
  const BusinessError(this.message);
  @override List<Object> get props => [message];
}