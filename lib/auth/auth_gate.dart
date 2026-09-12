import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/pages/homepage.dart';
import 'package:zaizen/pages/login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthService.instance.authChanges,
      initialData: AuthState(
        AuthChangeEvent.initialSession,
        AuthService.instance.session,
      ),
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? AuthService.instance.session;
        if (session != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
