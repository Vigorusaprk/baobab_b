import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bookings_bloc.dart';
import '../../domain/entities/booking.dart';

class BookingDetailScreen extends StatelessWidget {
  final Booking booking;
  final String businessId;
  const BookingDetailScreen({super.key, required this.booking, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${booking.type == 'order' ? 'Commande' : 'Réservation'} #${booking.id}'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client : ${booking.customerName}', style: const TextStyle(fontSize: 18)),
            Text('Téléphone : ${booking.customerPhone}'),
            Text('Date : ${booking.date.toString().substring(0,16)}'),
            Text('Total : ${booking.totalAmount.toStringAsFixed(2)} €'),
            const SizedBox(height: 16),
            Text('Statut actuel : ${booking.status.name}'),
            const SizedBox(height: 24),
            Row(
              children: [
                if (booking.status == BookingStatus.pending)
                  ElevatedButton(
                    onPressed: () => context.read<BookingsBloc>().add(UpdateBookingStatusEvent(booking.id, booking.type, 'confirmed')),
                    child: const Text('Accepter'),
                  ),
                const SizedBox(width: 12),
                if (booking.status == BookingStatus.confirmed && booking.type == 'order')
                  ElevatedButton(
                    onPressed: () => context.read<BookingsBloc>().add(UpdateBookingStatusEvent(booking.id, booking.type, 'preparing')),
                    child: const Text('Préparer'),
                  ),
                if (booking.status == BookingStatus.preparing)
                  ElevatedButton(
                    onPressed: () => context.read<BookingsBloc>().add(UpdateBookingStatusEvent(booking.id, booking.type, 'delivered')),
                    child: const Text('Livrer'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}