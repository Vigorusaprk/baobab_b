import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'package:baobab_business/core/merchant/merchant_parsing.dart';
import '../../models/order_model.dart';
import '../../models/reservation_model.dart';
import 'bookings_remote_datasource.dart';

/// Commandes et réservations reçues, via l'Edge Function `get-merchant-space`
/// (clés `orders` et `reservations`). Le commerce est déduit côté serveur
/// de la ligne `business_staff` : le client ne le transmet jamais.
class BookingsSupabaseDataSourceImpl implements BookingsRemoteDataSource {
  final MerchantApi _api;

  BookingsSupabaseDataSourceImpl({MerchantApi? api})
      : _api = api ?? MerchantApi.instance;

  @override
  Future<List<OrderModel>> getOrders(
    String businessId, {
    String? status,
    int page = 1,
  }) async {
    final data = await _api.space();
    final orders = asRows(data['orders'])
        .map((row) => OrderModel.fromRow(row, businessId))
        .toList();
    if (status == null || status.isEmpty) return orders;
    return orders.where((o) => o.status == status).toList();
  }

  @override
  Future<List<ReservationModel>> getReservations(
    String businessId, {
    String? status,
    int page = 1,
  }) async {
    final data = await _api.space();
    final reservations = asRows(data['reservations'])
        .map((row) => ReservationModel.fromRow(row, businessId))
        .toList();
    if (status == null || status.isEmpty) return reservations;
    return reservations.where((r) => r.status == status).toList();
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _api.call('update-order-status', {
      'orderId': orderId,
      'status': status,
    });
  }

  @override
  Future<void> updateReservationStatus(String reservationId, String status) async {
    await _api.call('update-reservation-status', {
      // L'identifiant d'une réservation est un entier en base : l'envoyer
      // en texte fait échouer la comparaison côté serveur.
      'reservationId': int.tryParse(reservationId) ?? reservationId,
      'status': status,
    });
  }
}
