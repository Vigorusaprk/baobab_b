import 'package:baobab_business/core/merchant/merchant_parsing.dart';
import '../../domain/entities/booking.dart';

/// Une commande reçue, telle que renvoyée par `get-merchant-space`.
class OrderModel {
  final String id;
  final String userId;
  final String businessId;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final String? customerName;
  final String? customerPhone;
  final String? notes;

  /// Lignes de la commande : {item_name, quantity, price}.
  final List<Map<String, dynamic>> lines;

  OrderModel({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.customerName,
    this.customerPhone,
    this.notes,
    this.lines = const [],
  });

  /// Construit depuis une ligne de `orders` (client = objet `customer`).
  factory OrderModel.fromRow(Map<String, dynamic> row, String businessId) {
    final customer = customerOf(row);
    return OrderModel(
      id: row['id'].toString(),
      userId: row['user_id']?.toString() ?? '',
      businessId: businessId,
      status: row['status']?.toString() ?? 'pending',
      totalAmount: asDouble(row['total_amount'] ?? row['total_price']),
      createdAt: asInstant(row['created_at']) ?? DateTime.now(),
      customerName: customer.name,
      customerPhone: customer.phone,
      notes: row['notes']?.toString(),
      lines: asRows(row['order_items']),
    );
  }

  /// Conservé pour l'ancien datasource Dio (code mort).
  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      OrderModel.fromRow(json, json['business_id']?.toString() ?? '');

  Booking toBooking() => Booking(
        id: id,
        type: 'order',
        customerName: customerName ?? '',
        customerPhone: customerPhone ?? '',
        date: createdAt,
        totalAmount: totalAmount,
        status: _mapStatus(status),
        details: {'lines': lines, 'notes': notes},
      );

  static BookingStatus _mapStatus(String s) {
    switch (s) {
      case 'confirmed': return BookingStatus.confirmed;
      case 'preparing': return BookingStatus.preparing;
      case 'ready': return BookingStatus.ready;
      case 'delivered': return BookingStatus.delivered;
      case 'cancelled': return BookingStatus.cancelled;
      default: return BookingStatus.pending;
    }
  }
}
