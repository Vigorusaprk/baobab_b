part of 'bookings_bloc.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();
  @override List<Object> get props => [];
}
class BookingsInitial extends BookingsState {}
class BookingsLoading extends BookingsState {}
class BookingsLoaded extends BookingsState {
  final List<Booking> bookings;
  const BookingsLoaded(this.bookings);
  @override List<Object> get props => [bookings];
}
class BookingsError extends BookingsState {
  final String message;
  const BookingsError(this.message);
  @override List<Object> get props => [message];
}
class BookingStatusUpdated extends BookingsState {}
/// Un changement de statut a échoué : la liste affichée reste en place.
class BookingActionFailed extends BookingsState {
  final String message;
  const BookingActionFailed(this.message);
  @override List<Object> get props => [message];
}
