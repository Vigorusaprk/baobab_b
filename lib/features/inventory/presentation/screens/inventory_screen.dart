import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/inventory/presentation/screens/add_edit_item_screen.dart';
import 'package:baobab_business/features/inventory/presentation/screens/mobil_inventori.dart';
import 'package:baobab_business/features/inventory/presentation/screens/tablet_iventori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/inventory_bloc.dart';

class InventoryScreen extends StatelessWidget {
  final String businessId;
  const InventoryScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<InventoryBloc>()..add(LoadInventory(businessId)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 900; // Seuil ajusté pour tablette
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA), // Fond gris très clair comme l'image
            body: isTablet
                ? TabletInventory(businessId: businessId)
                : MobilInventory(businessId: businessId),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditItemScreen(businessId: businessId)),
              ),
              backgroundColor: AppColors.secondary, // Jaune comme le bouton "Add New Menu"
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Ajouter',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              elevation: 4,
            ),
          );
        },
      ),
    );
  }
}