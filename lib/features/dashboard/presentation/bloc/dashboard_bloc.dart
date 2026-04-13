import 'package:baobab_business/features/dashboard/domain/entities/stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_dashboard_stats.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStats getDashboardStats;
  DashboardBloc({required this.getDashboardStats}) : super(DashboardInitial()) {
    on<FetchDashboardStats>(_onFetch);
  }
  Future<void> _onFetch(FetchDashboardStats event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    final result = await getDashboardStats(event.businessId);
    result.fold((f) => emit(DashboardError(f.message)), (s) => emit(DashboardLoaded(s)));
  }
}