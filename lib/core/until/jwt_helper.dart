import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  static bool isTokenExpired(String token) => JwtDecoder.isExpired(token);
}