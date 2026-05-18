import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/inventory_item.dart';

class TabletInventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onTap;
  final double? height;
  final double? width;

  const TabletInventoryItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory,
                        size: 40,
                        color: AppColors.primaryLight,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 8),
                            Text('${item.price.toStringAsFixed(2)} €'),
                            const SizedBox(width: 8),
                            Text(item.isAvailable.toString())
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                          child: Icon(Icons.more_horiz)
                      ),
                    ],
                  ),

                ],
              ),
            ),

            SizedBox(height: 15,),
            Expanded(child: Text(item.description.toString(), style: TextStyle(fontSize: 10, color: Colors.grey),))
          ],
        ),
      ),
    );
  }
}
