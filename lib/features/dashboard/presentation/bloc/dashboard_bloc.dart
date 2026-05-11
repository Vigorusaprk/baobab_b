import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/features/dashboard/domain/entities/stats.dart';
import 'package:baobab_business/features/dashboard/domain/entities/product_sale.dart';
import 'package:baobab_business/features/dashboard/domain/entities/recent_order.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_dashboard_stats.dart';
import '../../domain/usecases/get_product_sales.dart';
import '../../domain/usecases/get_recent_orders.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStats getDashboardStats;
  final GetProductSales getProductSales;
  final GetRecentOrders getRecentOrders;

  DashboardBloc({
    required this.getDashboardStats,
    required this.getProductSales,
    required this.getRecentOrders,
  }) : super(DashboardInitial()) {
    on<FetchDashboardStats>(_onFetch);
  }

  Future<void> _onFetch(FetchDashboardStats event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final results = await Future.wait([
        getDashboardStats(event.businessId),
        getProductSales(event.businessId),
        getRecentOrders(event.businessId),
      ]);

      final statsResult = results[0] as Either<Failure, DashboardStats>;
      final salesResult = results[1] as Either<Failure, List<ProductSale>>;
      final ordersResult = results[2] as Either<Failure, List<RecentOrder>>;

      if (statsResult.isLeft()) {
        emit(DashboardError(statsResult.fold((l) => l.message, (r) => '')));
        return;
      }

      final stats = statsResult.getOrElse(() => throw Exception());
      final productSales = salesResult.fold((l) => <ProductSale>[], (r) => r);
      final recentOrders = ordersResult.fold((l) => <RecentOrder>[], (r) => r);

      emit(DashboardLoaded(stats, productSales, recentOrders));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}