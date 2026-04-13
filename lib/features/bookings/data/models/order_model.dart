import '../../domain/entities/booking.dart';

class OrderModel {
  final String id;
  final String userId;
  final String businessId;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final String? customerName;
  final String? customerPhone;

  OrderModel({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.customerName,
    this.customerPhone,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'].toString(),
    userId: json['user_id'].toString(),
    businessId: json['business_id'].toString(),
    status: json['status'],
    totalAmount: _toDouble(json['total_amount']),
    createdAt: DateTime.parse(json['created_at']),
    customerName: json['customer_name'],
    customerPhone: json['customer_phone'],
  );

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Booking toBooking() => Booking(
    id: id,
    type: 'order',
    customerName: customerName ?? '',
    customerPhone: customerPhone ?? '',
    date: createdAt,
    totalAmount: totalAmount,
    status: _mapStatus(status),
    details: {},
  );

  BookingStatus _mapStatus(String status) {
    switch (status) {
      case 'pending': return BookingStatus.pending;
      case 'confirmed': return BookingStatus.confirmed;
      case 'preparing': return BookingStatus.preparing;
      case 'ready': return BookingStatus.ready;
      case 'delivered': return BookingStatus.delivered;
      case 'cancelled': return BookingStatus.cancelled;
      default: return BookingStatus.pending;
    }
  }
}