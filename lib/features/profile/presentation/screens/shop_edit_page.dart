import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/shop_info.dart';
import '../widgets/shop_form.dart';

/// Page du formulaire d'édition de la fiche (ouverte depuis la page statique).
class ShopEditPage extends StatelessWidget {
  final ShopInfo shop;
  const ShopEditPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          title: const Text('Modifier ma fiche'),
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ShopForm(shop: shop),
          ),
        ),
      );
}
