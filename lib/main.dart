import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/screens/registration_screen.dart';
import 'package:vybe/screens/signup_screen.dart';
import 'package:vybe/screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: VybeApp()));
}

class VybeApp extends StatelessWidget {
  const VybeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vybe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const RegisterScreen(),
    );
  }
}
