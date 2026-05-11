import '../../domain/entities/product_sale.dart';

class ProductSaleModel extends ProductSale {
  const ProductSaleModel({
    required super.productName,
    required super.quantity,
    required super.revenue,
  });

  factory ProductSaleModel.fromJson(Map<String, dynamic> json) {
    // Conversion robuste de la quantité (peut être String ou int)
    final int quantity = _toInt(json['quantity']);
    // Conversion robuste du revenu (peut être String ou double)
    final double revenue = _toDouble(json['revenue']);

    return ProductSaleModel(
      productName: json['product_name'] ?? '',
      quantity: quantity,
      revenue: revenue,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  ProductSale toEntity() => ProductSale(
    productName: productName,
    quantity: quantity,
    revenue: revenue,
  );
}