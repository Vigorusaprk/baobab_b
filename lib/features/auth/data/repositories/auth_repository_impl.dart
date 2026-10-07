import 'package:baobab_business/core/errors/failure.dart';
import 'package:baobab_business/core/until/jwt_helper.dart'; // Conservé selon ton architecture
import 'package:baobab_business/features/auth/data/data_sources/remote_datasource/auth_remote_datasource.dart'; //[cite: 17]
import 'package:dartz/dartz.dart'; //[cite: 17]
import 'package:shared_preferences/shared_preferences.dart'; //[cite: 17]
import '../../domain/entities/user.dart'; //[cite: 17]
import '../../domain/repositories/auth_repository.dart'; //[cite: 17]

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;

  static const String _tokenKey = 'auth_token'; //[cite: 17]
  static const String _loginTimeKey = 'auth_login_time'; // Clé ajoutée pour le timestamp de 24h

  AuthRepositoryImpl({required this.remoteDataSource, required this.prefs}); //[cite: 17]

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    print('🌐 [AUTH_REPO] Appel à remoteDataSource.login'); //[cite: 17]
    try {
      final res = await remoteDataSource.login(email, password); //[cite: 17]
      print('✅ [AUTH_REPO] Réponse reçue - token: ${res.token.substring(0, 20)}...'); //[cite: 17]

      // Sauvegarde locale du token ET de la date/heure actuelle
      await prefs.setString(_tokenKey, res.token); //[cite: 17]
      await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      print('💾 [AUTH_REPO] Token et Timestamp (24h) sauvegardés dans SharedPreferences');

      return Right(User(
        id: res.id,
        name: res.name,
        email: res.email,
        businessId: res.businessId,
        imgUrl: res.imgUrl, // Ajouté : Correction du mappage manquant
      ));
    } catch (e) {
      print('❌ [AUTH_REPO] Erreur login : $e'); //[cite: 17]
      return Left(ServerFailure(e.toString())); //[cite: 17]
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password, String phone) async {
    print('🌐 [AUTH_REPO] Appel à remoteDataSource.register'); //[cite: 17]
    try {
      final res = await remoteDataSource.register(name, email, password, phone); //[cite: 17]

      // Sauvegarde locale du token ET de la date/heure actuelle lors de l'inscription
      await prefs.setString(_tokenKey, res.token); //[cite: 17]
      await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());

      return Right(User(
        id: res.id,
        name: res.name,
        email: res.email,
        businessId: res.businessId,
        imgUrl: res.imgUrl, // Ajouté : Correction du mappage manquant
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString())); //[cite: 17]
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    print('🔍 [AUTH_REPO] getCurrentUser appelé'); //[cite: 17]
    final token = prefs.getString(_tokenKey); //[cite: 17]
    final loginTimeStr = prefs.getString(_loginTimeKey);

    // 1. Vérification de la présence des données de session
    if (token == null || loginTimeStr == null) {
      print('❌ [AUTH_REPO] Aucun token ou timestamp trouvé dans SharedPreferences'); //[cite: 17]
      await logout(); // Par sécurité, on nettoie la session
      return Left(ServerFailure('Token or Session timestamp is null')); //[cite: 17]
    }
    print('✅ [AUTH_REPO] Token récupéré : $token'); //[cite: 17]

    // 2. Calcul et validation de la limite des 24 heures
    final DateTime loginTime = DateTime.parse(loginTimeStr);
    final Duration sessionDuration = DateTime.now().difference(loginTime);

    if (sessionDuration.inHours >= 24) {
      print('⏰ [AUTH_REPO] Session expirée (${sessionDuration.inHours}h écoulées). Déconnexion automatique.');
      await logout();
      return Left(ServerFailure('La session de 24 heures a expiré'));
    }

    // 3. Vérification via le JwtHelper existant
    if (JwtHelper.isTokenExpired(token)) {
      print('⏰ [AUTH_REPO] Token expiré d\'après JwtHelper, déconnexion'); //[cite: 17]
      await logout(); //[cite: 17]
      return Left(ServerFailure('Token expiré')); //[cite: 17]
    }

    try {
      final res = await remoteDataSource.getCurrentUser(token); //[cite: 17]
      return Right(User(
        id: res.id,
        name: res.name,
        email: res.email,
        businessId: res.businessId,
        imgUrl: res.imgUrl, // Ajouté : Correction du mappage manquant[cite: 11, 12]
      ));
    } catch (e) {
      print('❌ [AUTH_REPO] getCurrentUser a échoué : $e'); //[cite: 17]
      return Left(ServerFailure(e.toString())); //[cite: 17]
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    print('🚪 [AUTH_REPO] Nettoyage complet des SharedPreferences (Token & Timestamp)');
    await prefs.remove(_tokenKey); //[cite: 17]
    await prefs.remove(_loginTimeKey); // Supprime également le timestamp à la déconnexion
    return const Right(null); //[cite: 17]
  }
}