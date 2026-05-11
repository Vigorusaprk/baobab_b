import 'package:baobab_business/features/dashboard/domain/entities/recent_order.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_tablete/headere_tablet.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/recent_orders_widget.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/top_products_widget.dart';
import 'package:flutter/material.dart';
import 'package:baobab_business/features/dashboard/domain/entities/stats.dart';
import 'package:baobab_business/features/dashboard/domain/entities/product_sale.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/header_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/revenu_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/oter_info_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/monthly_income_chart.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/sales_pie_chart.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/client_liste.dart';

class TabletDashboard extends StatelessWidget {
  final String businessId;
  final DashboardStats stats;
  final List<ProductSale> productSales;
  final List<RecentOrder> recentOrders;

  const TabletDashboard({
    super.key,
    required this.businessId,
    required this.stats,
    required this.productSales,
    required this.recentOrders
  });

  @override
  Widget build(BuildContext context) {
    final totalSales = productSales.fold(0.0, (sum, item) => sum + item.revenue);
    final pieChartData = productSales.map((p) => ProductSalesData(
      productName: p.productName,
      salesAmount: p.revenue,
    )).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const HeadereTablet(),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  RevenueSection(),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(width: 20),
              OtherInfoSection(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: MonthlyIncomeChart(
                      monthlyData: stats.monthlyRevenues, // ✅ correction: utiliser stats au lieu de state.stats
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SalesPieChart(
                      data: pieChartData,
                      totalSales: totalSales,
                      isTablet: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              TopProductsWidget(products: productSales),

              const SizedBox(height: 16),
              RecentOrdersWidget(orders: recentOrders),
            ],
          ),
          const SizedBox(height: 20),
          CustomerListWidget(businessId: businessId),
        ],
      ),
    );
  }
}