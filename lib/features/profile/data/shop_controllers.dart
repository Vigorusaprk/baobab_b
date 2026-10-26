import 'package:flutter/widgets.dart';
import 'shop_info.dart';

/// Les champs texte du formulaire boutique, regroupés pour les créer,
/// les libérer et les convertir en une seule fois.
class ShopControllers {
  late final Map<String, TextEditingController> _c;

  ShopControllers(ShopInfo s) {
    final init = {
      'name': s.name, 'description': s.description, 'phone': s.phone,
      'email': s.email, 'website': s.website, 'pauseNote': s.pauseNote,
      'province': s.province, 'ville': s.ville, 'commune': s.commune,
      'quartier': s.quartier, 'avenue': s.avenue, 'numero': s.numero,
    };
    _c = init.map((k, v) => MapEntry(k, TextEditingController(text: v ?? '')));
  }

  TextEditingController operator [](String key) => _c[key]!;

  /// Champs attendus par `update-business` (les vides sont effacés côté serveur).
  Map<String, dynamic> toFields() =>
      _c.map((k, v) => MapEntry(k, v.text.trim()));

  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
  }
}
