import 'package:baobab_business/core/until/variation_helper.dart';
import 'package:baobab_business/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/animated_trend_indicator.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        return BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('Erreur : ${state.message}'),
                    const SizedBox(height: 16),
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
            if (state is DashboardLoaded) {
              return isTablet
                  ? _buildTabletLayout(context, state.stats, businessId)
                  : _buildMobileLayout(context, state.stats, businessId);
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, dynamic stats, String businessId) {
    final ordersVar = computeVariation(stats.todayOrders, stats.previousTodayOrders);
    final reservationsVar = computeVariation(stats.todayReservations, stats.previousTodayReservations);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(FetchDashboardStats(businessId));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
              null,
            ),
            _buildStatCard(
              'Réservations en attente',
              stats.pendingReservations.toString(),
              Icons.pending,
              Colors.purple,
              'en cours',
              null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, dynamic stats, String businessId) {
    final ordersVar = computeVariation(stats.todayOrders, stats.previousTodayOrders);
    final reservationsVar = computeVariation(stats.todayReservations, stats.previousTodayReservations);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(FetchDashboardStats(businessId));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: [
                _buildStatCard(
                  'Commandes',
                  stats.todayOrders.toString(),
                  Icons.shopping_cart,
                  Colors.blue,
                  'par rapport à hier',
                  ordersVar,
                  isTablet: true,
                ),
                _buildStatCard(
                  'Réservations',
                  stats.todayReservations.toString(),
                  Icons.calendar_today,
                  Colors.orange,
                  'par rapport à hier',
                  reservationsVar,
                  isTablet: true,
                ),
                _buildStatCard(
                  'Commandes en attente',
                  stats.pendingOrders.toString(),
                  Icons.pending_actions,
                  Colors.red,
                  'à traiter',
                  null,
                  isTablet: true,
                ),
                _buildStatCard(
                  'Réservations en attente',
                  stats.pendingReservations.toString(),
                  Icons.pending,
                  Colors.purple,
                  'à confirmer',
                  null,
                  isTablet: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      String subtitle,
      VariationData? variation, {
        bool isTablet = false,
      }) {
    return Card(
      elevation: isTablet ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isTablet ? 16 : 12)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: isTablet ? 22 : 20, color: color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                // ✅ Indicateur animé remplace l'ancien conteneur statique
                if (variation != null)
                  AnimatedTrendIndicator(
                    variation: variation,
                    isTablet: isTablet,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isTablet ? 13 : 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}