import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, preparing, ready, delivered, cancelled }

class Booking extends Equatable {
  final String id;
  final String type; // 'order' ou 'reservation'
  final String customerName;
  final String customerPhone;
  final DateTime date;
  final double totalAmount;
  final BookingStatus status;
  final Map<String, dynamic> details;

  const Booking({required this.id, required this.type, required this.customerName, required this.customerPhone, required this.date, required this.totalAmount, required this.status, required this.details});

  @override List<Object?> get props => [id, type, status];
}