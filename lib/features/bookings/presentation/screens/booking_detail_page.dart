import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/booking.dart';
import '../bloc/bookings_bloc.dart';
import '../widgets/booking_actions.dart';
import '../widgets/booking_lines.dart';

/// Libellé français d'un statut (jamais le mot brut de la base).
String bookingStatusLabel(BookingStatus s) {
  const labels = {
    BookingStatus.pending: 'En attente',
    BookingStatus.confirmed: 'Confirmé',
    BookingStatus.preparing: 'En préparation',
    BookingStatus.ready: 'Prêt',
    BookingStatus.delivered: 'Livré',
    BookingStatus.completed: 'Honoré',
    BookingStatus.cancelled: 'Annulé',
  };
  return labels[s] ?? s.name;
}

/// Détail d'une commande ou réservation : client, contenu, actions.
/// Reçoit le BookingsBloc de l'écran liste (BlocProvider.value).
class BookingDetailScreen extends StatelessWidget {
  final Booking booking;
  final String businessId;
  const BookingDetailScreen({super.key, required this.booking, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final isOrder = booking.type == 'order';
    final date = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(booking.date);
    return BlocListener<BookingsBloc, BookingsState>(
      // Statut changé : on revient à la liste, qui se recharge d'elle-même.
      listener: (context, state) {
        if (state is BookingStatusUpdated) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${isOrder ? 'Commande' : 'Réservation'} #${booking.id}'),
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(booking.customerName.isEmpty ? 'Client' : booking.customerName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            if (booking.customerPhone.isNotEmpty) Text(booking.customerPhone),
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(color: AppColors.textSecondary)),
            const Divider(height: 32),
            BookingLines(booking: booking),
            const Divider(height: 32),
            Text('Total : ${booking.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Statut : ${bookingStatusLabel(booking.status)}'),
            const SizedBox(height: 24),
            BookingActions(booking: booking),
          ],
        ),
      ),
    );
  }
}
