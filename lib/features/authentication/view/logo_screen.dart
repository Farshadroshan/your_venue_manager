import 'package:flutter/material.dart';
import 'package:your_venue_manager/features/authentication/view/login_screen.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  
  @override
  void initState() {
    super.initState();
    navigate();
  }

  Future<void>navigate()async{
    await Future.delayed(Duration(seconds: 3));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/bg_removed_logo.png", width: 180),
      ),
    );
  }
}