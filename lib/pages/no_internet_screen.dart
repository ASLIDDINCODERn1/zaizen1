import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/login.dart' show AppColors;

/// ─── INTERNET HOLATI BOSHQARUVI ──────────────────────────────────────────────
class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  StreamSubscription<List<ConnectivityResult>>? _sub;

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    // Dastlabki holatni tekshirish
    final result = await Connectivity().checkConnectivity();
    _isOnline = _check(result);
    notifyListeners();

    // Real-time kuzatish
    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final online = _check(results);
      if (online != _isOnline) {
        _isOnline = online;
        notifyListeners();
      }
    });
  }

  bool _check(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// ─── NO INTERNET SCREEN ──────────────────────────────────────────────────────
class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _waveCtrl;

  late Animation<double> _pulse;
  late List<Animation<double>> _waves;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.9, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _waves = List.generate(3, (i) {
      final start = i * 0.25;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _waveCtrl,
          curve: Interval(start, (start + 0.6).clamp(0, 1.0),
              curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgTop, AppColors.bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated WiFi signal icon
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Radiating waves
                    ..._waves.asMap().entries.map((entry) {
                      return AnimatedBuilder(
                        animation: entry.value,
                        builder: (_, __) {
                          final opacity =
                              (1.0 - entry.value.value).clamp(0.0, 1.0);
                          final size = 60 + entry.value.value * 100;
                          return Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFEF4444)
                                    .withValues(alpha: opacity * 0.5),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    // Center icon
                    ScaleTransition(
                      scale: _pulse,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.wifi_slash,
                          color: Color(0xFFEF4444),
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                s.noInternet,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  s.noInternetDesc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              // Retry button
              GestureDetector(
                onTap: () async {
                  final result = await Connectivity().checkConnectivity();
                  final provider = context.read<ConnectivityProvider>();
                  // Provider o'zi stream orqali yangilanadi, bu faqat tezroq ko'rsatish uchun
                  final _ = result;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    s.retry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
