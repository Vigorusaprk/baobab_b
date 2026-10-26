import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Format « 09:00 » attendu par la fiche client.
String formatTime(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// « 09:00 - 18:00 » → deux heures. `null` si c'est du texte libre
/// (« sur rendez-vous ») : on ne le réécrit pas à la place du commerçant.
(TimeOfDay, TimeOfDay)? parseRange(String? raw) {
  final m = RegExp(r'(\d{1,2})\s*[:hH]\s*(\d{2})?').allMatches(raw ?? '').toList();
  if (m.length < 2) return null;
  TimeOfDay at(RegExpMatch x) => TimeOfDay(
      hour: int.parse(x.group(1)!) % 24, minute: int.parse(x.group(2) ?? '0') % 60);
  return (at(m[0]), at(m[1]));
}

/// Une ligne de l'éditeur d'horaires : jour, interrupteur ouvert/fermé, heures.
class HoursDayRow extends StatelessWidget {
  final String day;
  final String? raw; // null = fermé
  final ValueChanged<String?> onChanged;
  const HoursDayRow({super.key, required this.day, required this.raw, required this.onChanged});

  static const _open = TimeOfDay(hour: 9, minute: 0);
  static const _close = TimeOfDay(hour: 18, minute: 0);

  Future<void> _pick(BuildContext ctx, TimeOfDay s, TimeOfDay e, bool start) async {
    final t = await showTimePicker(context: ctx, initialTime: start ? s : e);
    if (t != null) onChanged('${formatTime(start ? t : s)} - ${formatTime(start ? e : t)}');
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = raw != null && raw!.trim().isNotEmpty;
    final range = parseRange(raw);
    final s = range?.$1 ?? _open, e = range?.$2 ?? _close;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        SizedBox(width: 90, child: Text(day, style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isOpen ? AppColors.textPrimary : AppColors.textMuted))),
        Switch(
          value: isOpen,
          activeColor: AppColors.secondary,
          onChanged: (on) => onChanged(on ? '${formatTime(_open)} - ${formatTime(_close)}' : null),
        ),
        const SizedBox(width: 8),
        if (!isOpen)
          const Text('Fermé', style: TextStyle(color: AppColors.textMuted))
        else if (range == null)
          Expanded(child: Text(raw!, maxLines: 1, overflow: TextOverflow.ellipsis))
        else ...[
          TextButton(onPressed: () => _pick(context, s, e, true), child: Text(formatTime(s))),
          const Text('–'),
          TextButton(onPressed: () => _pick(context, s, e, false), child: Text(formatTime(e))),
        ],
      ]),
    );
  }
}
