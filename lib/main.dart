import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaizen/auth/auth_gate.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/auth/profile_store.dart';
import 'package:zaizen/l10n/supported_languages.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/no_internet_screen.dart';
import 'package:zaizen/pages/onboarding.dart';
import 'package:zaizen/ui/status_bar_guard.dart';

const _supabaseUrl = 'https://vazzsnxyqbumqstjgsln.supabase.co';
const _supabaseAnonKey = 'sb_publishable_0gYD9sXBEp5N16haSniQew_6bsbiV3X';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      autoRefreshToken: true,
      detectSessionInUri: true,
    ),
  );
  AuthService.instance.startSessionListener();
  await StatusBarGuard.hide();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => ProfileStore()),
      ],
      child: const StatusBarGuard(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final net = context.watch<ConnectivityProvider>();
    return MaterialApp(
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
      builder: (context, child) {
        StatusBarGuard.hide();
        if (!net.isReady) {
          return const Scaffold(
            backgroundColor: Color(0xFF020617),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6))),
          );
        }
        if (!net.isOnline) {
          return const NoInternetScreen();
        }
        return child ?? const SizedBox.shrink();
      },
      home: AppLaunch.splashDone
          ? const AuthGate()
          : const SplashScreen(nextScreen: AuthGate()),
      debugShowCheckedModeBanner: false,
    );
  }
}
