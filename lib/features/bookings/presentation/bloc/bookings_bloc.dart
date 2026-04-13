import 'package:baobab_business/features/bookings/domain/entities/booking.dart';
import 'package:baobab_business/features/bookings/domain/usecases/get_bookings.dart';
import 'package:baobab_business/features/bookings/domain/usecases/update_booking_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetBookings getBookings;
  final UpdateBookingStatus updateBookingStatus;

  BookingsBloc({required this.getBookings, required this.updateBookingStatus}) : super(BookingsInitial()) {
    on<LoadBookings>(_onLoad);
    on<UpdateBookingStatusEvent>(_onUpdate);
  }

  Future<void> _onLoad(LoadBookings event, Emitter<BookingsState> emit) async {
    emit(BookingsLoading());
    final result = await getBookings(event.businessId, type: event.type, status: event.status);
    result.fold((f) => emit(BookingsError(f.message)), (b) => emit(BookingsLoaded(b)));
  }

  Future<void> _onUpdate(UpdateBookingStatusEvent event, Emitter<BookingsState> emit) async {
    final result = await updateBookingStatus(event.id, event.type, event.status);
    result.fold((f) => emit(BookingsError(f.message)), (_) => emit(BookingStatusUpdated()));
  }
}