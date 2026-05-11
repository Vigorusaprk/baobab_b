import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? businessId;
  final String? imgUrl;

  const User({required this.id, required this.name, required this.email, this.businessId, this.imgUrl});

  @override
  List<Object?> get props => [id, name, email, businessId];
}