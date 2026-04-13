import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/booking.dart';

abstract class BookingsRepository {
  Future<Either<Failure, List<Booking>>> getBookings(String businessId, {String? type, String? status, int page = 1});
  Future<Either<Failure, void>> updateBookingStatus(String id, String type, String status);
}