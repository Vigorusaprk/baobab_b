part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();
  @override List<Object> get props => [];
}
class LoadBookings extends BookingsEvent {
  final String businessId; final String? type; final String? status;
  const LoadBookings(this.businessId, {this.type, this.status});
  @override List<Object> get props => [businessId, type ?? '', status ?? ''];
}
class UpdateBookingStatusEvent extends BookingsEvent {
  final String id, type, status;
  const UpdateBookingStatusEvent(this.id, this.type, this.status);
  @override List<Object> get props => [id, type, status];
}