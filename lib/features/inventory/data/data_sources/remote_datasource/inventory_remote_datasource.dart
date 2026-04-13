import 'package:baobab_business/features/inventory/data/models/inventory_item_model.dart';
import 'package:dio/dio.dart';

abstract class InventoryRemoteDataSource {
  Future<List<InventoryItemModel>> getInventory(String businessId);
  Future<void> updateItemAvailability(String businessId, int itemId, bool isAvailable);
  Future<void> updateItemPrice(String businessId, int itemId, double price);
  Future<void> createItem(String businessId, Map<String, dynamic> data);
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final Dio dio;
  final String baseUrl;
  InventoryRemoteDataSourceImpl({required this.dio, this.baseUrl = 'http://10.0.2.2:3000/api'});

  @override
  Future<List<InventoryItemModel>> getInventory(String businessId) async {
    final response = await dio.get('$baseUrl/businesses/$businessId/menu');
    final List data = response.data;
    return data.map((json) => InventoryItemModel.fromJson(json)).toList();
  }

  @override
  Future<void> updateItemAvailability(String businessId, int itemId, bool isAvailable) async {
    await dio.patch('$baseUrl/businesses/$businessId/menu/$itemId', data: {'is_available': isAvailable});
  }

  @override
  Future<void> updateItemPrice(String businessId, int itemId, double price) async {
    await dio.patch('$baseUrl/businesses/$businessId/menu/$itemId', data: {'price': price});
  }

  @override
  Future<void> createItem(String businessId, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        '$baseUrl/businesses/$businessId/menu/items',
        data: {
          'item_name': data['item_name'],
          'price': data['price'],
          'item_category': data['item_category'],
        },
      );
      print('✅ Article créé, réponse: ${response.data}');
    } catch (e) {
      print('❌ Erreur createItem: $e');
      rethrow;
    }
  }
}