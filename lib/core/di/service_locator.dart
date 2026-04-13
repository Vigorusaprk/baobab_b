import 'package:baobab_business/features/auth/data/data_sources/remote_datasource/auth_remote_datasource.dart';
import 'package:baobab_business/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:baobab_business/features/auth/domain/repositories/auth_repository.dart';
import 'package:baobab_business/features/auth/domain/usecases/check_auth_status.dart';
import 'package:baobab_business/features/auth/domain/usecases/login.dart';
import 'package:baobab_business/features/auth/domain/usecases/logout.dart';
import 'package:baobab_business/features/auth/domain/usecases/register.dart';
import 'package:baobab_business/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:baobab_business/features/bookings/data/data_sources/remote_datasource/bookings_remote_datasource.dart';
import 'package:baobab_business/features/bookings/domain/usecases/get_bookings.dart';
import 'package:baobab_business/features/bookings/domain/usecases/update_booking_status.dart';
import 'package:baobab_business/features/business/data/data_sources/remote_datasource/business_remote_datasource.dart';
import 'package:baobab_business/features/business/data/repositories/business_repository_impl.dart';
import 'package:baobab_business/features/business/domain/repositories/business_repository.dart';
import 'package:baobab_business/features/business/presentation/bloc/business_bloc.dart';
import 'package:baobab_business/features/dashboard/data/data_sources/remote_datasource/customer_remote_datasource.dart';
import 'package:baobab_business/features/dashboard/data/data_sources/remote_datasource/dashboard_remote_datasource.dart';
import 'package:baobab_business/features/dashboard/data/repositories/customer_repository_impl.dart';
import 'package:baobab_business/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:baobab_business/features/dashboard/domain/repositories/customer_repository.dart';
import 'package:baobab_business/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:baobab_business/features/dashboard/domain/usecases/get_dashboard_stats.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/customer_bloc.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:baobab_business/features/inventory/data/data_sources/remote_datasource/inventory_remote_datasource.dart';
import 'package:baobab_business/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:baobab_business/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:baobab_business/features/inventory/domain/usecases/create_inventory_item.dart';
import 'package:baobab_business/features/inventory/domain/usecases/get_inventory.dart';
import 'package:baobab_business/features/inventory/domain/usecases/update_item_availability.dart';
import 'package:baobab_business/features/inventory/domain/usecases/update_item_price.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/inventory/presentation/bloc/inventory_bloc.dart';
import '../../features/bookings/data/repositories/bookings_repository_impl.dart';
import '../../features/bookings/domain/repositories/bookings_repository.dart';
import '../../features/bookings/presentation/bloc/bookings_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton<Dio>(() => DioClient.getDio());
  //Business
  sl.registerLazySingleton<BusinessRemoteDataSource>(
        () => BusinessRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<BusinessRepository>(
        () => BusinessRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<BusinessCubit>(
        () => BusinessCubit(repository: sl()),
  );

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), prefs: sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerFactory(() => AuthBloc(login: sl(), checkAuthStatus: sl(), logout: sl(), register: sl()));
  sl.registerLazySingleton(() => Register(sl<AuthRepository>()));

  // Customers
  sl.registerLazySingleton<CustomerRemoteDataSource>(() => CustomerRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(remoteDataSource: sl()));
  sl.registerFactory<CustomerBloc>(() => CustomerBloc(repository: sl()));

  // Dashboard
  sl.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetDashboardStats(sl()));
  sl.registerFactory(() => DashboardBloc(getDashboardStats: sl()));

  // Inventory
  sl.registerLazySingleton<InventoryRemoteDataSource>(() => InventoryRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetInventory(sl()));
  sl.registerLazySingleton(() => UpdateItemAvailability(sl()));
  sl.registerLazySingleton(() => UpdateItemPrice(sl()));
  sl.registerLazySingleton(() => CreateInventoryItem(sl()));
  sl.registerFactory(() => InventoryBloc(
    getInventory: sl(),
    updateItemAvailability: sl(),
    updateItemPrice: sl(),
    createInventoryItem: sl(),
  ));

  // Bookings
  sl.registerLazySingleton<BookingsRemoteDataSource>(() => BookingsRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<BookingsRepository>(() => BookingsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetBookings(sl()));
  sl.registerLazySingleton(() => UpdateBookingStatus(sl()));
  sl.registerFactory(() => BookingsBloc(
    getBookings: sl(),
    updateBookingStatus: sl(),
  ));
}