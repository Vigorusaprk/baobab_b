import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/ad_models.dart';
import '../../data/ads_api.dart';

/// Ouvre la feuille de demande ; rend `true` si une demande a été déposée.
Future<bool?> showCampaignRequestSheet(BuildContext context,
        {required String businessId, required AdBoard board, required List<Map<String, dynamic>> offers}) =>
    showModalBottomSheet<bool>(
      context: context, isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
        child: _Form(businessId: businessId, board: board, offers: offers),
      ),
    );

class _Form extends StatefulWidget {
  final String businessId;
  final AdBoard board;
  final List<Map<String, dynamic>> offers;
  const _Form({required this.businessId, required this.board, required this.offers});

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late String _placement = widget.board.prices.first.placement;
  String? _offerId;
  DateTimeRange? _range;
  bool _sending = false;
  String? _error;

  int get _days => _range == null ? 0 : _range!.end.difference(_range!.start).inDays + 1;
  double get _quote =>
      _days * widget.board.prices.firstWhere((p) => p.placement == _placement).usdPerDay;

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final r = await showDateRangePicker(
        context: context, firstDate: now, lastDate: now.add(const Duration(days: 90)));
    if (r != null) setState(() => _range = r);
  }

  Future<void> _send() async {
    setState(() { _sending = true; _error = null; });
    try {
      await AdsApi().request(businessId: widget.businessId, placement: _placement,
          start: _range!.start, end: _range!.end, offerId: _offerId);
      if (mounted) Navigator.pop(context, true);
    } on MerchantException catch (e) {
      setState(() { _sending = false; _error = e.message; });
    } catch (e) {
      setState(() { _sending = false; _error = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Demander une mise en avant',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _placement, decoration: const InputDecoration(labelText: 'Emplacement'),
          items: [for (final p in widget.board.prices) DropdownMenuItem(value: p.placement, child: Text(p.label))],
          onChanged: (v) => setState(() => _placement = v!),
        ),
        DropdownButtonFormField<String?>(
          value: _offerId, decoration: const InputDecoration(labelText: 'Offre à pousser'),
          items: [
            const DropdownMenuItem(value: null, child: Text('Tout le commerce')),
            for (final o in widget.offers)
              DropdownMenuItem(value: o['id'].toString(), child: Text(o['name']?.toString() ?? '')),
          ],
          onChanged: (v) => setState(() => _offerId = v),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _pickRange, icon: const Icon(Icons.date_range),
          label: Text(_range == null ? 'Choisir les dates' : '$_days jour(s) · devis ${_quote.toStringAsFixed(2)} \$'),
        ),
        if (_error != null)
          Padding(padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: const TextStyle(color: AppColors.error))),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _range == null || _sending ? null : _send,
          style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary, minimumSize: const Size.fromHeight(48)),
          child: Text(_sending ? 'Envoi…' : 'Envoyer la demande'),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Baobabe examine la demande et peut ajuster le montant avant le règlement.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ),
      ]),
    );
  }
}
