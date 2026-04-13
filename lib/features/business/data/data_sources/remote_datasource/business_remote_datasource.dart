import 'package:baobab_business/features/business/data/models/business_model.dart';
import 'package:dio/dio.dart';


abstract class BusinessRemoteDataSource {
  Future<BusinessModel> getBusiness(String businessId);
}

class BusinessRemoteDataSourceImpl implements BusinessRemoteDataSource {
  final Dio dio;
  BusinessRemoteDataSourceImpl({required this.dio});

  @override
  Future<BusinessModel> getBusiness(String businessId) async {
    final response = await dio.get('/api/businesses/$businessId');
    return BusinessModel.fromJson(response.data);
  }
}