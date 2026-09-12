import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/pages/homepage.dart';
import 'package:zaizen/pages/login.dart';
import 'package:zaizen/pages/update_password.dart';
import 'package:zaizen/ui/language_picker_bar.dart';

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
        final event = snapshot.data?.event;
        final session = snapshot.data?.session ?? AuthService.instance.session;

        if (event == AuthChangeEvent.passwordRecovery) {
          return const UpdatePasswordScreen();
        }

        if (session != null) {
          return const HomeScreen();
        }
        return const _LoginWithLanguage();
      },
    );
  }
}

class _LoginWithLanguage extends StatelessWidget {
  const _LoginWithLanguage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const LoginScreen(),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: LanguagePickerBar(),
            ),
          ),
        ),
      ],
    );
  }
}
