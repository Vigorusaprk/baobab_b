import 'package:baobab_business/features/auth/data/models/auth_response.dart';
import 'package:dio/dio.dart';


abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(String name, String email, String password, String phone);
  Future<AuthResponse> getCurrentUser(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.dio, this.baseUrl = 'http://10.0.2.2:3000/api'});

  @override
  Future<AuthResponse> login(String email, String password) async {
    print('📡 [AUTH_DS] Requête POST vers $baseUrl/auth/login');
    print('   Payload: email=$email, password=****');
    try {
      final response = await dio.post('$baseUrl/auth/login', data: {
        'email': email,
        'password': password,
      });
      print('📥 [AUTH_DS] Réponse HTTP ${response.statusCode}');
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      print('❌ [AUTH_DS] Exception: $e');
      rethrow;
    }
  }

  @override
  Future<AuthResponse> register(String name, String email, String password, String phone) async {
    final response = await dio.post('$baseUrl/auth/signup', data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });
    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<AuthResponse> getCurrentUser(String token) async {
    final response = await dio.get(
      '$baseUrl/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return AuthResponse.fromJson(response.data);
  }
}