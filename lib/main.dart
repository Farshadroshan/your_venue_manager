import 'package:flutter/material.dart';
import 'package:your_venue_manager/features/authentication/view/logo_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogoScreen(),
    );
  }
}
