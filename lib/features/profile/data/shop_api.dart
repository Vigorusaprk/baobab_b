// lib/features/profile/data/shop_api.dart
//
// Lecture et modification de la fiche du commerce.

import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'shop_info.dart';

class ShopApi {
  /// La fiche à jour, ou `null` si le compte n'est lié à aucun commerce.
  Future<ShopInfo?> load() async {
    final details = await loadDetails();
    return details.shop;
  }

  /// Charge la fiche du commerce ainsi que le rôle du staff connecté.
  Future<({ShopInfo? shop, String role})> loadDetails() async {
    final data = await MerchantApi.instance.space(force: true);
    final b = data['business'];
    final role = data['role']?.toString() ?? 'staff';
    final shop = b is Map ? ShopInfo.fromRow(Map<String, dynamic>.from(b)) : null;
    return (shop: shop, role: role);
  }

  /// Envoie les champs modifiés.
  Future<void> save(String businessId, Map<String, dynamic> fields) =>
      MerchantApi.instance.call('update-business', {'businessId': businessId, ...fields});
}
