import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueSection extends StatelessWidget {
  const RevenueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        // Gestion des différents états
        if (state is DashboardLoading) {
          return Container(
            height: 155,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is DashboardError) {
          return Container(
            height: 155,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Erreur : ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is DashboardLoaded) {
          final stats = state.stats; // ✅ stats est maintenant accessible partout

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
                    Text(DateTime.now().toString().substring(0, 10)), // date du jour
                  ],
                ),
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 8),
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

        // État par défaut (ne devrait jamais arriver)
        return const SizedBox.shrink();
      },
    );
  }
}