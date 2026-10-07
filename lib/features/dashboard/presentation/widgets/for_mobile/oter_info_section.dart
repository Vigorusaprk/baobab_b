import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/core/until/variation_helper.dart';
import 'package:baobab_business/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/for_mobile/animated_trend_indicator.dart';
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
              'vs hier',
              ordersVar,
            ),
            _buildStatCard(
              'Réservations',
              stats.todayReservations.toString(),
              Icons.calendar_today,
              'vs hier',
              reservationsVar,
            ),
            _buildStatCard(
              'Commandes en attente',
              stats.pendingOrders.toString(),
              Icons.pending_actions,
              'en cours',
              null,
            ),
            _buildStatCard(
              'Réservations en attente',
              stats.pendingReservations.toString(),
              Icons.pending,
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

    // Calcul d’une largeur adaptative pour chaque carte (20% de l’écran, limitée)
    final screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.22;
    cardWidth = cardWidth.clamp(180.0, 260.0); // Ni trop petite, ni trop grande

    final List<Widget> cards = [
      _buildStatCard(
        'Commandes',
        stats.todayOrders.toString(),
        Icons.shopping_cart,
        'par rapport à hier',
        ordersVar,
        isTablet: true,
        width: cardWidth,
      ),

      SizedBox(width: 25,),
      _buildStatCard(
        'Réservations',
        stats.todayReservations.toString(),
        Icons.calendar_today,
        'par rapport à hier',
        reservationsVar,
        isTablet: true,
        width: cardWidth,
      ),

      SizedBox(width: 25,),
      _buildStatCard(
        'Commandes en attente',
        stats.pendingOrders.toString(),
        Icons.pending_actions,
        'à traiter',
        null,
        isTablet: true,
        width: cardWidth,
      ),

      SizedBox(width: 25,),
      _buildStatCard(
        'Réservations en attente',
        stats.pendingReservations.toString(),
        Icons.pending,
        'à confirmer',
        null,
        isTablet: true,
        width: cardWidth,
      ),
    ];

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(FetchDashboardStats(businessId));
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cards,
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      String subtitle,
      VariationData? variation, {
        bool isTablet = false,
        double? width,
      }) {
    return SizedBox(
      width: width,
      child: Card(
        color: Colors.white,
        elevation: isTablet ? 4 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isTablet ? 16 : 12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: EdgeInsets.all(isTablet ? 10 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryLight.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, size: isTablet ? 25 : 20, color: AppColors.secondary),
                          ),
                          SizedBox(width: 8,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: isTablet ? 28 : 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(width: 8),
                                  if (variation != null)
                                    AnimatedTrendIndicator(
                                      variation: variation,
                                      isTablet: isTablet,
                                    ),
                                ],
                              ),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: isTablet ? 13 : 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}