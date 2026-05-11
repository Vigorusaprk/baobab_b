import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(child: CircleAvatar()),

            Container(
              child: Row(
                children: [
                  Icon(Icons.search_rounded),
                  SizedBox(width: 5,),
                  Icon(Icons.notifications_rounded),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bonjours,", style: TextStyle(fontSize: 35, fontFamily: 'Poppins', fontWeight: FontWeight.bold),),
            Text(user.name, style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),)
          ],
        )
      ],
    );
  }
}
