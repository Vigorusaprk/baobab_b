// lib/features/staff/data/staff_api.dart
import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'staff_member.dart';

class StaffApi {
  final _api = MerchantApi.instance;
  static final List<StaffMember> _cache = [];
  static bool _fallback = false;

  List<T> _rows<T>(Object? v, T Function(Map<String, dynamic>) f) =>
      (v is List ? v : const []).whereType<Map>().map((e) => f(Map<String, dynamic>.from(e))).toList();

  Future<List<StaffMember>> load(String businessId) async {
    try {
      if (businessId.isNotEmpty) {
        final d = await _api.fetch('get-staff', query: {'businessId': businessId});
        final list = _rows(d['data'], StaffMember.fromJson);
        if (list.isNotEmpty) {
          _fallback = false;
          _cache..clear()..addAll(list);
          return list;
        }
      }
    } catch (_) {
      _fallback = true;
    }
    // Fallback ou liste par défaut avec le compte connecté
    _fallback = true;
    if (_cache.isEmpty) {
      final u = Supabase.instance.client.auth.currentUser;
      _cache.add(StaffMember(
        id: 'owner_me',
        userId: u?.id ?? 'me',
        name: u?.userMetadata?['full_name']?.toString() ??
            u?.userMetadata?['name']?.toString() ??
            u?.email?.split('@').first ??
            'Propriétaire',
        phone: u?.phone ?? u?.userMetadata?['phone']?.toString(),
        email: u?.email ?? 'commerce@baobabe.cd',
        role: 'owner',
        status: 'active',
        invitedAt: DateTime.now(),
      ));
    }
    return List.unmodifiable(_cache);
  }

  Future<void> invite({
    required String businessId,
    required String email,
    required String role,
    String? name,
    String? phone,
  }) async {
    try {
      await _api.call('invite-staff', {
        'businessId': businessId,
        'email': email.trim().toLowerCase(),
        'role': role,
        if (name != null && name.isNotEmpty) 'name': name.trim(),
        if (phone != null && phone.isNotEmpty) 'phone': phone.trim(),
      });
    } catch (_) {
      _fallback = true;
    }
    final n = (name != null && name.isNotEmpty) ? name : email.split('@').first;
    final exists = _cache.any((m) => m.email?.toLowerCase() == email.trim().toLowerCase());
    if (!exists) {
      _cache.add(StaffMember(
        id: 'staff_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: n,
        phone: phone,
        email: email.trim().toLowerCase(),
        role: role,
        status: 'active',
        invitedAt: DateTime.now(),
      ));
    }
  }

  Future<void> update({required String staffId, String? role, String? status}) async {
    try {
      await _api.call('update-staff', {
        'staffId': staffId,
        if (role != null) 'role': role,
        if (status != null) 'status': status,
      });
    } catch (_) {
      _fallback = true;
    }
    final i = _cache.indexWhere((m) => m.id == staffId);
    if (i != -1) {
      final m = _cache[i];
      _cache[i] = StaffMember(
        id: m.id, userId: m.userId, name: m.name, phone: m.phone, email: m.email,
        role: role ?? m.role, status: status ?? m.status, invitedAt: m.invitedAt,
      );
    }
  }

  Future<void> remove(String staffId) async {
    try {
      await _api.call('remove-staff', {'staffId': staffId});
    } catch (_) {
      _fallback = true;
    }
    _cache.removeWhere((m) => m.id == staffId);
  }
}
