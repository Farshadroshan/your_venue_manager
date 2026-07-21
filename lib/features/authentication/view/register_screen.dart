import 'package:flutter/material.dart';
import 'package:your_venue_manager/features/authentication/view/venue_verification_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/images/logo without name.png"),
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
              style: TextStyle(
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            buildSection(
              title: "Owner Details",
              icon: Icons.person_outline,
              children: [
                buildTextField(
                  "Owner Name",
                  "e.g. Alexander Sterling",
                  Icons.person_outline,
                ),
                buildTextField(
                  "Email Address",
                  "owner@venue.com",
                  Icons.email_outlined,
                ),
                buildTextField(
                  "Phone Number",
                  "+1 (555) 000-0000",
                  Icons.phone_outlined,
                ),
              ],
            ),

            const SizedBox(height: 20),

            buildSection(
              title: "Business Details",
              icon: Icons.business_center_outlined,
              children: [
                buildTextField(
                  "Venue Name",
                  "The Grand Palladium",
                  Icons.location_city_outlined,
                ),

                buildDropdown("Venue Type"),

                buildTextField(
                  "Business Address",
                  "123 Luxury Lane, Metropolis",
                  Icons.location_on_outlined,
                ),

                buildTextField(
                  "Capacity (Guests)",
                  "450",
                  Icons.people_outline,
                ),

                buildTextField(
                  "Price Per Day (USD)",
                  "2,500",
                  Icons.currency_rupee,
                ),
              ],
            ),

            const SizedBox(height: 20),

            buildSection(
              title: "Authentication",
              icon: Icons.lock_outline,
              children: [
                buildPasswordField("Password"),
                buildPasswordField("Confirm Password"),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => VenueVerificationScreen(),));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff002B5B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "REGISTER ACCOUNT",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
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
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPasswordField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: const Icon(Icons.visibility_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                value: "Banquet Hall",
                child: Text("Banquet Hall"),
              ),
            ],
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }