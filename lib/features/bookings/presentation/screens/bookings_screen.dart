import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/bookings_bloc.dart';
import 'booking_detail_page.dart';

class BookingsScreen extends StatelessWidget {
  final String businessId;
  const BookingsScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<BookingsBloc>()..add(LoadBookings(businessId)),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              color: AppColors.primaryLight,
              child: const Text(
                'Commandes & Réservations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: BlocBuilder<BookingsBloc, BookingsState>(
                builder: (context, state) {
                  if (state is BookingsLoading)
                    return const Center(child: CircularProgressIndicator());
                  if (state is BookingsLoaded) {
                    return ListView.builder(
                      itemCount: state.bookings.length,
                      itemBuilder: (_, i) {
                        final b = state.bookings[i];
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingDetailScreen(
                                booking: b,
                                businessId: businessId,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                            color: AppColors.primaryLight,
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 25),
                                          height:95,
                                          child: Icon(Icons.receipt, size: 40, color: AppColors.scaffoldBackground,),
                                        ),
                                        SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 25),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${b.type == 'order' ? 'Commande' : 'Réservation'} #${b.id}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                '${b.date.toString().substring(0, 16)} - ${b.totalAmount}€',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2.5,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(b.status.name),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is BookingsError)
                    return Center(child: Text(state.message));
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
