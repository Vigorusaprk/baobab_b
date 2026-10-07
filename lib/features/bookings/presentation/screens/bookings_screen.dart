import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/bookings/presentation/widgets/order_receipt_card.dart';
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
      create: (context) =>
          GetIt.I<BookingsBloc>()..add(LoadBookings(businessId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              _buildTabletHeader(context),
              const SizedBox(height: 30),

              Expanded(
                child: BlocBuilder<BookingsBloc, BookingsState>(
                  builder: (context, state) {
                    if (state is BookingsLoading)
                      return const Center(child: CircularProgressIndicator());
                    if (state is BookingsLoaded) {
                      return GridView.builder(
                        itemCount: state.bookings.length,
                        shrinkWrap: true, // Permet de l'intégrer facilement dans un scroll global si besoin
                        physics: const BouncingScrollPhysics(), // Effet de défilement fluide
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,          // Nombre de colonnes (côte à côte)
                          crossAxisSpacing: 14.0,     // Espace horizontal entre les cartes
                          mainAxisSpacing: 14.0,      // Espace vertical entre les lignes
                          childAspectRatio: 0.82,     // Rapport Largeur/Hauteur de la carte (ajuste si le texte est coupé)
                        ),
                        itemBuilder: (context, i) {
                          final b = state.bookings[i];

                          return InkWell(
                            borderRadius: BorderRadius.circular(24), // S'aligne parfaitement sur l'arrondi du widget
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetailScreen(
                                  booking: b,
                                  businessId: businessId,
                                ),
                              ),
                            ),
                            child: BookingReceiptCard(booking: b),
                          );
                        },
                      );
                    }
                    if (state is BookingsError)
                      return Center(child: Text(state.message));
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTabletHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: AppColors.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commandes & Réservations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  Text(
                    'Gestion complète de vos commandes & réservations',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Barre de recherche tablette
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                hintStyle: TextStyle(color: AppColors.secondaryLight),
                prefixIcon: Icon(Icons.search, color:AppColors.secondaryLight),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
