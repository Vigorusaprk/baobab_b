import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:baobab_business/features/inventory/data/models/inventory_item_model.dart';
import 'inventory_remote_datasource.dart';

/// Implémentation Supabase pour l'inventaire et les offres marchandes.
///
/// Elle communique avec les Edge Functions Supabase :
/// - `get-merchant-space` pour récupérer les offres réelles du commerce.
/// - `update-offer` pour modifier la disponibilité ou le prix.
/// - `create-offer` pour publier une nouvelle offre.
class InventorySupabaseDataSourceImpl implements InventoryRemoteDataSource {
  final SupabaseClient _supabase;

  InventorySupabaseDataSourceImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<InventoryItemModel>> getInventory(String businessId) async {
    final response = await _supabase.functions.invoke(
      'get-merchant-space',
      method: HttpMethod.get,
    );

    if (response.status != 200 || response.data == null) {
      throw Exception('Erreur lors du chargement des offres: ${response.status}');
    }

    final data = response.data as Map<String, dynamic>;
    final offers = (data['offers'] as List<dynamic>?) ?? [];

    return offers.map((item) {
      final map = item as Map<String, dynamic>;
      return InventoryItemModel(
        id: (map['id'] is int) ? map['id'] : map['id'].hashCode,
        businessId: businessId,
        name: map['name'] ?? '',
        price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
        isAvailable: map['is_active'] == true,
        category: map['section'],
        description: map['description'],
        imageUrl: map['image_url'],
        soldQuantity: map['sold_quantity'] ?? 0,
      );
    }).toList();
  }

  @override
  Future<void> updateItemAvailability(
    String businessId,
    int itemId,
    bool isAvailable,
  ) async {
    await _supabase.functions.invoke(
      'update-offer',
      body: {
        'offerId': itemId.toString(),
        'isActive': isAvailable,
      },
    );
  }

  @override
  Future<void> updateItemPrice(
    String businessId,
    int itemId,
    double price,
  ) async {
    await _supabase.functions.invoke(
      'update-offer',
      body: {
        'offerId': itemId.toString(),
        'price': price,
      },
    );
  }

  @override
  Future<void> createItem(String businessId, Map<String, dynamic> data) async {
    await _supabase.functions.invoke(
      'create-offer',
      body: {
        'name': data['item_name'],
        'price': data['price'],
        'section': data['item_category'],
        'description': data['description'] ?? '',
        'fulfilment': data['fulfilment'] ?? 'order',
      },
    );
  }
}
