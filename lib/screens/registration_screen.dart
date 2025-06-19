import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF091227),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title("SignUp"),
              const SizedBox(height: 30),
              _label("Username"),
              _inputField(),
              const SizedBox(height: 16),
              _label("Email"),
              _inputField(),
              const SizedBox(height: 16),
              _label("Password"),
              _inputField(obscureText: true),
              const SizedBox(height: 16),
              _label("Confirm Password"),
              _inputField(obscureText: true),
              const SizedBox(height: 30),
              _signUpButton(context),
              const SizedBox(height: 30),
              _bottomLoginText(context),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Title
  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }

  // 🏷️ Label
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  // 🔤 Input Field
  Widget _inputField({bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF3A3A3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  // ✅ Sign Up Button
  Widget _signUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Handle sign-up logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8DCBEC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          "Sign up",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ⬇️ Already have an account? Log in
  Widget _bottomLoginText(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            "Already have an account ?",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFFEAF0FF),
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to login screen
            },
            child: const Text(
              "Log in",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFFEAF0FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
