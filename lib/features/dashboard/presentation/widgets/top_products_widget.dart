import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/core/themes/app_diemens.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/product_sale.dart';

class TopProductsWidget extends StatelessWidget {
  final List<ProductSale> products; // déjà chargé par le DashboardBloc

  const TopProductsWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink(); // ou un texte "Pas encore de ventes"
    }

    // Prendre les 3 premiers (déjà triés par revenue décroissant par le backend)
    final top3 = products.length >= 3 ? products.take(3).toList() : products;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12),),
              color: AppColors.secondary,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                    child: Icon(
                        Icons.emoji_events,
                        color: AppColors.primary, size: 20
                    ),
                ),
                SizedBox(width: 8),
                Text(
                  'Top produits (CA)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryLight),
                ),
              ],
            ),
          ),

          Padding(
              padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
              child: Column(
                children: [
                  ...top3.asMap().entries.map((entry) {
                    final index = entry.key;
                    final product = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: _getMedalColor(index),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  product.productName,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${product.revenue.toStringAsFixed(0)} €',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          Divider()
                        ],
                      ),
                    );
                  }),
                ],
              )
          )
        ],
      ),
    );
  }

  Color _getMedalColor(int index) {
    switch (index) {
      case 0: return Colors.amber;      // or
      case 1: return Colors.grey;       // argent
      case 2: return Colors.brown;      // bronze
      default: return Colors.grey.shade300;
    }
  }
}