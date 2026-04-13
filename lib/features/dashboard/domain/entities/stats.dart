class DashboardStats {
  final int todayOrders;
  final int todayReservations;
  final double todayRevenue;
  final int pendingOrders;
  final int pendingReservations;
  final int previousTodayOrders;
  final int previousTodayReservations;
  final double previousTodayRevenue;
  final List<double> monthlyRevenues; // ← Nouveau champ

  const DashboardStats({
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
}