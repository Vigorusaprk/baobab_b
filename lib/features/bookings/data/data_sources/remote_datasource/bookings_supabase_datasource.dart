import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/booking.dart';
import '../models/order_model.dart';
import '../models/reservation_model.dart';
import 'bookings_remote_datasource.dart';

/// Implémentation Supabase pour les réservations et commandes marchandes.
///
/// Elle utilise les Edge Functions Supabase :
/// - `get-merchant-space` pour récupérer commandes et réservations réelles.
/// - `update-order-status` pour changer le statut d'une commande.
/// - `update-reservation-status` pour confirmer ou refuser une réservation.
class BookingsSupabaseDataSourceImpl implements BookingsRemoteDataSource {
  final SupabaseClient _supabase;

  BookingsSupabaseDataSourceImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<OrderModel>> getOrders(
    String businessId, {
    String? status,
    int page = 1,
  }) async {
    final response = await _supabase.functions.invoke(
      'get-merchant-space',
      method: HttpMethod.get,
    );

    if (response.status != 200 || response.data == null) {
      return <OrderModel>[];
    }

    final data = response.data as Map<String, dynamic>;
    final rawOrders = (data['receivedOrders'] as List<dynamic>?) ?? [];

    final orders = rawOrders.map((json) {
      final map = json as Map<String, dynamic>;
      return OrderModel(
        id: map['id']?.toString() ?? '',
        userId: map['user_id']?.toString() ?? '',
        businessId: businessId,
        status: map['status']?.toString() ?? 'pending',
        totalAmount: (map['total_amount'] is num)
            ? (map['total_amount'] as num).toDouble()
            : 0.0,
        createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ??
            DateTime.now(),
        customerName: map['customer_name']?.toString(),
        customerPhone: map['customer_phone']?.toString(),
      );
    }).toList();

    if (status != null && status.isNotEmpty) {
      return orders.where((o) => o.status == status).toList();
    }
    return orders;
  }

  @override
  Future<List<ReservationModel>> getReservations(
    String businessId, {
    String? status,
    int page = 1,
  }) async {
    final response = await _supabase.functions.invoke(
      'get-merchant-space',
      method: HttpMethod.get,
    );

    if (response.status != 200 || response.data == null) {
      return <ReservationModel>[];
    }

    final data = response.data as Map<String, dynamic>;
    final rawReservations = (data['receivedReservations'] as List<dynamic>?) ?? [];

    final reservations = rawReservations.map((json) {
      final map = json as Map<String, dynamic>;
      return ReservationModel(
        id: map['id']?.toString() ?? '',
        businessId: businessId,
        userId: map['user_id']?.toString() ?? '',
        type: map['type']?.toString() ?? 'reservation',
        reservationDate:
            DateTime.tryParse(map['reservation_date']?.toString() ?? '') ??
                DateTime.now(),
        totalAmount: (map['total_amount'] is num)
            ? (map['total_amount'] as num).toDouble()
            : 0.0,
        details: (map['details'] is Map<String, dynamic>)
            ? (map['details'] as Map<String, dynamic>)
            : {},
        customerName: map['customer_name']?.toString(),
        customerPhone: map['customer_phone']?.toString(),
      );
    }).toList();

    return reservations;
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _supabase.functions.invoke(
      'update-order-status',
      body: {
        'orderId': orderId,
        'status': status,
      },
    );
  }

  @override
  Future<void> updateReservationStatus(
    String reservationId,
    String status,
  ) async {
    await _supabase.functions.invoke(
      'update-reservation-status',
      body: {
        'reservationId': reservationId,
        'status': status,
      },
    );
  }
}
