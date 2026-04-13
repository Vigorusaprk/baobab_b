import 'package:baobab_business/core/until/variation_helper.dart';
import 'package:baobab_business/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherInfoSection extends StatelessWidget {
  const OtherInfoSection({super.key});

  String? _getBusinessId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.businessId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final businessId = _getBusinessId(context);
    if (businessId == null) {
      return const Center(
        child: Text('Commerce non trouvé', style: TextStyle(color: Colors.red)),
      );
    }

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DashboardLoaded) {
          final stats = state.stats;

          // Calcul des variations
          final ordersVar = computeVariation(stats.todayOrders, stats.previousTodayOrders);
          final reservationsVar = computeVariation(stats.todayReservations, stats.previousTodayReservations);
          final revenueVar = computeVariation(stats.todayRevenue, stats.previousTodayRevenue);
          // Pour les "en attente", on n'a pas de comparaison historique, on met null
          final pendingOrdersVar = null;
          final pendingReservationsVar = null;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(FetchDashboardStats(businessId));
            },
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  'Commandes',
                  stats.todayOrders.toString(),
                  Icons.shopping_cart,
                  Colors.blue,
                  'vs hier',
                  ordersVar,
                ),
                _buildStatCard(
                  'Réservations',
                  stats.todayReservations.toString(),
                  Icons.calendar_today,
                  Colors.orange,
                  'vs hier',
                  reservationsVar,
                ),
                _buildStatCard(
                  'Commandes en attente',
                  stats.pendingOrders.toString(),
                  Icons.pending_actions,
                  Colors.red,
                  'en cours',
                  pendingOrdersVar,
                ),
                _buildStatCard(
                  'Réservations en attente',
                  stats.pendingReservations.toString(),
                  Icons.pending,
                  Colors.purple,
                  'en cours',
                  pendingReservationsVar,
                ),
              ],
            ),
          );
        }
        if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                Text('Erreur : ${state.message}'),
                ElevatedButton(
                  onPressed: () => context.read<DashboardBloc>().add(
                    FetchDashboardStats(businessId),
                  ),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      String subtitle,
      VariationData? variation,
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 20, color: color),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                if (variation != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: variation.isPositive ? Colors.green.shade100 : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          variation.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color: variation.isPositive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          variation.formatted,
                          style: TextStyle(
                            color: variation.isPositive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}