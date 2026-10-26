// lib/features/profile/presentation/widgets/shop_view.dart
//
// Page statique (lecture seule) du commerce avec actions d'administration.

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/shop_info.dart';
import 'shop_info_cards.dart';

class ShopView extends StatelessWidget {
  final ShopInfo shop;
  final VoidCallback onEdit;
  final VoidCallback? onManageStaff;

  const ShopView({
    super.key,
    required this.shop,
    required this.onEdit,
    this.onManageStaff,
  });

  Widget _cover() => AspectRatio(
    aspectRatio: 16 / 7,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: shop.cover == null
          ? const ColoredBox(color: AppColors.primaryDark,
          child: Icon(Icons.storefront, size: 48, color: AppColors.textMuted))
          : Image.network(shop.cover!, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.primaryDark)),
    ),
  );

  Widget _header() => Row(children: [
    Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(shop.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        if (shop.type.isNotEmpty)
          Text(shop.type, style: const TextStyle(color: AppColors.textMuted)),
      ]),
    ),
    Chip(
      label: Text(shop.isPaused ? 'En pause' : 'Ouvert aux clients'),
      backgroundColor: shop.isPaused ? Colors.orange.shade100 : AppColors.secondary.withValues(alpha: 0.12),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      _cover(),
      const SizedBox(height: 14),
      _header(),
      if (shop.isPaused && shop.pauseNote != null)
        Padding(padding: const EdgeInsets.only(top: 6), child: Text(shop.pauseNote!)),
      if (shop.description != null)
        Padding(padding: const EdgeInsets.only(top: 12), child: Text(shop.description!)),
      const SizedBox(height: 16),
      ContactCard(shop),
      HoursCard(shop.hours),
      const SizedBox(height: 8),
      FilledButton.icon(
        onPressed: onEdit,
        icon: const Icon(Icons.edit),
        label: const Text('Modifier la fiche'),
        style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondary, minimumSize: const Size.fromHeight(48)),
      ),
      if (onManageStaff != null) ...[
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onManageStaff,
          icon: const Icon(Icons.people_outline, color: AppColors.secondary),
          label: const Text('Gérer l\'équipe', style: TextStyle(color: AppColors.secondary)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.secondary),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    ]);
  }
}
