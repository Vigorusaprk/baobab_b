import 'package:baobab_business/core/merchant/merchant_parsing.dart';
import '../../domain/entities/booking.dart';

/// Une réservation reçue, telle que renvoyée par `get-merchant-space`.
class ReservationModel {
  final String id;
  final String businessId;
  final String userId;
  final String status;
  final String itemName;
  final int quantity;
  final DateTime reservationDate;
  final double totalAmount;
  final String? customerName;
  final String? customerPhone;

  ReservationModel({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.status,
    required this.itemName,
    required this.quantity,
    required this.reservationDate,
    required this.totalAmount,
    this.customerName,
    this.customerPhone,
  });

  /// Construit depuis une ligne de `reservations` (client = objet `customer`).
  factory ReservationModel.fromRow(Map<String, dynamic> row, String businessId) {
    final customer = customerOf(row);
    return ReservationModel(
      id: row['id'].toString(),
      businessId: businessId,
      userId: row['user_id']?.toString() ?? '',
      status: row['status']?.toString() ?? 'pending',
      itemName: row['item_name']?.toString() ?? 'Réservation',
      quantity: asInt(row['quantity']) == 0 ? 1 : asInt(row['quantity']),
      reservationDate: asInstant(row['reservation_date']) ?? DateTime.now(),
      totalAmount: asDouble(row['total_amount']),
      customerName: customer.name,
      customerPhone: customer.phone,
    );
  }

  /// Conservé pour l'ancien datasource Dio (code mort).
  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      ReservationModel.fromRow(json, json['business_id']?.toString() ?? '');

  Booking toBooking() => Booking(
        id: id,
        type: 'reservation',
        customerName: customerName ?? '',
        customerPhone: customerPhone ?? '',
        date: reservationDate,
        totalAmount: totalAmount,
        status: _mapStatus(status),
        details: {'item_name': itemName, 'quantity': quantity},
      );

  static BookingStatus _mapStatus(String s) {
    switch (s) {
      case 'confirmed': return BookingStatus.confirmed;
      case 'completed': return BookingStatus.completed;
      case 'cancelled': return BookingStatus.cancelled;
      default: return BookingStatus.pending;
    }
  }
}
