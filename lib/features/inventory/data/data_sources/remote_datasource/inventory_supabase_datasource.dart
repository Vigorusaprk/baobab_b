import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'package:baobab_business/core/merchant/merchant_parsing.dart';
import 'package:baobab_business/core/merchant/merchant_sales.dart';
import '../../models/inventory_item_model.dart';
import 'inventory_remote_datasource.dart';

/// Offres du commerce, via les Edge Functions :
/// - `get-merchant-space` : lecture du catalogue (clé `offers`).
/// - `update-offer` : prix et disponibilité.
/// - `create-offer` : publication d'une nouvelle offre.
///
/// L'identifiant d'une offre est un UUID : il reste un texte de bout en bout.
class InventorySupabaseDataSourceImpl implements InventoryRemoteDataSource {
  final MerchantApi _api;

  InventorySupabaseDataSourceImpl({MerchantApi? api})
      : _api = api ?? MerchantApi.instance;

  @override
  Future<List<InventoryItemModel>> getInventory(String businessId) async {
    final data = await _api.space();
    // La base n'a pas de « quantité vendue » : on la déduit des commandes.
    final sold = salesByOffer(asRows(data['orders']));
    return asRows(data['offers']).map((o) {
      final id = o['id'].toString();
      return InventoryItemModel(
        id: id,
        businessId: businessId,
        name: o['name']?.toString() ?? '',
        price: asDouble(o['price']),
        isAvailable: o['is_active'] != false,
        category: o['section']?.toString(),
        description: o['description']?.toString(),
        imageUrl: o['image_url']?.toString(),
        soldQuantity: sold[id]?.quantity ?? 0,
      );
    }).toList();
  }

  @override
  Future<void> updateItemAvailability(
    String businessId,
    String itemId,
    bool isAvailable,
  ) async {
    await _api.call('update-offer', {'offerId': itemId, 'isActive': isAvailable});
  }

  @override
  Future<void> updateItemPrice(String businessId, String itemId, double price) async {
    await _api.call('update-offer', {'offerId': itemId, 'price': price});
  }

  /// Un champ vide devient null : le serveur l'efface ou l'ignore.
  String? _clean(Object? v) {
    final s = v?.toString().trim() ?? '';
    return s.isEmpty ? null : s;
  }

  @override
  Future<void> createItem(String businessId, Map<String, dynamic> data) async {
    await _api.call('create-offer', {
      'name': data['item_name'],
      'price': data['price'],
      'section': _clean(data['item_category']),
      'description': _clean(data['description']),
      'imageUrl': _clean(data['image_url']),
      'fulfilment': data['fulfilment'] ?? 'order',
    });
  }

  /// Modifie une offre existante. Le type (fulfilment) n'est volontairement
  /// pas envoyé : le changer efface capacité et créneaux côté serveur.
  @override
  Future<void> updateItem(String itemId, Map<String, dynamic> data) async {
    await _api.call('update-offer', {
      'offerId': itemId,
      'name': data['item_name'],
      'price': data['price'],
      'section': _clean(data['item_category']),
      'description': _clean(data['description']),
      'imageUrl': _clean(data['image_url']),
    });
  }
}
