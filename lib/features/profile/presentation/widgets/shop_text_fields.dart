import 'package:flutter/material.dart';
import '../../data/shop_controllers.dart';

/// Titre de section du formulaire boutique.
class ShopSection extends StatelessWidget {
  final String title;
  const ShopSection(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 10),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w700)),
      );
}

/// Champs texte : identité, contact et adresse. [onEdit] signale une modification.
class ShopTextFields extends StatelessWidget {
  final ShopControllers c;
  final VoidCallback onEdit;
  const ShopTextFields({super.key, required this.c, required this.onEdit});

  Widget _f(String key, String label, {TextInputType? type, int lines = 1}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c[key], keyboardType: type, maxLines: lines,
          onChanged: (_) => onEdit(),
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(children: [
        const Align(alignment: Alignment.centerLeft, child: ShopSection('Identité')),
        _f('name', 'Nom du commerce *'),
        _f('description', 'Description', lines: 3),
        const Align(alignment: Alignment.centerLeft, child: ShopSection('Contact')),
        _f('phone', 'Téléphone', type: TextInputType.phone),
        _f('email', 'Courriel', type: TextInputType.emailAddress),
        _f('website', 'Site web', type: TextInputType.url),
        const Align(alignment: Alignment.centerLeft, child: ShopSection('Adresse')),
        _f('province', 'Province'),
        _f('ville', 'Ville'),
        _f('commune', 'Commune'),
        _f('quartier', 'Quartier'),
        _f('avenue', 'Avenue'),
        _f('numero', 'Numéro'),
      ]);
}
