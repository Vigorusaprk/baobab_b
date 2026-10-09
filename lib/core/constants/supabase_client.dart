import 'package:supabase_flutter/supabase_flutter.dart';

/// Classe utilitaire pour initialiser et accéder au client Supabase
class SupabaseClientWrapper {
  static SupabaseClient? _client;

  /// Récupère l'instance du client une fois initialisée
  static SupabaseClient get client => _client!;

  /// Le client s'il existe (renvoie null s'il n'est pas encore initialisé)
  static SupabaseClient? get clientOrNull => _client;

  /// Initialise la connexion à Supabase avec le protocole PKCE (sécurisé)
  static Future<void> initialize() async {
    const String supabaseUrl = 'https://wrutwzbtnquxigxetxfx.supabase.co';
    const String publishableKey =
        'sb_publishable_lCKQ9R0_LzFk6EbRYuDnbQ_WITRinDO';

    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: publishableKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );

    _client = supabase.client;
  }
}
