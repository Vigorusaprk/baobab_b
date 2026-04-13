import 'package:equatable/equatable.dart';

class Business extends Equatable {
  final String id;
  final String name;
  final String type; // 'restaurant', 'hotel', 'cinema', etc.
  final Map<String, dynamic> specificData; // Horaires, étoiles, équipements...

  const Business({
    required this.id,
    required this.name,
    required this.type,
    required this.specificData,
  });

  @override
  List<Object?> get props => [id, name, type, specificData];
}