import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking.dart';
import '../bloc/bookings_bloc.dart';

/// Une action possible : libellé, statut visé, et si elle est « négative ».
class _Action {
  final String label;
  final String status;
  final bool destructive;
  const _Action(this.label, this.status, {this.destructive = false});
}

/// Actions proposées selon le type et le statut courant.
/// Les statuts viennent des Edge Functions `update-order-status` et
/// `update-reservation-status`.
List<_Action> _actionsFor(Booking b) {
  if (b.type == 'order') {
    switch (b.status) {
      case BookingStatus.pending:
        return const [_Action('Accepter', 'confirmed'), _Action('Refuser', 'cancelled', destructive: true)];
      case BookingStatus.confirmed:
        return const [_Action('Lancer la préparation', 'preparing'), _Action('Annuler', 'cancelled', destructive: true)];
      case BookingStatus.preparing:
        return const [_Action('Marquer prête', 'ready')];
      case BookingStatus.ready:
        return const [_Action('Marquer livrée', 'delivered')];
      default:
        return const [];
    }
  }
  switch (b.status) {
    case BookingStatus.pending:
      return const [_Action('Confirmer', 'confirmed'), _Action('Refuser', 'cancelled', destructive: true)];
    case BookingStatus.confirmed:
      return const [_Action('Marquer honorée', 'completed'), _Action('Annuler', 'cancelled', destructive: true)];
    default:
      return const [];
  }
}

/// Barre d'actions du détail : un bouton par transition de statut permise.
class BookingActions extends StatelessWidget {
  final Booking booking;
  const BookingActions({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final actions = _actionsFor(booking);
    if (actions.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.map((a) {
        void send() => context
            .read<BookingsBloc>()
            .add(UpdateBookingStatusEvent(booking.id, booking.type, a.status));
        return a.destructive
            ? OutlinedButton(
                onPressed: send,
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                child: Text(a.label),
              )
            : ElevatedButton(
                onPressed: send,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                ),
                child: Text(a.label),
              );
      }).toList(),
    );
  }
}
