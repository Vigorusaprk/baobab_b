import 'package:flutter/material.dart';

/// Champs du formulaire d'offre (nom, prix, catégorie, description, image).
/// Les contrôleurs appartiennent à l'écran parent.
class ItemFormFields extends StatelessWidget {
  final TextEditingController name, price, category, description, imageUrl;
  const ItemFormFields({
    super.key,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.imageUrl,
  });

  Widget _field(TextEditingController c, String label,
      {TextInputType? type, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: type,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _field(name, 'Nom *'),
      _field(price, 'Prix (USD) *',
          type: const TextInputType.numberWithOptions(decimal: true)),
      _field(category, 'Catégorie (ex. Plats, Boissons)'),
      _field(description, 'Description', lines: 3),
      _field(imageUrl, 'URL de l\'image', type: TextInputType.url),
    ]);
  }
}
