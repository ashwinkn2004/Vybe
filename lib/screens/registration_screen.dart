import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/providers/auth_provider.dart';
import 'package:vybe/screens/login_screen.dart';
import 'package:vybe/screens/home_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091227),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 1),
                _title("SignUp"),
                const SizedBox(height: 30),

                _label("Username"),
                const SizedBox(height: 8),
                _inputField(controller: usernameController),
                const SizedBox(height: 16),

                _label("Email"),
                const SizedBox(height: 8),
                _inputField(controller: emailController),
                const SizedBox(height: 16),

                _label("Password"),
                const SizedBox(height: 8),
                _inputField(controller: passwordController, obscureText: true),
                const SizedBox(height: 16),

                _label("Confirm Password"),
                const SizedBox(height: 8),
                _inputField(
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                _signUpButton(context),
                const Spacer(flex: 2),

                _bottomLoginText(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📌 Title
  Widget _title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // 🏷️ Label
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  // 🔤 Input Field
  Widget _inputField({
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: const Color(0xFF8DCBEC),
      style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF777777),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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
    final isLoading = ref.watch(isSigningUpProvider);

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: 40,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _registerUser(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8DCBEC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Color(0xFF091227), // matches your theme
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  "Sign up",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  // ⬇️ Already have an account? Login
  Widget _bottomLoginText(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            "Already have an account?",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xFFEAF0FF),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
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
      ),
    );
  }

  // 🧠 Sign-Up Logic
  Future<void> _registerUser(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError(context, 'Please fill in all fields');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError(context, 'Invalid email format');
      return;
    }

    if (password.length < 6) {
      _showError(context, 'Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showError(context, 'Passwords do not match');
      return;
    }

    final auth = ref.read(authServiceProvider);
    try {
      final result = await auth.signUpWithEmailPassword(
        username: username,
        email: email,
        password: password,
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
