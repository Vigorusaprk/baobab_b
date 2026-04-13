// lib/features/inventory/data/models/inventory_item_model.dart
import '../../domain/entities/inventory_item.dart';

class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required super.id,
    required super.businessId,
    required super.name,
    required super.price,
    required super.isAvailable,
    super.category,
    super.description,
    super.imageUrl,
    super.ingredients,
  });

  /// Convertit une valeur dynamique en double (gère String, num, null)
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Convertit une valeur dynamique en String? (gère List, String, null)
  static String? _toStringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) {
      // Si la liste contient des éléments, on les joint avec une virgule
      return value.isNotEmpty ? value.join(', ') : null;
    }
    return value.toString();
  }

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] as int,
      businessId: json['business_id'].toString(),
      name: json['item_name'] ?? '',
      price: _toDouble(json['price']),
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
      category: json['item_category'],
      description: json['description'],
      imageUrl: _toStringOrNull(json['image_url']),
      ingredients: _toStringOrNull(json['ingredients']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'item_name': name,
      'price': price,
      'is_available': isAvailable ? 1 : 0,
      'item_category': category,
      'description': description,
      'image_url': imageUrl,
      'ingredients': ingredients,
    };
  }

  /// Convertit le modèle en entité (utile pour le repository)
  InventoryItem toEntity() => this;
}