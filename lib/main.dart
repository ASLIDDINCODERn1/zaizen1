import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/l10n/supported_languages.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/homepage.dart';
import 'package:zaizen/pages/no_internet_screen.dart';
import 'package:zaizen/pages/onboarding.dart';
import 'package:zaizen/pages/profile_menus/app_lock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
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
      key: ValueKey(localeProvider.locale.languageCode),
      title: 'Zaizen App',
      locale: localeProvider.locale,
      supportedLocales: [
        for (final lang in kSupportedLanguages) Locale(lang.code),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return const Locale('uz');
        for (final s in supported) {
          if (s.languageCode == locale.languageCode) return s;
        }
        return const Locale('uz');
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ConnectivityGate(
        child: SplashScreen(
          nextScreen: HomeScreen(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConnectivityGate extends StatelessWidget {
  final Widget child;
  const ConnectivityGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final net = context.watch<ConnectivityProvider>();
    if (!net.isReady) {
      return const Scaffold(
        backgroundColor: Color(0xFF020617),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6))),
      );
    }
    if (!net.isOnline) {
      return const NoInternetScreen();
    }
    return child;
  }
}

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
    if (SecurityHelper.isAuthenticating) return;

    if (state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_pausedTime != null) {
        final diff = DateTime.now().difference(_pausedTime!);
        _pausedTime = null;
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
