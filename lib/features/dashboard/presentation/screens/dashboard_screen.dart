import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/business/presentation/bloc/business_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/client_liste.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/header_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/monthly_income_chart.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/oter_info_section.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/revenu_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart' as di;
import '../bloc/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  final String businessId;
  const DashboardScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BusinessCubit>(
          create: (context) => di.sl<BusinessCubit>()..loadBusiness(businessId),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => di.sl<DashboardBloc>()..add(FetchDashboardStats(businessId)),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                return Column(
                  children: [
                    const HeaderSection(),
                    const SizedBox(height: 15),
                    RevenueSection(),
                    const OtherInfoSection(),
                    const SizedBox(height: 15),
                    // Graphique des revenus mensuels
                    MonthlyIncomeChart(
                      monthlyData: state.stats.monthlyRevenues,
                    ),
                    const SizedBox(height: 20),
                    CustomerListWidget(businessId: businessId,)
                  ],
                );
              }
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DashboardError) {
                return Center(child: Text('Erreur : ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}