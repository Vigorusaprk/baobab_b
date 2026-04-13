part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override List<Object> get props => [];
}
class FetchDashboardStats extends DashboardEvent {
  final String businessId;
  const FetchDashboardStats(this.businessId);
  @override List<Object> get props => [businessId];
}