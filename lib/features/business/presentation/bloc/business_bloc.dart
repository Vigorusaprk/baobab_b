import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/business_entity.dart';
import '../../domain/repositories/business_repository.dart';

part 'business_state.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final BusinessRepository repository;
  BusinessCubit({required this.repository}) : super(BusinessInitial());

  Future<void> loadBusiness(String businessId) async {
    emit(BusinessLoading());
    final result = await repository.getBusiness(businessId);
    result.fold(
          (failure) => emit(BusinessError(failure.message)),
          (business) => emit(BusinessLoaded(business)),
    );
  }
}