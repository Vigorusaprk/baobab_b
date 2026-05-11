part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardStats stats;
  final List<ProductSale> productSales;
  final List<RecentOrder> recentOrders;

  const DashboardLoaded(this.stats, this.productSales, this.recentOrders);

  @override
  List<Object> get props => [stats, productSales, recentOrders];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override List<Object> get props => [message];
}