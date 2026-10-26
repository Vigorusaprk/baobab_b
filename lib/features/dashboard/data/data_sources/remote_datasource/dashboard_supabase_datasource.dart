import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'package:baobab_business/core/merchant/merchant_parsing.dart';
import 'package:baobab_business/core/merchant/merchant_sales.dart';
import '../../models/product_sale_model.dart';
import '../../models/recent_order_model.dart';
import '../../models/stats_model.dart';
import '../../stats_builder.dart';
import 'dashboard_remote_datasource.dart';

/// Données du dashboard marchand, via l'Edge Function `get-merchant-space`.
///
/// Les trois lectures partagent UNE seule requête (voir [MerchantApi.space]).
/// Rien n'est inventé : les chiffres viennent des commandes et réservations
/// réellement reçues, et les ventes par produit des lignes de commande.
class DashboardSupabaseDataSourceImpl implements DashboardRemoteDataSource {
  final MerchantApi _api;

  DashboardSupabaseDataSourceImpl({MerchantApi? api})
      : _api = api ?? MerchantApi.instance;

  @override
  Future<StatsModel> getStats(String businessId) async =>
      buildStats(await _api.space());

  @override
  Future<List<ProductSaleModel>> getProductSales(String businessId) async {
    final data = await _api.space();
    final sales = salesByOffer(asRows(data['orders'])).values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));
    return sales
        .take(5)
        .map((s) => ProductSaleModel(
              productName: s.name,
              quantity: s.quantity,
              revenue: s.revenue,
            ))
        .toList();
  }

  @override
  Future<List<RecentOrderModel>> getRecentOrders(String businessId) async {
    final data = await _api.space();
    // Le serveur trie déjà du plus récent au plus ancien.
    return asRows(data['orders'])
        .take(5)
        .map((o) => RecentOrderModel(
              id: o['id'].toString(),
              totalAmount: asDouble(o['total_amount'] ?? o['total_price']),
              status: o['status']?.toString() ?? 'pending',
              createdAt: asInstant(o['created_at']) ?? DateTime.now(),
            ))
        .toList();
  }
}
