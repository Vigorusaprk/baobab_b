import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inventory_bloc.dart';
import '../../domain/entities/inventory_item.dart';

class AddEditItemScreen extends StatefulWidget {
  final String businessId;
  final InventoryItem? item;
  const AddEditItemScreen({super.key, required this.businessId, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  final _ingredientsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameCtrl.text = widget.item!.name;
      _priceCtrl.text = widget.item!.price.toString();
      _categoryCtrl.text = widget.item!.category ?? '';
      _descriptionCtrl.text = widget.item!.description ?? '';
      _imageUrlCtrl.text = widget.item!.imageUrl ?? '';
      _ingredientsCtrl.text = widget.item!.ingredients ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Ajouter un article' : 'Modifier'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: isTablet ? 500 : double.infinity,
          margin: isTablet ? const EdgeInsets.all(32) : EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          decoration: isTablet
              ? BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
          )
              : null,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nom *')),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(labelText: 'Prix *'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(controller: _categoryCtrl, decoration: const InputDecoration(labelText: 'Catégorie')),
                const SizedBox(height: 12),
                TextField(controller: _descriptionCtrl, decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 12),
                TextField(controller: _imageUrlCtrl, decoration: const InputDecoration(labelText: 'URL image')),
                const SizedBox(height: 12),
                TextField(controller: _ingredientsCtrl, decoration: const InputDecoration(labelText: 'Ingrédients')),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    final priceText = _priceCtrl.text.trim();
    if (name.isEmpty) {
      _showSnackBar('Veuillez entrer un nom');
      return;
    }
    if (priceText.isEmpty) {
      _showSnackBar('Veuillez entrer un prix');
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null) {
      _showSnackBar('Prix invalide');
      return;
    }

    final data = {
      'item_name': name,
      'price': price,
      'item_category': _categoryCtrl.text.trim(),
      'description': _descriptionCtrl.text.trim(),
      'image_url': _imageUrlCtrl.text.trim(),
      'ingredients': _ingredientsCtrl.text.trim(),
    };
    context.read<InventoryBloc>().add(CreateInventoryItemEvent(widget.businessId, data));
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}