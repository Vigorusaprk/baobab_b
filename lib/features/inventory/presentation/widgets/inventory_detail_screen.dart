// lib/features/inventory/presentation/screens/inventory_detail_screen.dart
import 'package:baobab_business/features/inventory/presentation/screens/add_edit_item_screen.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/inventory_item.dart';


class InventoryDetailScreen extends StatelessWidget {
  final String businessId;
  final InventoryItem item;

  const InventoryDetailScreen({
    super.key,
    required this.businessId,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _goToEdit(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              Center(
                child: Image.network(
                  item.imageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            _infoRow('Nom', item.name),
            _infoRow('Catégorie', item.category ?? 'Non catégorisé'),
            _infoRow('Prix', '${item.price.toStringAsFixed(2)} €'),
            _infoRow('Disponibilité', item.isAvailable ? 'Disponible' : 'Indisponible'),
            if (item.description != null && item.description!.isNotEmpty)
              _infoRow('Description', item.description!),
            if (item.ingredients != null && item.ingredients!.isNotEmpty)
              _infoRow('Ingrédients', item.ingredients!),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToEdit(context),
        icon: const Icon(Icons.edit),
        label: const Text('Modifier'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _goToEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditItemScreen(
          businessId: businessId,
        ),
      ),
    ).then((_) => Navigator.pop(context)); // Recharge la page de détail après modification
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}