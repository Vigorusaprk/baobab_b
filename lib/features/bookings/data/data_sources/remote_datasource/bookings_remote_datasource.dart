import 'package:baobab_business/features/bookings/data/models/order_model.dart';
import 'package:baobab_business/features/bookings/data/models/reservation_model.dart';
import 'package:dio/dio.dart';

abstract class BookingsRemoteDataSource {
  Future<List<OrderModel>> getOrders(String businessId, {String? status, int page = 1});
  Future<List<ReservationModel>> getReservations(String businessId, {String? type, int page = 1});
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> updateReservationStatus(String reservationId, String status);
}

class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  final Dio dio; final String baseUrl;
  BookingsRemoteDataSourceImpl({required this.dio, this.baseUrl = 'http://10.0.2.2:3000/api'});

  @override
  Future<List<OrderModel>> getOrders(String businessId, {String? status, int page = 1}) async {
    final response = await dio.get('$baseUrl/businesses/$businessId/orders', queryParameters: {'page': page, 'status': status});
    final List data = response.data['orders'];
    return data.map((j) => OrderModel.fromJson(j)).toList();
  }

  @override
  Future<List<ReservationModel>> getReservations(String businessId, {String? type, int page = 1}) async {
    final response = await dio.get('$baseUrl/businesses/$businessId/reservations', queryParameters: {'page': page, 'type': type});
    final List data = response.data['reservations'];
    return data.map((j) => ReservationModel.fromJson(j)).toList();
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await dio.patch('$baseUrl/orders/$orderId/status', data: {'status': status});
  }

  @override
  Future<void> updateReservationStatus(String reservationId, String status) async {
    await dio.patch('$baseUrl/reservations/$reservationId/status', data: {'status': status});
  }
}