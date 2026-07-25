import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_venue_manager/core/colors/app_colors.dart';
import 'package:your_venue_manager/features/authentication/repository/venue_verification_repository.dart';
import 'package:your_venue_manager/features/authentication/view/venue_verification_screen.dart';
import 'package:your_venue_manager/features/authentication/view_model/bloc/manager_auth_bloc/manager_auth_bloc.dart';
import 'package:your_venue_manager/features/authentication/view_model/bloc/venue_verification_bloc/venue_verification_bloc.dart';
import 'package:your_venue_manager/features/authentication/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  @override
  void dispose() {
    nameController;
    emailController;
    phoneController;
    passwordController;
    confirmPasswordController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ManagerAuthBloc, ManagerAuthState>(
      listener: (context, state) {
        if (state is ManagerRegistrationSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => VenueVerificationBloc(
                  repository: VenueVerificationRepository(),
                ),
                child: const VenueVerificationScreen(),
              ),
            ),
          );
        }

        if (state is ManagerAuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(
                  "assets/images/logo without name.png",
                ),
              ),
              Text(
                "Your Venue Manager",
                style: TextStyle(
                  color: Color(0xff0A2D5E),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Register Your\nVenue Business",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0A2D5E),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Join our platform and start receiving venue bookings. "
                "Elevate your business with luxury management tools and "
                "connect with high-end clients looking for the perfect space.",
                style: TextStyle(color: Colors.black54, height: 1.5),
              ),

              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildSection(
                      title: "Owner Details",
                      icon: Icons.person_outline,
                      children: [
                        buildTextField(
                          "Owner Name",
                          "e.g. Alexander Sterling",
                          Icons.person_outline,
                          nameController,
                          (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          "Email Address",
                          "owner@venue.com",
                          Icons.email_outlined,
                          emailController,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter you email';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          "Phone Number",
                          "+1 (555) 000-0000",
                          Icons.phone_outlined,
                          phoneController,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter you phone number';
                            }
                            if (value.length != 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    buildSection(
                      title: "Authentication",
                      icon: Icons.lock_outline,
                      children: [
                        buildPasswordField(
                          "Password",
                          passwordController,
                          "Enter your password",
                          isPasswordObscure,
                          () {
                            // setState(() {
                            //   isPasswordObscure = !isPasswordObscure;
                            // });
                          },
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter password';
                            }

                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        buildPasswordField(
                          "Confirm Password",
                          confirmPasswordController,
                          "Confirm your password",
                          isConfirmPasswordObscure,
                          () {
                            // setState(() {
                            //   isConfirmPasswordObscure =
                            //       !isConfirmPasswordObscure;
                            // });
                          },
                          (value) {
                            if (value != passwordController.text) {
                              return 'Password do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    BlocBuilder<ManagerAuthBloc, ManagerAuthState>(
                      builder: (context, state) {
                        if (state is ManagerAuthLoading) {
                          return const SizedBox(
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return PrimaryButton(
                          text: "Register Account",
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (passwordController.text.trim() !=
                                  confirmPasswordController.text.trim()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Passwords do not match"),
                                  ),
                                );
                                return;
                              }

                              context.read<ManagerAuthBloc>().add(
                                RegisterManagerEvent(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                          backgroundColor: AppColors.primaryColor,
                          textColor: AppColors.white,
                          borderSideColor: AppColors.primaryColor,
                        );
                      },
                    ),

                    // BlocConsumer<ManagerAuthBloc, ManagerAuthState>(
                    //   listener: (context, state) {
                    //     if (state is ManagerSuccess) {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => VenueVerificationScreen(),
                    //         ),
                    //       );
                    //     }

                    //     if (state is ManagerFailure) {
                    //       ScaffoldMessenger.of(
                    //         context,
                    //       ).showSnackBar(SnackBar(content: Text(state.error)));
                    //     }
                    //   },
                    //   builder: (context, state) {
                    //     return SizedBox(
                    //       width: double.infinity,
                    //       height: 50,
                    //       child: state is ManagerLoading
                    //           ? const Center(child: CircularProgressIndicator())
                    //           : PrimaryButton(
                    //               text: "Register Account",
                    //               onTap: () {
                    //                 if (_formKey.currentState!.validate()) {
                    //                   if (passwordController.text.trim() !=
                    //                       confirmPasswordController.text.trim()) {
                    //                     ScaffoldMessenger.of(
                    //                       context,
                    //                     ).showSnackBar(
                    //                       SnackBar(
                    //                         content: Text(
                    //                           "Passwords do not match",
                    //                         ),
                    //                       ),
                    //                     );
                    //                     return;
                    //                   }

                    //                   context.read<ManagerAuthBloc>().add(
                    //                     RegisterManagerEvent(
                    //                       name: nameController.text.trim(),
                    //                       email: emailController.text.trim(),
                    //                       phone: phoneController.text.trim(),
                    //                       password: passwordController.text
                    //                           .trim(),
                    //                     ),
                    //                   );
                    //                 }
                    //               },
                    //               backgroundColor: AppColors.primaryColor,
                    //               textColor: AppColors.white,
                    //               borderSideColor: AppColors.primaryColor,
                    //             ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text.rich(
                  TextSpan(
                    text: "I agree to the ",
                    children: [
                      TextSpan(
                        text: "Terms & Conditions",
                        style: TextStyle(
                          color: Color(0xff002B5B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "\nPrivacy Policy."),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Color(0xff002B5B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildSection({
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xff0A2D5E)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xff0A2D5E),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),

        const Divider(height: 25),

        ...children,
      ],
    ),
  );
}

Widget buildTextField(
  String label,
  String hint,
  IconData icon,
  TextEditingController controller,
  String? Function(String? value)? validator,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        ),
      ],
    ),
  );
}

Widget buildPasswordField(
  String label,
  TextEditingController controller,
  String hint,
  bool obscureText,
  VoidCallback onVisibilityToggle,
  String? Function(String? value)? validator,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              onPressed: onVisibilityToggle,
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        ),
      ],
    ),
  );
}

Widget buildDropdown(String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: const [
            DropdownMenuItem(
              value: "Wedding Hall",
              child: Text("Wedding Hall"),
            ),
            DropdownMenuItem(
              value: "Convention Center",
              child: Text("Convention Center"),
            ),
            DropdownMenuItem(
              value: "Conference Hall",
              child: Text("Conference Hall"),
            ),
            DropdownMenuItem(value: "Event Space", child: Text("Event Space")),
          ],
          onChanged: (value) {},
        ),
      ],
    ),
  );
}
