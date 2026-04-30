import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/inventory/domain/entities/inventory_item.dart';
import 'package:baobab_business/features/inventory/presentation/widgets/inventory_detail_screen.dart';
import 'package:baobab_business/features/inventory/presentation/widgets/inventory_item_card.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/sales_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/inventory_bloc.dart';
import 'add_edit_item_screen.dart';

class InventoryScreen extends StatelessWidget {
  final String businessId;
  const InventoryScreen({super.key, required this.businessId});

  List<ProductSalesData> _buildSalesData(List<InventoryItem> items) {
    return items
        .where((item) => item.soldQuantity > 0)
        .map((item) {
      final salesAmount = item.price * item.soldQuantity;
      return ProductSalesData(
        productName: item.name,
        salesAmount: salesAmount,
      );
    })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<InventoryBloc>()..add(LoadInventory(businessId)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: Column(
              children: [
                // En-tête
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  color: AppColors.primaryLight,
                  child: const Text(
                    'Gestion du stock',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Corps
                Expanded(
                  child: BlocBuilder<InventoryBloc, InventoryState>(
                    builder: (context, state) {
                      if (state is InventoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is InventoryError) {
                        return Center(child: Text(state.message));
                      }
                      if (state is InventoryLoaded) {
                        final salesData = _buildSalesData(state.items);
                        final totalSales = salesData.fold(0.0, (sum, item) => sum + item.salesAmount);

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (salesData.isNotEmpty) ...[
                                SalesPieChart(
                                  data: salesData,
                                  totalSales: totalSales,
                                  isTablet: isTablet,
                                ),
                                const SizedBox(height: 16),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Articles en stock (${state.items.length})',
                                    style: TextStyle(fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () => context.read<InventoryBloc>().add(LoadInventory(businessId)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (state.items.isEmpty)
                                const Center(child: Text('Aucun article dans le stock'))
                              else
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isTablet ? 3 : 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1.2,
                                  ),
                                  itemCount: state.items.length,
                                  itemBuilder: (context, index) {
                                    final item = state.items[index];
                                    return InventoryItemCard(
                                      item: item,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value: context.read<InventoryBloc>(),
                                              child: InventoryDetailScreen(businessId: businessId, item: item),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: Builder(
              builder: (context) {
                return FloatingActionButton(
                  backgroundColor: AppColors.primaryLight,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<InventoryBloc>(),
                          child: AddEditItemScreen(businessId: businessId),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                );
              },
            ),
          );
        },
      ),
    );
  }
}