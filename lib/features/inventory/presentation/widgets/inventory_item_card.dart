import 'package:flutter/material.dart';
import '../../domain/entities/inventory_item.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onTap;
  final double? height;
  final double? width;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text('${item.price.toStringAsFixed(2)} €'),
            ],
          ),
        ),
      ),
    );
  }
}