import 'package:baobab_business/core/merchant/media_upload_service.dart';
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/inventory/presentation/widgets/image_upload_field.dart';
import 'package:flutter/material.dart';
import '../../data/shop_api.dart';
import '../../data/shop_controllers.dart';
import '../../data/shop_info.dart';
import 'opening_hours_editor.dart';
import 'pause_tile.dart';
import 'shop_text_fields.dart';

/// Formulaire d'édition de la fiche. Le bouton « Enregistrer » n'apparaît
/// que lorsque quelque chose a changé.
class ShopForm extends StatefulWidget {
  final ShopInfo shop;
  const ShopForm({super.key, required this.shop});

  @override
  State<ShopForm> createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  late final ShopControllers _c = ShopControllers(widget.shop);
  late String? _cover = widget.shop.cover;
  late Map<String, String> _hours = Map.of(widget.shop.hours);
  late bool _paused = widget.shop.isPaused;
  bool _dirty = false, _saving = false;

  void _touch() { if (!_dirty) setState(() => _dirty = true); }

  void _toast(String m, {bool error = false}) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: error ? AppColors.error : null));

  Future<void> _save() async {
    if (_c['name'].text.trim().length < 2) return _toast('Le nom est obligatoire.', error: true);
    setState(() => _saving = true);
    try {
      await ShopApi().save(widget.shop.id, {
        ..._c.toFields(),
        'coverImage': _cover,
        'openingHours': _hours,
        'isPaused': _paused,
      });
      if (!mounted) return;
      setState(() { _saving = false; _dirty = false; });
      _toast('Votre fiche est à jour.');
    } catch (e) { // MerchantException (message serveur) ou erreur réseau
      if (!mounted) return;
      setState(() => _saving = false);
      _toast(e.toString(), error: true);
    }
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView(padding: const EdgeInsets.all(16), children: [
          ImageUploadField(
            businessId: widget.shop.id, kind: MediaKind.cover, value: _cover,
            onChanged: (u) { setState(() => _cover = u); _touch(); },
          ),
          ShopTextFields(c: _c, onEdit: _touch),
          const ShopSection('Horaires'),
          OpeningHoursEditor(value: _hours, onChanged: (h) { setState(() => _hours = h); _touch(); }),
          const ShopSection('Disponibilité'),
          PauseTile(paused: _paused, note: _c['pauseNote'], onEdit: _touch,
              onChanged: (v) { setState(() => _paused = v); _touch(); }),
        ]),
      ),
      if (_dirty)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary, minimumSize: const Size.fromHeight(48)),
              child: Text(_saving ? 'Enregistrement…' : 'Enregistrer les modifications'),
            ),
          ),
        ),
    ]);
  }
}
