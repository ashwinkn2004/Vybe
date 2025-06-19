import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('userDetails')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['username'] ?? 'User';
      }
    }

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091227),
      body: Center(
        child: FutureBuilder<String>(
          future: _fetchUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.white);
            }

            if (snapshot.hasError) {
              return const Text(
                'Error loading username',
                style: TextStyle(color: Colors.red),
              );
            }

            final username = snapshot.data ?? 'User';

            return Text(
              'Welcome, $username!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            );
          },
        ),
      ),
    );
  }
}
