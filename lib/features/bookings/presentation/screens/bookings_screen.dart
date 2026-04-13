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
      create: (context) => GetIt.I<BookingsBloc>()..add(LoadBookings(businessId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Commandes & Réservations'), backgroundColor: Colors.green, foregroundColor: Colors.white),
        body: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            if (state is BookingsLoading) return const Center(child: CircularProgressIndicator());
            if (state is BookingsLoaded) {
              return ListView.builder(
                itemCount: state.bookings.length,
                itemBuilder: (_, i) {
                  final b = state.bookings[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      title: Text('${b.type == 'order' ? 'Commande' : 'Réservation'} #${b.id}'),
                      subtitle: Text('${b.customerName} - ${b.date.toString().substring(0,16)} - ${b.totalAmount}€'),
                      trailing: Chip(label: Text(b.status.name)),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: b, businessId: businessId)),
                      ),
                    ),
                  );
                },
              );
            }
            if (state is BookingsError) return Center(child: Text(state.message));
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}