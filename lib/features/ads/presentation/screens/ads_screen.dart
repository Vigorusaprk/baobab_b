import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/ads_api.dart';
import '../widgets/campaign_card.dart';
import '../widgets/campaign_request_sheet.dart';
import '../widgets/placement_row.dart';

/// Publicité vue du commerçant : emplacements et tarifs, demande de mise en
/// avant, liste des campagnes (annulation possible tant qu'elles ne sont pas finies).
class AdsScreen extends StatefulWidget {
  final String businessId;
  const AdsScreen({super.key, required this.businessId});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  final _api = AdsApi();
  late Future<AdBoard> _future = _api.load(widget.businessId);

  // Bloc { } obligatoire : une flèche => renverrait le Future à setState.
  void _reload() {
    setState(() {
      _future = _api.load(widget.businessId);
    });
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _ask(AdBoard board) async {
    // Seules les offres en ligne peuvent être poussées (règle serveur).
    final space = await MerchantApi.instance.space();
    final offers = (space['offers'] is List ? space['offers'] as List : const [])
        .whereType<Map>().map((e) => Map<String, dynamic>.from(e))
        .where((o) => o['is_active'] != false).toList();
    if (!mounted) return;
    final ok = await showCampaignRequestSheet(context,
        businessId: widget.businessId, board: board, offers: offers);
    if (ok == true) { _toast('Demande envoyée.'); _reload(); }
  }

  Future<void> _cancel(String id) async {
    try { await _api.cancel(id); _reload(); } catch (e) { _toast(e.toString()); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(title: const Text('Mise en avant'),
          backgroundColor: AppColors.secondary, foregroundColor: Colors.white),
      body: FutureBuilder<AdBoard>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: TextButton(onPressed: _reload,
                child: Text('${snap.error}\nRéessayer', textAlign: TextAlign.center)));
          }
          final b = snap.data!;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: RefreshIndicator(
                onRefresh: () async => _reload(),
                child: ListView(padding: const EdgeInsets.all(16), children: [
                  const Text('Emplacements', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  for (final p in b.prices) PlacementRow(price: p),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: b.prices.isEmpty ? null : () => _ask(b),
                    icon: const Icon(Icons.campaign_outlined),
                    label: const Text('Demander une mise en avant'),
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondary, minimumSize: const Size.fromHeight(48)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Vos campagnes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 8),
                  if (b.campaigns.isEmpty)
                    const Text('Aucune campagne pour le moment.',
                        style: TextStyle(color: AppColors.textMuted)),
                  for (final c in b.campaigns)
                    CampaignCard(campaign: c, onCancel: () => _cancel(c.id)),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
