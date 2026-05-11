import 'package:dio/dio.dart';
import '../../models/stats_model.dart';
import '../../models/product_sale_model.dart';
import '../../models/recent_order_model.dart'; // à créer si pas encore fait

abstract class DashboardRemoteDataSource {
  Future<StatsModel> getStats(String businessId);
  Future<List<ProductSaleModel>> getProductSales(String businessId);
  Future<List<RecentOrderModel>> getRecentOrders(String businessId); // nouvelle méthode
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  DashboardRemoteDataSourceImpl({required this.dio, this.baseUrl = 'http://10.0.2.2:3000/api'});

  @override
  Future<StatsModel> getStats(String businessId) async {
    final response = await dio.get('$baseUrl/businesses/$businessId/stats');
    return StatsModel.fromJson(response.data);
  }

  @override
  Future<List<ProductSaleModel>> getProductSales(String businessId) async {
    final response = await dio.get('$baseUrl/businesses/$businessId/stats/products');
    final List data = response.data;
    return data.map((json) => ProductSaleModel.fromJson(json)).toList();
  }

  @override
  Future<List<RecentOrderModel>> getRecentOrders(String businessId) async {
    final response = await dio.get('$baseUrl/businesses/$businessId/recent-orders');
    final List data = response.data;
    return data.map((json) => RecentOrderModel.fromJson(json)).toList();
  }
}