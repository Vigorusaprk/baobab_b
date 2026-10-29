// lib/features/staff/presentation/screens/staff_screen.dart
import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/staff_api.dart';
import '../../data/staff_member.dart';
import '../widgets/confirm_remove_dialog.dart';
import '../widgets/staff_fab.dart';
import '../widgets/staff_list_body.dart';

typedef _StaffData = ({String role, String userId, List<StaffMember> list});

class StaffScreen extends StatefulWidget {
  final String businessId;
  const StaffScreen({super.key, required this.businessId});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final _api = StaffApi();
  late Future<_StaffData> _future = _load();

  Future<_StaffData> _load() async {
    String role = 'owner';
    try {
      final s = await MerchantApi.instance.space();
      role = s['role']?.toString() ?? 'owner';
    } catch (_) {}
    final uid = Supabase.instance.client.auth.currentUser?.id ?? '';
    final list = await _api.load(widget.businessId);
    return (role: role, userId: uid, list: list);
  }

  void _reload() => setState(() => _future = _load());
  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _update(StaffMember m, String? role, String? status) async {
    try {
      await _api.update(staffId: m.id, role: role, status: status);
      _reload();
    } on MerchantException catch (e) {
      _toast(e.message);
    }
  }

  Future<void> _remove(StaffMember m) async {
    final ok = await showConfirmRemoveDialog(context, m);
    if (!ok || !mounted) return;
    try {
      await _api.remove(m.id);
      _reload();
    } on MerchantException catch (e) {
      _toast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Équipe'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<_StaffData>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snap.data ?? (role: 'owner', userId: '', list: <StaffMember>[]);
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Stack(children: [
                StaffListBody(
                  members: d.list, callerRole: d.role, callerUserId: d.userId,
                  onRefresh: () async => _reload(), onUpdate: _update, onRemove: _remove,
                ),
                Positioned(
                  bottom: 16, right: 16,
                  child: StaffFab(businessId: widget.businessId, callerRole: d.role, onInvited: _reload),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
