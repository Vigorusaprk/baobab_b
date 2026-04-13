import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/features/bookings/data/data_sources/remote_datasource/bookings_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource remoteDataSource;
  BookingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Booking>>> getBookings(String businessId, {String? type, String? status, int page = 1}) async {
    try {
      List<Booking> bookings = [];
      if (type == null || type == 'order') {
        final orders = await remoteDataSource.getOrders(businessId, status: status, page: page);
        bookings.addAll(orders.map((o) => o.toBooking()));
      }
      if (type == null || type == 'reservation') {
        final reservations = await remoteDataSource.getReservations(businessId, type: status, page: page);
        bookings.addAll(reservations.map((r) => r.toBooking()));
      }
      bookings.sort((a,b) => b.date.compareTo(a.date));
      return Right(bookings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBookingStatus(String id, String type, String status) async {
    try {
      if (type == 'order') await remoteDataSource.updateOrderStatus(id, status);
      else await remoteDataSource.updateReservationStatus(id, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}