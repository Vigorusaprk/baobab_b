import 'package:baobab_business/features/dashboard/data/models/customer_model.dart';
import 'package:dio/dio.dart';


abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers(String businessId, {int page = 1, int limit = 20});
  Future<int> getTotalCustomersCount(String businessId);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final Dio dio;
  CustomerRemoteDataSourceImpl({required this.dio}) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Requête : ${options.method} ${options.uri}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('Réponse : ${response.statusCode} ${response.data}');
        handler.next(response);
      },
      onError: (DioError e, handler) {
        print('Erreur : ${e.response?.statusCode} ${e.message}');
        handler.next(e);
      },
    ));
  }

  @override
  Future<List<CustomerModel>> getCustomers(String businessId, {int page = 1, int limit = 20}) async {
    final response = await dio.get('/api/businesses/$businessId/customers', queryParameters: {'page': page, 'limit': limit});
    final List data = response.data['customers'];
    return data.map((json) => CustomerModel.fromJson(json)).toList();
  }

  @override
  Future<int> getTotalCustomersCount(String businessId) async {
    final response = await dio.get('/api/businesses/$businessId/customers', queryParameters: {'page': 1, 'limit': 1});
    return response.data['total'] as int;
  }
}