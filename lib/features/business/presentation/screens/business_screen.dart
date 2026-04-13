import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/business_bloc.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BusinessCubit, BusinessState>(
        builder: (context, state) {
          return const Center(
            child: Text('Business Screen'),
          );
        },
      ),
    );
  }
}
