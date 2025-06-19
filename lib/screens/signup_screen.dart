import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/providers/auth_provider.dart';
import 'package:vybe/screens/registration_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091227),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset('assets/vybe_logo.png', width: 200),
              const SizedBox(height: 20),
              Text("Feel the Vybe", style: _headingTextStyle()),
              const SizedBox(height: 8),
              Text(
                "Catch the rythm, live the moment.",
                style: _subheadingTextStyle(),
              ),
              const Spacer(flex: 3),
              _signUpButton(context),
              const SizedBox(height: 12),
              _googleButton(context),
              const Spacer(flex: 2),
              _bottomLoginText(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🎨 Text Styles
  TextStyle _headingTextStyle() {
    return const TextStyle(
      color: Color(0xFFEAF0FF),
      fontSize: 27,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
    );
  }

  TextStyle _subheadingTextStyle() {
    return const TextStyle(
      color: Color(0xFFEAF0FF),
      fontSize: 22,
      fontFamily: "Poppins",
    );
  }

  // 🎨 Common button shape
  RoundedRectangleBorder _roundedShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(30));
  }

  // ✅ Sign Up Button
  Widget _signUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8DCBEC),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
        shape: _roundedShape(),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  // ✅ Google Button
  Widget _googleButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final auth = ref.read(authServiceProvider);

        try {
          final result = await auth.signInWithGoogle();
          if (result != null) {
            // Navigate to home or success screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Google Sign-in successful')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Google Sign-in failed: $e')));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF091227),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
        shape: _roundedShape(),
        side: const BorderSide(color: Colors.white),
        elevation: 0,
      ),
      icon: Image.asset('assets/google.png', height: 24, width: 24),
      label: const Text(
        'Continue with Google',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ✅ Bottom "Already have an account" Section
  Widget _bottomLoginText() {
    return Column(
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(
            color: Color(0xFFEAF0FF),
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to login screen
          },
          child: const Text(
            "Login",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEAF0FF),
            ),
          ),
        ),
      ],
    );
  }
}
