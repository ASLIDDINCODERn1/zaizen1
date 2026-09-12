import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/login.dart' show AppColors;

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _isReady = false;
  ConnectivityResult _type = ConnectivityResult.none;

  bool get isOnline => _isOnline;
  bool get isReady => _isReady;
  ConnectivityResult get connectionType => _type;

  StreamSubscription<List<ConnectivityResult>>? _sub;

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    await refresh();
    _sub = Connectivity().onConnectivityChanged.listen((results) {
      _apply(results);
    });
  }

  Future<void> refresh() async {
    final result = await Connectivity().checkConnectivity();
    _apply(result);
  }

  void _apply(List<ConnectivityResult> results) {
    final hasWifi = results.contains(ConnectivityResult.wifi);
    final hasMobile = results.contains(ConnectivityResult.mobile);
    final hasEthernet = results.contains(ConnectivityResult.ethernet);
    final online = hasWifi || hasMobile || hasEthernet;
    final type = hasWifi
        ? ConnectivityResult.wifi
        : hasMobile
            ? ConnectivityResult.mobile
            : hasEthernet
                ? ConnectivityResult.ethernet
                : ConnectivityResult.none;

    final changed = online != _isOnline || type != _type || !_isReady;
    _isOnline = online;
    _type = type;
    _isReady = true;
    if (changed) notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _waveCtrl;
  late AnimationController _barCtrl;

  late Animation<double> _pulse;
  late List<Animation<double>> _waves;
  bool _checking = false;

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

    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _waveCtrl.dispose();
    _barCtrl.dispose();
    super.dispose();
  }

  Future<void> _retry() async {
    setState(() => _checking = true);
    await context.read<ConnectivityProvider>().refresh();
    if (mounted) setState(() => _checking = false);
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
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ..._waves.asMap().entries.map((entry) {
                      return AnimatedBuilder(
                        animation: entry.value,
                        builder: (_, __) {
                          final opacity =
                              (1.0 - entry.value.value).clamp(0.0, 1.0);
                          final size = 70 + entry.value.value * 110;
                          return Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFEF4444)
                                    .withValues(alpha: opacity * 0.55),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    ScaleTransition(
                      scale: _pulse,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.wifi_slash,
                              color: Color(0xFFEF4444),
                              size: 34,
                            ),
                            const SizedBox(height: 4),
                            AnimatedBuilder(
                              animation: _barCtrl,
                              builder: (_, __) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(3, (i) {
                                    final t = (_barCtrl.value + i * 0.22) % 1.0;
                                    final h = 4.0 + (t < 0.5 ? t : 1 - t) * 10;
                                    return Container(
                                      width: 4,
                                      height: h,
                                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444).withValues(alpha: 0.85),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                s.noInternet,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
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
              const SizedBox(height: 12),
              const Text(
                'Wi-Fi  •  Mobile data',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _checking ? null : _retry,
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
                  child: _checking
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
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
