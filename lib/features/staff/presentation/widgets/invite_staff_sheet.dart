// lib/features/staff/presentation/widgets/invite_staff_sheet.dart
import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/staff_api.dart';
import 'invite_role_dropdown.dart';
import 'invite_staff_fields.dart';
import 'role_descriptions.dart';

Future<bool?> showInviteStaffSheet(
  BuildContext context, {required String businessId, required String callerRole,
}) => showModalBottomSheet<bool>(
  context: context, isScrollControlled: true,
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
  builder: (_) => InviteStaffSheet(businessId: businessId, callerRole: callerRole),
);

class InviteStaffSheet extends StatefulWidget {
  final String businessId; final String callerRole;
  const InviteStaffSheet({super.key, required this.businessId, required this.callerRole});

  @override
  State<InviteStaffSheet> createState() => _InviteStaffSheetState();
}

class _InviteStaffSheetState extends State<InviteStaffSheet> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  late String _role;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final allowed = RoleDescription.allowedFor(widget.callerRole);
    _role = allowed.any((r) => r.key == 'staff') ? 'staff' : allowed.first.key;
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Entrez une adresse email valide');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await StaffApi().invite(
        businessId: widget.businessId, email: email, role: _role,
        name: _nameCtrl.text.trim(), phone: _phoneCtrl.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } on MerchantException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Ajouter un membre', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          InviteStaffFields(nameCtrl: _nameCtrl, emailCtrl: _emailCtrl, phoneCtrl: _phoneCtrl, error: _error),
          const SizedBox(height: 12),
          InviteRoleDropdown(selectedRole: _role, callerRole: widget.callerRole, onChanged: (r) => setState(() => _role = r)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _submit,
            style: FilledButton.styleFrom(backgroundColor: AppColors.secondary, minimumSize: const Size.fromHeight(48)),
            child: _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Créer / Ajouter le membre'),
          ),
        ],
      ),
    );
  }
}
