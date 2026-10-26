/// Petits convertisseurs pour lire les réponses de `get-merchant-space`
/// sans planter sur un champ absent ou d'un autre type.

/// Instant venu du serveur, ramené à l'heure de l'appareil.
/// Postgres renvoie de l'UTC : sans `toLocal()`, un rendez-vous pris à 11 h
/// à Kinshasa s'afficherait 10 h.
DateTime? asInstant(Object? raw) =>
    DateTime.tryParse(raw?.toString() ?? '')?.toLocal();

double asDouble(Object? v) =>
    v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '') ?? 0.0;

int asInt(Object? v) =>
    v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;

/// Liste de lignes JSON (`orders`, `offers`…), jamais nulle.
List<Map<String, dynamic>> asRows(Object? v) => (v is List ? v : const [])
    .whereType<Map>()
    .map((e) => Map<String, dynamic>.from(e))
    .toList();

/// Client d'une commande ou réservation : `customer: {name, phone}`.
({String name, String phone}) customerOf(Map<String, dynamic> row) {
  final c = row['customer'];
  if (c is Map) {
    return (name: c['name']?.toString() ?? '', phone: c['phone']?.toString() ?? '');
  }
  return (name: '', phone: '');
}
