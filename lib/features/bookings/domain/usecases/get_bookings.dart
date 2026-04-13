import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/booking.dart';
import '../repositories/bookings_repository.dart';

class GetBookings {
  final BookingsRepository repository;

  GetBookings(this.repository);

  Future<Either<Failure, List<Booking>>> call(String businessId, {String? type, String? status, int page = 1}) {
    return repository.getBookings(businessId, type: type, status: status, page: page);
  }
}