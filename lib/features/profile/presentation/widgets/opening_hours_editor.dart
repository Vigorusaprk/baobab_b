import 'package:flutter/material.dart';
import 'hours_day_row.dart';

/// Horaires d'ouverture, jour par jour. Un jour absent de la table est fermé.
class OpeningHoursEditor extends StatelessWidget {
  final Map<String, String> value;
  final ValueChanged<Map<String, String>> onChanged;
  const OpeningHoursEditor({super.key, required this.value, required this.onChanged});

  /// Orthographe attendue par la fiche client.
  static const days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (final d in days)
        HoursDayRow(
          day: d,
          raw: value[d],
          onChanged: (line) {
            final next = Map<String, String>.from(value);
            line == null ? next.remove(d) : next[d] = line;
            onChanged(next);
          },
        ),
    ]);
  }
}
