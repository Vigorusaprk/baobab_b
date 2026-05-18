import 'package:baobab_business/features/inventory/domain/entities/inventory_item.dart';
import 'package:baobab_business/features/inventory/presentation/widgets/inventory_detail_screen.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/sales_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/inventory_bloc.dart';

class MobilInventory extends StatelessWidget {
  final String businessId;
  const MobilInventory({super.key, required this.businessId});

  List<ProductSalesData> _buildSalesData(List<InventoryItem> items) {
    final filteredItems = items.where((item) => item.soldQuantity > 0).toList();
    return filteredItems.map((item) {
      final salesAmount = item.price * item.soldQuantity;
      return ProductSalesData(
        productName: item.name,
        salesAmount: salesAmount,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<InventoryBloc>()..add(LoadInventory(businessId)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header moderne avec titre et recherche
                  SliverToBoxAdapter(
                    child: _buildHeader(context),
                  ),
                  
                  // Contenu principal
                  SliverToBoxAdapter(
                    child: BlocBuilder<InventoryBloc, InventoryState>(
                      builder: (context, state) {
                        if (state is InventoryLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(50),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is InventoryError) {
                          return Padding(
                            padding: const EdgeInsets.all(50),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.message,
                                    style: TextStyle(color: Colors.grey[600]),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (state is InventoryLoaded) {
                          final salesData = _buildSalesData(state.items);
                          final totalSales = salesData.fold(0.0, (sum, item) => sum + item.salesAmount);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                
                                // Graphique des ventes (si données disponibles)
                                if (salesData.isNotEmpty) ...[
                                  _buildSectionTitle('Performance des ventes', onViewAll: null),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: SalesPieChart(
                                      data: salesData,
                                      totalSales: totalSales,
                                      isTablet: isTablet,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],

                                // Section Articles en stock
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSectionTitle(
                                      'Articles en stock',
                                      subtitle: '${state.items.length} produits',
                                    ),
                                    _buildRefreshButton(context),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Grille de produits style "Best Seller" de l'image
                                if (state.items.isEmpty)
                                  _buildEmptyState()
                                else
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isTablet ? 3 : 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.85, // Plus haut pour accommoder le design image
                                    ),
                                    itemCount: state.items.length,
                                    itemBuilder: (context, index) {
                                      final item = state.items[index];
                                      return _buildProductCard(context, item);
                                    },
                                  ),
                                  
                                const SizedBox(height: 24),
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
            ),
          );
        },
      ),
    );
  }

  // Header moderne avec barre de recherche
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gestion du stock',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gérez vos produits efficacement',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              // Avatar/Profil placeholder (comme dans l'image)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.store,
                  color: Color(0xFFFFB800),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Barre de recherche style image
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un article...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Titre de section style image
  Widget _buildSectionTitle(String title, {String? subtitle, VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
                letterSpacing: -0.3,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Row(
              children: [
                Text(
                  'Voir tout',
                  style: TextStyle(
                    color: const Color(0xFFFFB800),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFFFB800)),
              ],
            ),
          ),
      ],
    );
  }

  // Bouton refresh stylisé
  Widget _buildRefreshButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFB800).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.refresh, color: Color(0xFFFFB800), size: 20),
        onPressed: () => context.read<InventoryBloc>().add(LoadInventory(businessId)),
        splashRadius: 24,
      ),
    );
  }

  // État vide stylisé
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Aucun article dans le stock',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Carte produit style "Best Seller" de l'image
  Widget _buildProductCard(BuildContext context, InventoryItem item) {
    final bool isLowStock = item.quantity <= 5; // Seuil de stock faible

    return GestureDetector(
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone image avec badge si nécessaire
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.network(
                                item.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                              ),
                            )
                          : _buildPlaceholderImage(),
                    ),
                  ),
                  // Badge "Stock faible" ou promotion
                  
                  // Menu options (3 points)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Zone info
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}