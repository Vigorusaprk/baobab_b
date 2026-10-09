import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import '../../models/auth_response.dart';
import 'auth_remote_datasource.dart';

/// Implémentation Supabase pour l'authentification marchande.
///
/// Utilise Supabase Auth directement et vérifie l'espace marchand via `get-merchant-space`.
class AuthSupabaseDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthSupabaseDataSourceImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<AuthResponse> login(String email, String password) async {
    final authRes = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = authRes.user;
    final session = authRes.session;
    if (user == null || session == null) {
      throw Exception('Échec de la connexion');
    }

    String? businessId;
    try {
      final spaceRes = await _supabase.functions.invoke(
        'get-merchant-space',
        method: HttpMethod.get,
      );
      if (spaceRes.status == 200 && spaceRes.data != null) {
        final data = spaceRes.data as Map<String, dynamic>;
        businessId = data['business']?['id']?.toString();
      }
    } catch (_) {}

    return AuthResponse(
      id: user.id,
      name: user.userMetadata?['full_name'] ?? user.email ?? '',
      email: user.email ?? '',
      token: session.accessToken,
      businessId: businessId,
      imgUrl: user.userMetadata?['avatar_url'],
    );
  }

  @override
  Future<AuthResponse> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    final authRes = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name, 'phone': phone},
    );

    final user = authRes.user;
    final session = authRes.session;
    if (user == null) {
      throw Exception('Échec de l\'inscription');
    }

    return AuthResponse(
      id: user.id,
      name: name,
      email: user.email ?? '',
      token: session?.accessToken ?? '',
      businessId: null,
      imgUrl: null,
    );
  }

  @override
  Future<AuthResponse> getCurrentUser(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Aucun utilisateur connecté');
    }

    String? businessId;
    try {
      final spaceRes = await _supabase.functions.invoke(
        'get-merchant-space',
        method: HttpMethod.get,
      );
      if (spaceRes.status == 200 && spaceRes.data != null) {
        final data = spaceRes.data as Map<String, dynamic>;
        businessId = data['business']?['id']?.toString();
      }
    } catch (_) {}

    return AuthResponse(
      id: user.id,
      name: user.userMetadata?['full_name'] ?? user.email ?? '',
      email: user.email ?? '',
      token: token,
      businessId: businessId,
      imgUrl: user.userMetadata?['avatar_url'],
    );
  }
}
