// lib/features/customers/domain/entities/customer.dart
class Customer {
  final String id;
  final String name;
  final String email;
  final String? imgUrl;

  const Customer({
    required this.id,
    required this.name,
    required this.email,
    this.imgUrl,
  });
}