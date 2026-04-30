import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/core/until/variation_helper.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/animated_trend_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueSection extends StatelessWidget {
  const RevenueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        return BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return _buildLoading(isTablet);
            }
            if (state is DashboardError) {
              return _buildError(state.message, isTablet);
            }
            if (state is DashboardLoaded) {
              // Calcul de la variation du CA par rapport à hier
              final revenueVar = computeVariation(
                state.stats.todayRevenue,
                state.stats.previousTodayRevenue,
              );

              return isTablet
                  ? _buildTabletLayout(state.stats, revenueVar)
                  : _buildMobileLayout(state.stats, revenueVar);
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  // ---------- LOADING ----------
  Widget _buildLoading(bool isTablet) {
    return Container(
      height: isTablet ? 200 : 155,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  // ---------- ERROR ----------
  Widget _buildError(String message, bool isTablet) {
    return Container(
      height: isTablet ? 200 : 155,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'Erreur : $message',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  // ---------- LAYOUT MOBILE ----------
  Widget _buildMobileLayout(dynamic stats, VariationData revenueVar) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 155,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CA du jour",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(DateTime.now().toString().substring(0, 10)),
            ],
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Indicateur de variation animé
              AnimatedTrendIndicator(variation: revenueVar),
              const SizedBox(width: 8),
              // Valeur du CA
              Text(
                '${stats.todayRevenue.toStringAsFixed(2)} €',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: AppColors.scaffoldBackground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- LAYOUT TABLETTE ----------
  Widget _buildTabletLayout(dynamic stats, VariationData revenueVar) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                "Chiffre d'affaires du jour",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateTime.now().toString().substring(0, 10),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${stats.todayRevenue.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '€',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              // ✅ Indicateur de variation animé
              AnimatedTrendIndicator(
                variation: revenueVar,
                isTablet: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}