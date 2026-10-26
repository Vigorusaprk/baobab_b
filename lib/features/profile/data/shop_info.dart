/// La fiche du commerce telle que la renvoie `get-merchant-space` (clé `business`).
class ShopInfo {
  final String id, name, type;
  final String? description, cover, phone, email, website, pauseNote;
  final String province, ville, commune, quartier, avenue, numero;
  final Map<String, String> hours; // « Lundi » → « 09:00 - 18:00 » ; absent = fermé
  final bool isPaused;

  const ShopInfo({
    required this.id, required this.name, required this.type,
    this.description, this.cover, this.phone, this.email, this.website,
    this.pauseNote, this.province = '', this.ville = '', this.commune = '',
    this.quartier = '', this.avenue = '', this.numero = '',
    this.hours = const {}, this.isPaused = false,
  });

  /// Texte d'une colonne, `null` si vide.
  static String? _s(Object? v) {
    final t = v?.toString().trim() ?? '';
    return t.isEmpty ? null : t;
  }

  factory ShopInfo.fromRow(Map<String, dynamic> r) {
    final raw = r['opening_hours'];
    final hours = <String, String>{};
    if (raw is Map) {
      raw.forEach((day, line) {
        final text = _s(line);
        if (text != null) hours[day.toString()] = text; // jour vide = fermé
      });
    }
    return ShopInfo(
      id: r['id'].toString(),
      name: _s(r['name']) ?? '',
      type: _s(r['type']) ?? '',
      description: _s(r['description']),
      cover: _s(r['bgImg']),
      phone: _s(r['phone']),
      email: _s(r['email']),
      website: _s(r['website']),
      pauseNote: _s(r['pause_note']),
      province: _s(r['province']) ?? '',
      ville: _s(r['ville']) ?? '',
      commune: _s(r['commune']) ?? '',
      quartier: _s(r['quartier']) ?? '',
      avenue: _s(r['avenue']) ?? '',
      numero: _s(r['numero']) ?? '',
      hours: hours,
      isPaused: r['is_paused'] == true,
    );
  }
}
