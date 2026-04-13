import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? businessId;

  const User({required this.id, required this.name, required this.email, this.businessId});

  @override
  List<Object?> get props => [id, name, email, businessId];
}