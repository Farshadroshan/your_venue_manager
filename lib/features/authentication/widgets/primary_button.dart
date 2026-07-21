import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final Color borderSideColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    required this.backgroundColor,
    required this.textColor,
    required this.borderSideColor,
  });

  @override
  Widget build(BuildContext context) {
    //login button
    // SizedBox(
    //   width: double.infinity,
    //   height: 50,
    //   child: ElevatedButton(
    //     onPressed: () {},
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: const Color(0xFF002B5B),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //     ),
    //     child: const Text(
    //       'Login  →',
    //       style: TextStyle(fontSize: 16, color: Colors.white),
    //     ),
    //   ),
    // ),

    //Register
    // SizedBox(
    //                 width: double.infinity,
    //                 height: 50,
    //                 child: OutlinedButton(
    //                   onPressed: () {},
    //                   style: OutlinedButton.styleFrom(
    //                     side: const BorderSide(color: Color(0xFF002B5B)),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(8),
    //                     ),
    //                   ),
    //                   child: const Text(
    //                     'Register New Account',
    //                     style: TextStyle(color: Color(0xFF002B5B)),
    //                   ),
    //                 ),
    //               ),
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 6,
          side: BorderSide(color: borderSideColor),
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
