import '../../domain/entities/booking.dart';

class ReservationModel {
  final String id;
  final String businessId;
  final String userId;
  final String type;
  final DateTime reservationDate;
  final double totalAmount;
  final Map<String, dynamic> details;
  final String? customerName;
  final String? customerPhone;

  ReservationModel({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.type,
    required this.reservationDate,
    required this.totalAmount,
    required this.details,
    this.customerName,
    this.customerPhone,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) => ReservationModel(
    id: json['id'].toString(),
    businessId: json['business_id'].toString(),
    userId: json['user_id'].toString(),
    type: json['type'],
    reservationDate: DateTime.parse(json['reservation_date']),
    totalAmount: _toDouble(json['total_amount']),
    details: json['details'] ?? {},
    customerName: json['customer_name'] ?? json['details']?['customer_name'],
    customerPhone: json['customer_phone'] ?? json['details']?['phone'],
  );

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Booking toBooking() => Booking(
    id: id,
    type: type,
    customerName: customerName ?? '',
    customerPhone: customerPhone ?? '',
    date: reservationDate,
    totalAmount: totalAmount,
    status: BookingStatus.pending,
    details: details,
  );
}