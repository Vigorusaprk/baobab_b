import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/business_model.dart';
import 'business_remote_datasource.dart';

/// Implémentation Supabase pour récupérer et gérer la boutique marchand.
///
/// Elle utilise l'Edge Function `get-merchant-space` pour récupérer la boutique du commerçant connecté.
class BusinessSupabaseDataSourceImpl implements BusinessRemoteDataSource {
  final SupabaseClient _supabase;

  BusinessSupabaseDataSourceImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<BusinessModel> getBusiness(String businessId) async {
    final response = await _supabase.functions.invoke(
      'get-merchant-space',
      method: HttpMethod.get,
    );

    if (response.status != 200 || response.data == null) {
      throw Exception('Impossible de charger le commerce: ${response.status}');
    }

    final data = response.data as Map<String, dynamic>;
    final biz = data['business'] as Map<String, dynamic>?;

    if (biz == null) {
      throw Exception('Aucun commerce associé à ce compte');
    }

    return BusinessModel.fromJson(biz);
  }
}
