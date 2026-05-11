import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/core/until/jwt_helper.dart';
import 'package:baobab_business/features/auth/data/data_sources/remote_datasource/auth_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;
  static const String _tokenKey = 'auth_token';

  AuthRepositoryImpl({required this.remoteDataSource, required this.prefs});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    print('🌐 [AUTH_REPO] Appel à remoteDataSource.login');
    try {
      final res = await remoteDataSource.login(email, password);
      print('✅ [AUTH_REPO] Réponse reçue - token: ${res.token.substring(0, 20)}...');
      await prefs.setString(_tokenKey, res.token);
      print('💾 [AUTH_REPO] Token sauvegardé dans SharedPreferences');
      return Right(User(
        id: res.id,
        name: res.name,
        email: res.email,
        businessId: res.businessId,
      ));
    } catch (e) {
      print('❌ [AUTH_REPO] Erreur login : $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password, String phone) async {
    print('🌐 [AUTH_REPO] Appel à remoteDataSource.register');
    try {
      final res = await remoteDataSource.register(name, email, password, phone);
      await prefs.setString(_tokenKey, res.token);
      return Right(User(id: res.id, name: res.name, email: res.email, businessId: res.businessId));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    print('🔍 [AUTH_REPO] getCurrentUser appelé');
    final token = prefs.getString(_tokenKey);
    if (token == null) {
      print('❌ [AUTH_REPO] Aucun token trouvé dans SharedPreferences');
      return Left(ServerFailure('Token is null'));
    }
    print('✅ [AUTH_REPO] Token récupéré : $token');
    if (JwtHelper.isTokenExpired(token)) {
      print('⏰ [AUTH_REPO] Token expiré, déconnexion');
      await logout();
      return Left(ServerFailure('Token expiré'));
    }
    try {
      final res = await remoteDataSource.getCurrentUser(token);
      return Right(User(id: res.id, name: res.name, email: res.email, businessId: res.businessId));
    } catch (e) {
      print('❌ [AUTH_REPO] getCurrentUser a échoué : $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await prefs.remove(_tokenKey);
    return const Right(null);
  }
}