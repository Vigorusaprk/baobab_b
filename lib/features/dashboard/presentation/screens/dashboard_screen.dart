import 'package:baobab_business/core/di/service_locator.dart' as di;
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/business/presentation/bloc/business_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/mobile_dashboard.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/tablet_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  final String businessId;
  const DashboardScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BusinessCubit>(
          create: (_) => di.sl<BusinessCubit>()..loadBusiness(businessId),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => di.sl<DashboardBloc>()..add(FetchDashboardStats(businessId)),
        ),
      ],
      child: Builder(
        builder: (context) {
          final isTablet = MediaQuery.of(context).size.width >= 600;
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            body: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DashboardError) {
                  return Center(child: Text('Erreur : ${state.message}'));
                }
                if (state is DashboardLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<DashboardBloc>().add(FetchDashboardStats(businessId));
                    },
                    child: isTablet
                        ? TabletDashboard(
                      businessId: businessId,
                      stats: state.stats,
                      productSales: state.productSales,
                      recentOrders: state.recentOrders,
                    )
                        : MobileDashboard(
                      businessId: businessId,
                      stats: state.stats,
                      productSales: state.productSales,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}