import '../../domain/entities/stats.dart';

class StatsModel {
  final int todayOrders;
  final int todayReservations;
  final double todayRevenue;
  final int pendingOrders;
  final int pendingReservations;
  final int previousTodayOrders;
  final int previousTodayReservations;
  final double previousTodayRevenue;
  final List<double> monthlyRevenues;

  StatsModel({
    required this.todayOrders,
    required this.todayReservations,
    required this.todayRevenue,
    required this.pendingOrders,
    required this.pendingReservations,
    required this.previousTodayOrders,
    required this.previousTodayReservations,
    required this.previousTodayRevenue,
    required this.monthlyRevenues,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      todayOrders: json['todayOrders'] ?? 0,
      todayReservations: json['todayReservations'] ?? 0,
      todayRevenue: (json['todayRevenue'] as num?)?.toDouble() ?? 0.0,
      pendingOrders: json['pendingOrders'] ?? 0,
      pendingReservations: json['pendingReservations'] ?? 0,
      previousTodayOrders: json['previousTodayOrders'] ?? 0,
      previousTodayReservations: json['previousTodayReservations'] ?? 0,
      previousTodayRevenue: (json['previousTodayRevenue'] as num?)?.toDouble() ?? 0.0,
      monthlyRevenues: (json['monthlyRevenues'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList() ?? List.filled(12, 0.0),
    );
  }

  DashboardStats toEntity() {
    return DashboardStats(
      todayOrders: todayOrders,
      todayReservations: todayReservations,
      todayRevenue: todayRevenue,
      pendingOrders: pendingOrders,
      pendingReservations: pendingReservations,
      previousTodayOrders: previousTodayOrders,
      previousTodayReservations: previousTodayReservations,
      previousTodayRevenue: previousTodayRevenue,
      monthlyRevenues: monthlyRevenues,
    );
  }
}