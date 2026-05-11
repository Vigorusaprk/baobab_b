import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/header_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/monthly_income_chart.dart';
import 'package:flutter/material.dart';
import 'package:baobab_business/features/dashboard/domain/entities/stats.dart';
import 'package:baobab_business/features/dashboard/domain/entities/product_sale.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/revenu_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/oter_info_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/sales_pie_chart.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/client_liste.dart';

class MobileDashboard extends StatelessWidget {
  final String businessId;
  final DashboardStats stats;
  final List<ProductSale> productSales;

  const MobileDashboard({
    super.key,
    required this.businessId,
    required this.stats,
    required this.productSales,
  });

  @override
  Widget build(BuildContext context) {
    final totalSales = productSales.fold(0.0, (sum, item) => sum + item.revenue);
    final pieChartData = productSales.map((p) => ProductSalesData(
      productName: p.productName,
      salesAmount: p.revenue,
    )).toList();

    return SingleChildScrollView(
      padding:  EdgeInsets.all(12),
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const HeaderSection(),
          const SizedBox(height: 12),
          const RevenueSection(),
          const SizedBox(height: 12),
          const OtherInfoSection(),
          const SizedBox(height: 20),
          CustomerListWidget(businessId: businessId),
        ],
      ),
    );
  }
}