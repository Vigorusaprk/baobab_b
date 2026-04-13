import 'package:baobab_business/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/bookings_repository.dart';

class UpdateBookingStatus {
  final BookingsRepository repository;

  UpdateBookingStatus(this.repository);

  Future<Either<Failure, void>> call(String id, String type, String status) {
    return repository.updateBookingStatus(id, type, status);
  }
}