import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/stats_model.dart';
import '../../models/product_sale_model.dart';
import '../../models/recent_order_model.dart';
import 'dashboard_remote_datasource.dart';

/// Implémentation Supabase pour le tableau de bord marchand.
///
/// Directement basée sur la logique de -baobab_app_2 (Edge Function `get-merchant-space`).
class DashboardSupabaseDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseClient _supabase;

  DashboardSupabaseDataSourceImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<StatsModel> getStats(String businessId) async {
    final response = await _supabase.functions.invoke(
      'get-merchant-space',
      method: HttpMethod.get,
    );

    if (response.status != 200 || response.data == null) {
      throw Exception('Erreur lors du chargement des statistiques: ${response.status}');
    }

    final data = response.data as Map<String, dynamic>;
    final stats = (data['stats'] as Map<String, dynamic>?) ?? {};

    return StatsModel(
      todayOrders: (stats['pendingOrders'] as num?)?.toInt() ?? 0,
      todayReservations: (stats['upcomingReservations'] as num?)?.toInt() ?? 0,
      todayRevenue: (stats['revenue'] as num?)?.toDouble() ?? 0.0,
      pendingOrders: (stats['pendingOrders'] as num?)?.toInt() ?? 0,
      pendingReservations: (stats['pendingReservations'] as num?)?.toInt() ?? 0,
      previousTodayOrders: 0,
      previousTodayReservations: 0,
      previousTodayRevenue: 0.0,
      monthlyRevenues: List.filled(12, 0.0),
    );
  }

  @override
  Future<List<ProductSaleModel>> getProductSales(String businessId) async {
    final response = await _supabase.functions.invoke(
      'get-merchant-space',
      method: HttpMethod.get,
    );

    if (response.status != 200 || response.data == null) {
      return <ProductSaleModel>[];
    }

    final data = response.data as Map<String, dynamic>;
    final offers = (data['offers'] as List<dynamic>?) ?? [];

    return offers.take(5).map((o) {
      final map = o as Map<String, dynamic>;
      return ProductSaleModel(
        productName: map['name'] ?? '',
        soldQuantity: (map['sold_quantity'] as num?)?.toInt() ?? 0,
        revenue: ((map['price'] as num?)?.toDouble() ?? 0.0) *
            ((map['sold_quantity'] as num?)?.toInt() ?? 0),
      );
    }).toList();
  }

  @override
  Future<List<RecentOrderModel>> getRecentOrders(String businessId) async {
    final response = await _supabase.functions.invoke(
      'get-merchant-space',
      method: HttpMethod.get,
    );

    if (response.status != 200 || response.data == null) {
      return <RecentOrderModel>[];
    }

    final data = response.data as Map<String, dynamic>;
    final orders = (data['receivedOrders'] as List<dynamic>?) ?? [];

    return orders.take(5).map((ord) {
      final map = ord as Map<String, dynamic>;
      return RecentOrderModel(
        id: map['id']?.toString() ?? '',
        totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0.0,
        status: map['status']?.toString() ?? 'pending',
        createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ??
            DateTime.now(),
      );
    }).toList();
  }
}
