import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/shop_info.dart';
import 'opening_hours_editor.dart';

/// Carte blanche cassée avec un titre : conteneur commun des blocs de la page.
class InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  const InfoCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          child,
        ]),
      );
}

/// Une ligne « icône + texte » ; masquée si le texte est vide.
class InfoLine extends StatelessWidget {
  final IconData icon;
  final String? text;
  const InfoLine(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Expanded(child: Text(text!, style: const TextStyle(color: AppColors.textPrimary))),
      ]),
    );
  }
}

/// Contact et adresse du commerce.
class ContactCard extends StatelessWidget {
  final ShopInfo shop;
  const ContactCard(this.shop, {super.key});

  @override
  Widget build(BuildContext context) {
    // Adresse lisible : seuls les morceaux renseignés, du plus précis au plus large.
    final address = [
      if (shop.numero.isNotEmpty) 'N° ${shop.numero}',
      if (shop.avenue.isNotEmpty) 'Av. ${shop.avenue}',
      shop.quartier, shop.commune, shop.ville, shop.province,
    ].where((p) => p.isNotEmpty).join(', ');
    final empty = [shop.phone, shop.email, shop.website, address].every((v) => v == null || v.isEmpty);
    return InfoCard(
      title: 'Contact et adresse',
      child: empty
          ? const Text('Rien de renseigné.', style: TextStyle(color: AppColors.textMuted))
          : Column(children: [
              InfoLine(Icons.phone_outlined, shop.phone),
              InfoLine(Icons.mail_outline, shop.email),
              InfoLine(Icons.language, shop.website),
              InfoLine(Icons.place_outlined, address),
            ]),
    );
  }
}

/// Horaires de la semaine ; le jour courant est en gras.
class HoursCard extends StatelessWidget {
  final Map<String, String> hours;
  const HoursCard(this.hours, {super.key});

  @override
  Widget build(BuildContext context) {
    final today = OpeningHoursEditor.days[DateTime.now().weekday - 1];
    return InfoCard(
      title: 'Horaires',
      child: Column(children: [
        for (final d in OpeningHoursEditor.days)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(children: [
              SizedBox(width: 100, child: Text(d, style: TextStyle(
                  fontWeight: d == today ? FontWeight.w700 : FontWeight.w400))),
              Text(hours[d] ?? 'Fermé', style: TextStyle(
                  fontWeight: d == today ? FontWeight.w700 : FontWeight.w400,
                  color: hours[d] == null ? AppColors.textMuted : AppColors.textPrimary)),
            ]),
          ),
      ]),
    );
  }
}
