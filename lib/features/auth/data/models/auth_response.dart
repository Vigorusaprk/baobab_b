class AuthResponse {
  final String id;
  final String name;
  final String email;
  final String token;
  final String? businessId;
  final String? imgUrl; // ← ajout

  AuthResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.businessId,
    this.imgUrl,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    token: json['token'],
    businessId: json['businessId'],
    imgUrl: json['img_url'], // ← on lit le champ de la réponse API
  );
}