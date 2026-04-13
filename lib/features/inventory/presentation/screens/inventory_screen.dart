import 'package:baobab_business/features/inventory/presentation/widgets/inventory_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/inventory_bloc.dart';
import 'add_edit_item_screen.dart';


class InventoryScreen extends StatelessWidget {
  final String businessId;
  const InventoryScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<InventoryBloc>()..add(LoadInventory(businessId)),
      child: Builder(
        builder: (context) {
          // Ce Builder permet d'avoir un contexte qui inclut le BlocProvider
          return Scaffold(
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  color: Colors.green,
                  child: const Text(
                    'Gestion du stock',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<InventoryBloc, InventoryState>(
                    builder: (context, state) {
                      if (state is InventoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is InventoryLoaded) {
                        if (state.items.isEmpty) {
                          return const Center(child: Text('Aucun article dans le stock'));
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return InventoryItemCard(
                              item: item,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<InventoryBloc>(),
                                      child: AddEditItemScreen(businessId: businessId,),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                      if (state is InventoryError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: Builder(
              builder: (context) {
                // Ici le contexte a accès au BlocProvider
                return FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<InventoryBloc>(),
                          child: AddEditItemScreen(businessId: businessId),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                );
              },
            ),
          );
        },
      ),
    );
  }
}