import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/recent_order.dart';

class RecentOrdersWidget extends StatelessWidget {
  final List<RecentOrder> orders;
  const RecentOrdersWidget({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
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
                        Icons.inventory_outlined,
                        color: AppColors.primary, size: 20
                    ),
                  ),

                  SizedBox(width: 8),
                  Text('Dernières commandes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryLight),
                  ),
                ],
              )
          ),
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Aucune commande récente', )),
            )
          else
            Padding(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
                child: Column(
                  children: [
                    ...orders.take(5).map((order) => ListTile(
                      leading: Icon(order.status == 'delivered' ? Icons.check_circle : Icons.pending,
                          color: order.status == 'delivered' ? Colors.green : Colors.orange),
                      title: Text('Commande #${order.id}'),
                      subtitle: Text(order.createdAt.toLocal().toString().substring(0, 16)),
                      trailing: Text('${order.totalAmount.toStringAsFixed(2)} €'),
                    )),

                    const Divider(),
                  ],
                )
            )

        ],
      ),
    );
  }
}