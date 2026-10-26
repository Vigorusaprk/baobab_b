import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/ad_models.dart';

/// Une campagne : cible, emplacement, période, montant, statut et annulation.
class CampaignCard extends StatelessWidget {
  final AdCampaign campaign;
  final VoidCallback? onCancel;
  const CampaignCard({super.key, required this.campaign, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('d MMM', 'fr_FR');
    final c = campaign;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(c.target, style: const TextStyle(fontWeight: FontWeight.w700))),
          Chip(label: Text(c.statusLabel), visualDensity: VisualDensity.compact),
        ]),
        Text('${placementLabels[c.placement] ?? c.placement} · '
            '${f.format(c.startsOn)} → ${f.format(c.endsOn)}',
            style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text('${c.due.toStringAsFixed(2)} \$${c.amount == null ? ' (devis)' : ''}'),
        if (c.status == 'approved')
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('Validée. Le règlement par Mobile Money arrive bientôt.',
                style: TextStyle(color: AppColors.textMuted)),
          ),
        if (c.status == 'rejected' && c.reviewNote != null)
          Padding(padding: const EdgeInsets.only(top: 6), child: Text('Motif : ${c.reviewNote}')),
        if (onCancel != null && !c.isOver)
          Align(alignment: Alignment.centerRight,
              child: TextButton(onPressed: onCancel, child: const Text('Annuler'))),
      ]),
    );
  }
}
