// lib/features/dashboard/presentation/widgets/client_liste.dart
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/dashboard/presentation/bloc/customer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CustomerListWidget extends StatelessWidget {
  final String businessId;
  const CustomerListWidget({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<CustomerBloc>()..add(LoadCustomers(businessId)),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12),),
                 color: AppColors.primaryLight,
               ),
               child: Row(
                 children: [
                   Container(
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                         color: AppColors.scaffoldBackground.withOpacity(0.5),
                         borderRadius: BorderRadius.all(Radius.circular(10))
                     ),
                     child: Icon(
                         Icons.group,
                         color: AppColors.scaffoldBackground, size: 20
                     ),
                   ),

                   SizedBox(width: 8),
                   Text(
                    'Liste des clients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.scaffoldBackground),
                   ),
                 ],
               ),
             ),
            BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is CustomerLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CustomerLoaded) {
                  if (state.customers.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('Aucun client')),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.customers.length,
                    itemBuilder: (context, index) {
                      final customer = state.customers[index];
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: customer.imgUrl != null && customer.imgUrl!.isNotEmpty
                                      ? NetworkImage(customer.imgUrl!)
                                      : null,
                                  child: const Icon(Icons.person),
                                ),

                                SizedBox(width: 10,),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(customer.email),
                                  ],
                                ),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is CustomerError) {
                  return Center(child: Text('Erreur : ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}