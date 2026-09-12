import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/homepage.dart';
import 'package:zaizen/pages/onboarding.dart';
import 'package:zaizen/pages/profile_menus/app_lock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return MaterialApp(
      title: 'Zaizen App',
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('uz'),
        Locale('ru'),
        Locale('en'),
        Locale('ja'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(
        nextScreen: HomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// ─── HAR SAFAR ILOVADAN CHIQIB QAYTGANDA QULFLASH (AppSecurityGate) ────────
class AppSecurityGate extends StatefulWidget {
  final Widget child;
  const AppSecurityGate({super.key, required this.child});

  @override
  State<AppSecurityGate> createState() => _AppSecurityGateState();
}

class _AppSecurityGateState extends State<AppSecurityGate> with WidgetsBindingObserver {
  bool _isLocked = false;
  bool _isInitialized = false;
  DateTime? _pausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkInitialLock() async {
    final pin = await SecurityHelper.getSavedPin();
    if (!mounted) return;

    setState(() {
      _isLocked = pin != null && pin.isNotEmpty;
      _isInitialized = true;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Barmoq izi tizim oynasi ochiqligida qayta qulflamaymiz
    if (SecurityHelper.isAuthenticating) return;

    if (state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_pausedTime != null) {
        final diff = DateTime.now().difference(_pausedTime!);
        _pausedTime = null;

        // Ilovadan chindan ham 800ms dan ko'proq chiqib ketilgan bo'lsa qulflaymiz
        if (diff.inMilliseconds > 800) {
          _checkInitialLock();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF020617),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6))),
      );
    }

    if (_isLocked) {
      return AppLockScreen(
        onAuthenticated: () {
          setState(() => _isLocked = false);
        },
      );
    }

    return widget.child;
  }
}