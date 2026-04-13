import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inventory_bloc.dart';

class AddEditItemScreen extends StatefulWidget {
  final String businessId;
  const AddEditItemScreen({super.key, required this.businessId});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un article'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: _priceCtrl, decoration: const InputDecoration(labelText: 'Prix'), keyboardType: TextInputType.number),
            TextField(controller: _categoryCtrl, decoration: const InputDecoration(labelText: 'Catégorie')),
            ElevatedButton(
              onPressed: () async {
                final name = _nameCtrl.text.trim();
                final priceText = _priceCtrl.text.trim();
                if (name.isEmpty || priceText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nom et prix requis')));
                  return;
                }
                final price = double.tryParse(priceText);
                if (price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prix invalide')));
                  return;
                }
                final data = {
                  'item_name': name,
                  'price': price,
                  'item_category': _categoryCtrl.text.trim(),
                };
                context.read<InventoryBloc>().add(CreateInventoryItemEvent(widget.businessId, data));
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}