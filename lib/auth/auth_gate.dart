import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/pages/homepage.dart';
import 'package:zaizen/pages/login.dart';
import 'package:zaizen/pages/update_password.dart';
import 'package:zaizen/ui/language_picker_bar.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with WidgetsBindingObserver {
  Session? _session;
  AuthChangeEvent? _event;
  StreamSubscription<AuthState>? _sub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session = AuthService.instance.session;
    _sub = AuthService.instance.authChanges.listen((data) {
      if (!mounted) return;
      setState(() {
        _event = data.event;
        _session = data.session ?? AuthService.instance.session;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final current = AuthService.instance.session;
    if (!mounted) return;
    if (current?.accessToken != _session?.accessToken) {
      setState(() => _session = current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = _session ?? AuthService.instance.session;

    if (_event == AuthChangeEvent.passwordRecovery) {
      return const UpdatePasswordScreen();
    }
    if (session != null) {
      return const HomeScreen();
    }
    return const _LoginWithLanguage();
  }
}

class _LoginWithLanguage extends StatelessWidget {
  const _LoginWithLanguage();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        LoginScreen(),
        Positioned(
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
