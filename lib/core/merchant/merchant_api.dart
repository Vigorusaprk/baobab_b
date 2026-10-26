import 'package:supabase_flutter/supabase_flutter.dart';

/// Erreur lisible renvoyée par une Edge Function (déjà en français côté serveur).
class MerchantException implements Exception {
  final String message;
  const MerchantException(this.message);

  @override
  String toString() => message;
}

/// Point d'entrée UNIQUE vers l'espace marchand (Edge Functions uniquement,
/// jamais de `.from('table')`).
///
/// Le dashboard, les commandes et le stock lisent tous `get-merchant-space`.
/// Au lieu de trois requêtes identiques à chaque ouverture, [space] partage
/// la requête en cours et garde la réponse 5 secondes.
class MerchantApi {
  MerchantApi._();
  static final MerchantApi instance = MerchantApi._();

  static const Duration _ttl = Duration(seconds: 5);

  Future<Map<String, dynamic>>? _inFlight;
  Map<String, dynamic>? _cache;
  DateTime? _cachedAt;

  SupabaseClient get _client => Supabase.instance.client;

  /// Réponse complète de `get-merchant-space` (commerce, offres, commandes…).
  Future<Map<String, dynamic>> space({bool force = false}) {
    final cached = _cache;
    final at = _cachedAt;
    if (!force && cached != null && at != null && DateTime.now().difference(at) < _ttl) {
      return Future.value(cached);
    }
    return _inFlight ??= _fetch().whenComplete(() => _inFlight = null);
  }

  Future<Map<String, dynamic>> _fetch() async {
    final data = await _invoke('get-merchant-space', method: HttpMethod.get);
    _cache = data;
    _cachedAt = DateTime.now();
    return data;
  }

  /// Écriture (création, modification, statut). Invalide la réponse gardée,
  /// pour que la lecture suivante reflète le changement.
  Future<Map<String, dynamic>> call(String function, Map<String, dynamic> body) async {
    final data = await _invoke(function, body: body);
    clear();
    return data;
  }

  /// Lecture simple d'une fonction GET avec paramètres (ex. `get-ad-campaigns`).
  Future<Map<String, dynamic>> fetch(String function, {Map<String, String>? query}) =>
      _invoke(function, method: HttpMethod.get, query: query);

  /// Oublie la réponse gardée (changement de compte, déconnexion).
  void clear() {
    _cache = null;
    _cachedAt = null;
  }

  Future<Map<String, dynamic>> _invoke(
      String function, {
        HttpMethod method = HttpMethod.post,
        Map<String, dynamic>? body,
        Map<String, String>? query,
      }) async {
    try {
      final res = await _client.functions.invoke(
          function, method: method, body: body, queryParameters: query);
      final data = res.data;
      if (data is! Map) return <String, dynamic>{};
      final map = Map<String, dynamic>.from(data);
      if (map['error'] != null) throw MerchantException(map['error'].toString());
      return map;
    } on FunctionException catch (e) {
      // Les fonctions répondent {error: "..."} avec un statut 400.
      final details = e.details;
      final message = details is Map && details['error'] != null
          ? details['error'].toString()
          : 'Erreur serveur (${e.status}). Réessayez.';
      throw MerchantException(message);
    }
  }
}
