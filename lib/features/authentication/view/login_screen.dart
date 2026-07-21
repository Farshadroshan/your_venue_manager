import 'package:flutter/material.dart';
import 'package:your_venue_manager/features/authentication/view/register_screen.dart';
import 'package:your_venue_manager/features/authentication/widgets/custom_text_field.dart';
import 'package:your_venue_manager/features/authentication/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    final TextEditingController passwordController = TextEditingController();

    bool hidePassword = true;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo without name.png',
                    height: 100,
                  ),

                  const SizedBox(height: 16),

                  // Welcome Text
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2A52),
                      fontFamily: 'Serif',
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Sign in to manage your venues, bookings,\nand customers.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 24),

                  // Email
                  CustomTextField(
                    label: "Email Address",
                    hint: "Email Address",
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 20),

                  // Password
                  CustomTextField(
                    label: "Password",
                    hint: "Password",
                    controller: passwordController,
                    prefixIcon: Icons.lock_outline,
                    obscureText: hidePassword,
                    suffixIcon: IconButton(onPressed: () {
                      
                    }, icon: IconButton(onPressed: () {
                      
                    }, icon: Icon( Icons.visibility_off_outlined))),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFF0A2A52),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                 
                  PrimaryButton(
                    text: 'Login',
                    backgroundColor: const Color(0xFF0B2C5F),
                    textColor: Colors.white,
                    onTap: () {},
                    borderSideColor: Color(0xFF002B5B),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("OR"),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: "Register New Account",
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                    },
                    backgroundColor: Colors.white,
                    textColor: Color(0xFF002B5B),
                    borderSideColor: Color(0xFF002B5B),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
