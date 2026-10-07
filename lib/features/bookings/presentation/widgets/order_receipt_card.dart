import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/bookings/domain/entities/booking.dart';
import 'package:flutter/material.dart';


class BookingReceiptCard extends StatelessWidget {
  final Booking booking; // Utilisation directe et typée de ton entité !

  const BookingReceiptCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOrder = booking.type == 'order';
    final String title = isOrder ? 'Commande' : 'Réservation';

    // Formatage de la date (AAA-MM-JJ HH:MM)
    final String formattedDate = booking.date.toString().length >= 16
        ? booking.date.toString().substring(0, 16)
        : booking.date.toString();

    // Récupération ultra-sécurisée du nom du statut en String pour éviter le crash
    final String statusString = booking.status.toString().split('.').last;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- EN-TÊTE PRINCIPAL ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge de l'icône principale
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isOrder ? Icons.shopping_bag_rounded : Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Infos de la Commande / Réservation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title #${booking.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1A1D20),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.customerName.isNotEmpty
                          ? booking.customerName
                          : 'Client anonyme',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge de Statut Dynamique et Sécurisé
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      color: _getStatusColor(booking.status),
                      size: 8,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusLabel(statusString),
                      style: TextStyle(
                        color: _getStatusColor(booking.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),

          // --- DATE & HEURE ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (booking.customerPhone.isNotEmpty)
                Text(
                  booking.customerPhone,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.grey[200], height: 1),
          const SizedBox(height: 16),

          // --- SECTION CONTENU / ARTICLES ---
          _buildItemRow(
              isOrder ? 'Montant de la commande' : 'Frais de réservation',
              '1',
              '${booking.totalAmount.toStringAsFixed(2)}€'
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey[200], height: 1),
          const SizedBox(height: 16),

          // --- TOTAL ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A1D20),
                ),
              ),
              Text(
                '${booking.totalAmount.toStringAsFixed(2)}€',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF1A1D20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Rendu des lignes internes alignées
  Widget _buildItemRow(String name, String qty, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              qty,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              price,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Gestion des couleurs par rapport à l'Enum original BookingStatus
  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
      case BookingStatus.ready:
      case BookingStatus.delivered:
        return const Color(0xFF1ABC9C); // Vert
      case BookingStatus.pending:
      case BookingStatus.preparing:
        return Colors.orange; // Orange
      case BookingStatus.cancelled:
        return Colors.red; // Rouge
    }
  }

  // Traduction propre des statuts pour l'affichage utilisateur
  String _getStatusLabel(String statusName) {
    switch (statusName.toLowerCase()) {
      case 'pending': return 'EN ATTENTE';
      case 'confirmed': return 'CONFIRMÉ';
      case 'preparing': return 'EN PRÉPARATION';
      case 'ready': return 'PRÊT';
      case 'delivered': return 'LIVRÉ';
      case 'cancelled': return 'ANNULÉ';
      default: return statusName.toUpperCase();
    }
  }
}