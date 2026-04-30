import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/features/dashboard/domain/entities/stats.dart';
import 'package:baobab_business/features/dashboard/presentation/widgets/sales_pie_chart.dart'; // pour ProductSalesData
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_dashboard_stats.dart';
import '../../domain/usecases/get_product_sales.dart'; // ✅ Nouveau use case

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStats getDashboardStats;
  final GetProductSales getProductSales; // ✅ Ajouté

  DashboardBloc({
    required this.getDashboardStats,
    required this.getProductSales,
  }) : super(DashboardInitial()) {
    on<FetchDashboardStats>(_onFetch);
  }

  Future<void> _onFetch(FetchDashboardStats event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      // Exécuter les deux appels en parallèle
      final results = await Future.wait([
        getDashboardStats(event.businessId),
        getProductSales(event.businessId),
      ]);

      final statsResult = results[0] as Either<Failure, DashboardStats>;
      final salesResult = results[1] as Either<Failure, List<ProductSalesData>>;

      // Gérer les erreurs éventuelles
      if (statsResult.isLeft()) {
        emit(DashboardError(statsResult.fold((l) => l.message, (r) => '')));
        return;
      }

      final stats = statsResult.getOrElse(() => throw Exception());
      // Si l'appel des ventes échoue, on peut mettre une liste vide
      final productSales = salesResult.fold((l) => <ProductSalesData>[], (r) => r);

      emit(DashboardLoaded(stats, productSales));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}