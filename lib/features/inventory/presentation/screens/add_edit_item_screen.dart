import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inventory_item.dart';
import '../bloc/inventory_bloc.dart';
import '../widgets/fulfilment_picker.dart';
import '../widgets/item_form_fields.dart';
import '../widgets/item_save_button.dart';

/// Formulaire d'ajout (item == null) ou de modification d'une offre.
/// Doit être ouvert avec `BlocProvider.value` pour partager l'InventoryBloc.
class AddEditItemScreen extends StatefulWidget {
  final String businessId;
  final InventoryItem? item;
  const AddEditItemScreen({super.key, required this.businessId, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _category = TextEditingController();
  final _description = TextEditingController();
  final _imageUrl = TextEditingController();
  String _fulfilment = 'order';
  bool _saving = false;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    if (i == null) return;
    _name.text = i.name;
    _price.text = i.price.toString();
    _category.text = i.category ?? '';
    _description.text = i.description ?? '';
    _imageUrl.text = i.imageUrl ?? '';
  }

  @override
  void dispose() {
    for (final c in [_name, _price, _category, _description, _imageUrl]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Valide les champs puis envoie la création ou la modification.
  void _save() {
    final price = double.tryParse(_price.text.trim().replaceAll(',', '.'));
    if (_name.text.trim().isEmpty) return _toast('Veuillez entrer un nom');
    if (price == null || price < 0) return _toast('Prix invalide');

    final data = {
      'item_name': _name.text.trim(),
      'price': price,
      'item_category': _category.text,
      'description': _description.text,
      'image_url': _imageUrl.text,
      'fulfilment': _fulfilment,
    };
    setState(() => _saving = true);
    final bloc = context.read<InventoryBloc>();
    bloc.add(_isEdit
        ? UpdateInventoryItemEvent(widget.businessId, widget.item!.id, data)
        : CreateInventoryItemEvent(widget.businessId, data));
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryBloc, InventoryState>(
      listener: (context, state) {
        if (state is InventorySaved) Navigator.pop(context, true);
        if (state is InventorySaveFailed) {
          setState(() => _saving = false);
          _toast(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Modifier l\'offre' : 'Ajouter une offre'),
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(padding: const EdgeInsets.all(16), children: [
              if (!_isEdit)
                FulfilmentPicker(
                  value: _fulfilment,
                  onChanged: (v) => setState(() => _fulfilment = v),
                ),
              ItemFormFields(
                name: _name, price: _price, category: _category,
                description: _description, imageUrl: _imageUrl,
              ),
              const SizedBox(height: 12),
              ItemSaveButton(saving: _saving, onPressed: _save),
            ]),
          ),
        ),
      ),
    );
  }
}
