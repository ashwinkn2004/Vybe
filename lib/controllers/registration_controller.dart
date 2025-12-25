import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

final registrationControllerProvider =
    Provider((ref) => RegistrationController(ref));

class RegistrationController {
  final Ref ref;

  RegistrationController(this.ref);

  Future<void> registerUser({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validate
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

    // Proceed with Firebase registration
    final auth = ref.read(authServiceProvider);
    try {
      await auth.signUpWithEmailPassword(
        username: username,
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );
      Navigator.pop(context); // Or navigate to home
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
