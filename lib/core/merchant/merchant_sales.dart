import 'merchant_parsing.dart';

/// Ventes cumulées d'une offre, calculées depuis les lignes de commande.
class OfferSales {
  final String name;
  int quantity = 0;
  double revenue = 0;
  OfferSales(this.name);
}

/// Regroupe les `order_items` des commandes non annulées par offre.
///
/// La base n'a pas de colonne « quantité vendue » : on la déduit des
/// commandes reçues (les 50 plus récentes renvoyées par le serveur).
/// Clé = `offer_id`, ou le nom de l'article à défaut.
Map<String, OfferSales> salesByOffer(List<Map<String, dynamic>> orders) {
  final sales = <String, OfferSales>{};
  for (final order in orders) {
    if (order['status'] == 'cancelled') continue;
    for (final line in asRows(order['order_items'])) {
      final name = line['item_name']?.toString() ?? 'Article';
      final key = line['offer_id']?.toString() ?? name;
      final entry = sales.putIfAbsent(key, () => OfferSales(name));
      final qty = asInt(line['quantity']);
      entry.quantity += qty;
      entry.revenue += asDouble(line['price']) * qty;
    }
  }
  return sales;
}
