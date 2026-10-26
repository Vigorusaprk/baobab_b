// lib/features/profile/presentation/screens/shop_screen.dart
//
// Fiche du commerce et point d'entrée vers la gestion de l'équipe.

import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/staff/presentation/screens/staff_screen.dart';
import 'package:flutter/material.dart';
import '../../data/shop_api.dart';
import '../../data/shop_info.dart';
import '../widgets/shop_view.dart';
import 'shop_edit_page.dart';

typedef _ShopData = ({ShopInfo? shop, String role});

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late Future<_ShopData> _future = ShopApi().loadDetails();

  void _retry() {
    setState(() {
      _future = ShopApi().loadDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ShopData>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || snap.data?.shop == null) {
          return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(snap.hasError ? '${snap.error}' : 'Aucun commerce lié à ce compte.',
                  style: const TextStyle(color: AppColors.textMuted)),
              TextButton(onPressed: _retry, child: const Text('Réessayer')),
            ]),
          );
        }
        final shop = snap.data!.shop!;
        final role = snap.data!.role;
        // Seuls owner et manager ont accès à la gestion d'équipe
        final canManageStaff = role == 'owner' || role == 'manager';

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ShopView(
              shop: shop,
              onEdit: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShopEditPage(shop: shop)),
              ).then((_) => _retry()),
              onManageStaff: canManageStaff
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StaffScreen(businessId: shop.id),
                        ),
                      ).then((_) => _retry())
                  : null,
            ),
          ),
        );
      },
    );
  }
}
