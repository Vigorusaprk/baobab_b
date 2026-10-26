import 'package:flutter/material.dart';
import '../../domain/entities/booking.dart';

/// Contenu de la commande (lignes d'articles) ou de la réservation
/// (offre + nombre de places), plus la note du client si elle existe.
class BookingLines extends StatelessWidget {
  final Booking booking;
  const BookingLines({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    if (booking.type == 'order') {
      final lines = (booking.details['lines'] as List?) ?? const [];
      for (final l in lines.whereType<Map>()) {
        final price = (l['price'] as num?)?.toDouble() ?? 0;
        final qty = (l['quantity'] as num?)?.toInt() ?? 1;
        rows.add(_row('$qty × ${l['item_name'] ?? 'Article'}', (price * qty).toStringAsFixed(2)));
      }
    } else {
      final qty = booking.details['quantity'] ?? 1;
      rows.add(_row('${booking.details['item_name'] ?? 'Réservation'}', '$qty place(s)'));
    }
    final notes = booking.details['notes']?.toString() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...rows,
        if (notes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Note du client : $notes', style: const TextStyle(fontStyle: FontStyle.italic)),
        ],
      ],
    );
  }

  Widget _row(String left, String right) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Flexible(child: Text(left)), Text(right)],
        ),
      );
}
