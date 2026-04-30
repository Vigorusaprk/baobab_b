import 'package:baobab_business/core/di/service_locator.dart' as di;
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/business/presentation/bloc/business_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/client_liste.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/header_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/monthly_income_chart.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/oter_info_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/revenu_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/sales_pie_chart.dart';
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
          create: (_) => di.sl<DashboardBloc>()
            ..add(FetchDashboardStats(businessId)),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;
          return BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DashboardError) {
                return Center(child: Text('Erreur : ${state.message}'));
              }
              if (state is DashboardLoaded) {
                final totalProductSales = state.productSales.fold(
                  0.0,
                      (sum, item) => sum + item.salesAmount,
                );
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<DashboardBloc>().add(FetchDashboardStats(businessId));
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const HeaderSection(),
                        const SizedBox(height: 16),
                        if (isTablet)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Expanded(child: RevenueSection()),
                              SizedBox(width: 16),
                              Expanded(child: OtherInfoSection()),
                            ],
                          )
                        else ...[
                          const RevenueSection(),
                          const OtherInfoSection(),
                        ],
                        const SizedBox(height: 20),
                        MonthlyIncomeChart(
                          monthlyData: state.stats.monthlyRevenues,
                        ),
                        if (state.productSales.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          SalesPieChart(
                            data: state.productSales,
                            totalSales: totalProductSales,
                            isTablet: isTablet,
                          ),
                        ],
                        const SizedBox(height: 20),
                        CustomerListWidget(businessId: businessId),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}