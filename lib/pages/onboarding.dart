import 'package:flutter/material.dart';
import 'package:zaizen/pages/profile_menus/app_lock.dart';
// Xavfsizlik va Lock ekranini import qiling

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _smokeRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.4, curve: Curves.elasticOut),
      ),
    );

    _smokeRevealAnimation = Tween<double>(begin: -0.2, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.9, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // ─── PIN VA XAVFSIZLIKNI TEKSHIRIB O'TISH ───────────────────────
    Future.delayed(const Duration(milliseconds: 4500), () async {
      if (!mounted) return;

      // 1. SharedPreferences da PIN o'rnatilganmi yo'qmi tekshiramiz
      final savedPin = await SecurityHelper.getSavedPin();
      if (!mounted) return;

      Widget targetScreen;

      if (savedPin != null && savedPin.isNotEmpty) {
        // 2. Agar PIN o'rnatilgan bo'lsa -> Avval Lock (PIN / Barmoq izi) ekrani chiqadi
        targetScreen = AppLockScreen(
          nextScreen: widget.nextScreen,
        );
      } else {
        // 3. Agar hali PIN o'rnatilmagan bo'lsa -> to'g'ridan-to'g'ri keyingi ekranga
        targetScreen = widget.nextScreen;
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, _, _) => targetScreen,
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D91),
      body: Center(
        child: RepaintBoundary(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 150,
                      filterQuality: FilterQuality.low,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _smokeRevealAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.lightBlueAccent.withOpacity(0.9),
                          Colors.transparent,
                        ],
                        stops: [
                          _smokeRevealAnimation.value - 0.15,
                          _smokeRevealAnimation.value,
                          _smokeRevealAnimation.value + 0.1,
                        ],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'ZAIZEN • ザイゼン',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}