import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/booking.dart';

/// L'agenda marchand : les rendez-vous d'une journée, dans l'ordre chronologique des heures.
///
/// Porté directement depuis l'architecture de -baobab_app_2.
class MerchantAgenda extends StatefulWidget {
  const MerchantAgenda({super.key, required this.reservations});

  final List<Booking> reservations;

  @override
  State<MerchantAgenda> createState() => _MerchantAgendaState();
}

class _MerchantAgendaState extends State<MerchantAgenda> {
  late DateTime _day;

  /// Combien de jours la barre du haut propose (deux semaines).
  static const int _span = 14;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _day = DateTime(now.year, now.month, now.day);
  }

  List<Booking> _of(DateTime day) {
    final list = widget.reservations
        .where(
          (r) =>
              r.date.year == day.year &&
              r.date.month == day.month &&
              r.date.day == day.day &&
              r.status != BookingStatus.cancelled,
        )
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _day = DateTime(picked.year, picked.month, picked.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayReservations = _of(_day);
    final theme = Theme.of(context);

    return Column(
      children: [
        // Bande horizontale des 14 jours
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _span,
            itemBuilder: (context, index) {
              final d = DateTime.now().add(Duration(days: index));
              final isSelected =
                  d.year == _day.year &&
                  d.month == _day.month &&
                  d.day == _day.day;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => setState(() => _day = DateTime(d.year, d.month, d.day)),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.primaryColor
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? theme.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E', 'fr_FR').format(d).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('d').format(d),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Sélecteur complet de calendrier
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_day),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: _pickDay,
                tooltip: 'Choisir une date',
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Liste des rendez-vous de la journée sélectionnée
        Expanded(
          child: dayReservations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_available, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'Aucun rendez-vous pour ce jour',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: dayReservations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = dayReservations[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Heure du rendez-vous
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                DateFormat('HH:mm').format(item.date),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Informations client
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.customerName.isNotEmpty
                                        ? item.customerName
                                        : 'Client sans nom',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (item.customerPhone.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      item.customerPhone,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Montant
                            Text(
                              '${item.totalAmount.toStringAsFixed(0)} \$',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
