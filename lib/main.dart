import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:your_venue_manager/features/authentication/repository/manager_auth_repository.dart';
import 'package:your_venue_manager/features/authentication/view/logo_screen.dart';
import 'package:your_venue_manager/features/authentication/view_model/bloc/manager_auth_bloc/manager_auth_bloc.dart';
import 'package:your_venue_manager/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ManagerAuthRepository(),
      child: BlocProvider(
        create: (context) =>
            ManagerAuthBloc(repository: context.read<ManagerAuthRepository>()),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LogoScreen(),
        ),
      ),
    );
  }
}
