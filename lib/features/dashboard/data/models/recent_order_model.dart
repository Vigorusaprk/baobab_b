import '../../domain/entities/recent_order.dart';

class RecentOrderModel extends RecentOrder {
  const RecentOrderModel({
    required super.id,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
  });

  factory RecentOrderModel.fromJson(Map<String, dynamic> json) {
    return RecentOrderModel(
      id: json['id'].toString(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}