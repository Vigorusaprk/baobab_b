class InventoryItem {
  final int id;
  final String businessId;
  final String name;
  final double price;
  final bool isAvailable;
  final String? category;
  final String? description;
  final String? imageUrl;
  final String? ingredients;
  final int soldQuantity; // ✅ Quantité vendue
  final int quantity; // Quantité en stock

  const InventoryItem({
    required this.id,
    required this.businessId,
    required this.name,
    required this.price,
    required this.isAvailable,
    this.category,
    this.description,
    this.imageUrl,
    this.ingredients,
    this.soldQuantity = 0,
    this.quantity = 0, // Valeur par défaut
  });
}