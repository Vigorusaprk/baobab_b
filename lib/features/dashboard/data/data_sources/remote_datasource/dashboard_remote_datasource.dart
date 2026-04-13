import 'package:baobab_business/features/dashboard/data/models/stats_model.dart';
import 'package:dio/dio.dart';


abstract class DashboardRemoteDataSource {
  Future<StatsModel> getDashboardStats(String businessId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio; final String baseUrl;
  DashboardRemoteDataSourceImpl({required this.dio, this.baseUrl = 'http://10.0.2.2:3000/api'});
  @override
  Future<StatsModel> getDashboardStats(String businessId) async {
    final response = await dio.get('$baseUrl/businesses/$businessId/stats');
    return StatsModel.fromJson(response.data);
  }
}