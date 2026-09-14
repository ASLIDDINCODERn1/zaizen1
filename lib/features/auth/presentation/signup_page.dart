import 'package:flutter/material.dart';
import 'package:zaizen/features/auth/presentation/login_page.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(startOnSignUp: true);
  }
}
