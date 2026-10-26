import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/ad_models.dart';

/// Un emplacement avec son explication et son tarif par jour.
class PlacementRow extends StatelessWidget {
  final AdPrice price;
  const PlacementRow({super.key, required this.price});

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(price.label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(placementHints[price.placement] ?? ''),
        trailing: Text('${price.usdPerDay.toStringAsFixed(2)} \$/jour',
            style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700)),
      );
}
