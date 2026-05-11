class RecentOrder {
  final String id;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const RecentOrder({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });
}