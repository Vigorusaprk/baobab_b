import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Interrupteur « fermeture temporaire » (congés, travaux…), avec un mot pour les clients.
class PauseTile extends StatelessWidget {
  final bool paused;
  final TextEditingController note;
  final ValueChanged<bool> onChanged;
  final VoidCallback onEdit;
  const PauseTile({super.key, required this.paused, required this.note,
      required this.onChanged, required this.onEdit});

  @override
  Widget build(BuildContext context) => Column(children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.secondary,
          title: const Text('Fermeture temporaire'),
          subtitle: const Text('Vos clients voient que vous ne prenez rien pour le moment.'),
          value: paused,
          onChanged: onChanged,
        ),
        if (paused)
          TextField(
            controller: note, onChanged: (_) => onEdit(),
            decoration: const InputDecoration(
                labelText: 'Message pour les clients', border: OutlineInputBorder()),
          ),
      ]);
}
