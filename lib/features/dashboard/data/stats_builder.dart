import 'package:baobab_business/core/merchant/merchant_parsing.dart';
import 'models/stats_model.dart';

/// Calcule les chiffres du dashboard à partir de la réponse de
/// `get-merchant-space` (commandes et réservations récentes + stats serveur).
///
/// Limite connue : le serveur ne renvoie que les 50 dernières commandes et
/// 80 dernières réservations. Les chiffres du jour, d'hier et du graphique
/// mensuel sont donc exacts pour une activité normale, mais le graphique
/// d'un commerce très actif ne couvrira que la période récente.
StatsModel buildStats(Map<String, dynamic> data) {
  final orders = asRows(data['orders']);
  final reservations = asRows(data['reservations']);
  final server = data['stats'] is Map
      ? Map<String, dynamic>.from(data['stats'] as Map)
      : <String, dynamic>{};

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  bool onDay(Object? raw, DateTime day) {
    final d = asInstant(raw);
    return d != null && d.year == day.year && d.month == day.month && d.day == day.day;
  }

  bool alive(Map<String, dynamic> r) => r['status'] != 'cancelled';
  // Même règle que le serveur : seul le prêt ou livré compte comme encaissé.
  bool paid(Map<String, dynamic> o) => o['status'] == 'delivered' || o['status'] == 'ready';
  double total(Map<String, dynamic> o) => asDouble(o['total_amount'] ?? o['total_price']);

  int ordersOn(DateTime day) =>
      orders.where((o) => alive(o) && onDay(o['created_at'], day)).length;
  int reservationsOn(DateTime day) => reservations
      .where((r) => alive(r) && onDay(r['reservation_date'], day))
      .length;
  double revenueOn(DateTime day) => orders
      .where((o) => paid(o) && onDay(o['created_at'], day))
      .fold(0.0, (sum, o) => sum + total(o));

  // Recettes encaissées par mois, pour l'année en cours.
  final monthly = List<double>.filled(12, 0.0);
  for (final o in orders.where(paid)) {
    final d = asInstant(o['created_at']);
    if (d != null && d.year == now.year) monthly[d.month - 1] += total(o);
  }

  return StatsModel(
    todayOrders: ordersOn(today),
    todayReservations: reservationsOn(today),
    todayRevenue: revenueOn(today),
    pendingOrders: asInt(server['pendingOrders']),
    pendingReservations: asInt(server['pendingReservations']),
    previousTodayOrders: ordersOn(yesterday),
    previousTodayReservations: reservationsOn(yesterday),
    previousTodayRevenue: revenueOn(yesterday),
    monthlyRevenues: monthly,
  );
}
