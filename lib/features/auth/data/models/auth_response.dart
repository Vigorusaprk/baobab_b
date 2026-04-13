class AuthResponse {
  final String id;
  final String name;
  final String email;
  final String token;
  final String? businessId;

  AuthResponse({required this.id, required this.name, required this.email, required this.token, this.businessId});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    token: json['token'],
    businessId: json['businessId'],
  );
}