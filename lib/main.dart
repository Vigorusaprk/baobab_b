import 'package:baobab_business/features/business/presentation/bloc/business_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/constants/supabase_client.dart';
import 'core/di/service_locator.dart' as di;
import 'core/routes/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  await SupabaseClientWrapper.initialize();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatusRequested()),
        ),
        BlocProvider(create: (_) => di.sl<BusinessCubit>()), // ← ajout
      ],
      child: MaterialApp.router(
        title: 'Baobabe Business',
        theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Poppins'),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}