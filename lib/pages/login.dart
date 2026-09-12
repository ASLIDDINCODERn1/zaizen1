import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ─── Color Palette — Blue & Black ────────────────────────────────
class AppColors {
  static const bgTop = Color(0xFF0D1526);
  static const bgBottom = Color(0xFF05070C);
  static const surface = Color(0xFF11151F);
  static const surfaceFocused = Color(0xFF161C2C);
  static const border = Color(0xFF232838);
  static const borderFocused = Color(0xFF3B82F6);
  static const primary = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF2563EB);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF9AA3B2);
  static const textMuted = Color(0xFF6B7280);
  static const google = Color(0xFFEA4335);
  static const facebook = Color(0xFF3B82F6);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _obscure = true;
  bool _remember = false;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  bool _emailFocused = false;
  bool _passFocused = false;

  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _emailFocus.addListener(() {
      setState(() => _emailFocused = _emailFocus.hasFocus);
    });
    _passFocus.addListener(() {
      setState(() => _passFocused = _passFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _handleGoogle() => HapticFeedback.selectionClick();
  void _handleFacebook() => HapticFeedback.selectionClick();
  void _handleGuest() => HapticFeedback.selectionClick();
  void _handleSignIn() => HapticFeedback.mediumImpact();

  Widget _staggered(Widget child, {required double start, double end = 1.0}) {
    final curved = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curved,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: curved.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - curved.value) * 18),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            /// 1. Deep navy-to-black background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.bgTop, AppColors.bgBottom],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.6],
                ),
              ),
            ),

            /// 2. Soft blue halo behind the logo
            Align(
              alignment: const Alignment(0, -0.72),
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.28),
                      AppColors.primary.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            /// 3. Main content
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircleBtn(icon: CupertinoIcons.back, onTap: () {}),
                        _CircleBtn(icon: CupertinoIcons.refresh, onTap: () {}),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),

                          /// Logo — unchanged asset, just placed on the new bg
                          _staggered(
                            start: 0.0,
                            end: 0.5,
                            Hero(
                              tag: "app_logo",
                              child: Container(
                                width: 108,
                                height: 108,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.35),
                                      blurRadius: 36,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/logo.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: AppColors.surface,
                                      child: const Icon(
                                        CupertinoIcons.airplane,
                                        color: AppColors.primary,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          _staggered(
                            start: 0.05,
                            end: 0.55,
                            const Text(
                              'Xush kelibsiz!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _staggered(
                            start: 0.1,
                            end: 0.6,
                            const Text(
                              'Hisobingizga kiring va davom eting',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// Email field
                          _staggered(
                            start: 0.15,
                            end: 0.65,
                            _LabeledField(
                              label: 'Email manzil',
                              hint: 'example@gmail.com',
                              keyboardType: TextInputType.emailAddress,
                              focusNode: _emailFocus,
                              focused: _emailFocused,
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// Password field
                          _staggered(
                            start: 0.2,
                            end: 0.7,
                            _LabeledField(
                              label: 'Parol',
                              hint: '••••••••',
                              obscure: _obscure,
                              focusNode: _passFocus,
                              focused: _passFocused,
                              suffix: CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                child: Icon(
                                  _obscure
                                      ? CupertinoIcons.eye_slash
                                      : CupertinoIcons.eye,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// Remember me + Forgot password
                          _staggered(
                            start: 0.25,
                            end: 0.72,
                            Row(
                              children: [
                                _Checkbox(
                                  value: _remember,
                                  onChanged: (v) =>
                                      setState(() => _remember = v),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Meni eslab qol',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minSize: 0,
                                  onPressed: () {},
                                  child: const Text(
                                    'Parolni unutdingizmi?',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 26),

                          /// Sign in button
                          _staggered(
                            start: 0.3,
                            end: 0.78,
                            _PrimaryButton(
                              label: 'Kirish',
                              onTap: _handleSignIn,
                            ),
                          ),

                          const SizedBox(height: 26),

                          _staggered(
                            start: 0.36,
                            end: 0.82,
                            const Text(
                              'Yoki davom eting',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// Social buttons — outlined pills
                          _staggered(
                            start: 0.4,
                            end: 0.86,
                            Row(
                              children: [
                                Expanded(
                                  child: _SocialOutlineButton(
                                    icon: Icons.g_mobiledata_rounded,
                                    iconColor: AppColors.google,
                                    label: 'Google',
                                    onTap: _handleGoogle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SocialOutlineButton(
                                    icon: Icons.facebook_rounded,
                                    iconColor: AppColors.facebook,
                                    label: 'Facebook',
                                    onTap: _handleFacebook,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          _staggered(
                            start: 0.44,
                            end: 0.9,
                            _SocialOutlineButton(
                              icon: CupertinoIcons.person_solid,
                              iconColor: Colors.grey.shade300,
                              label: 'Mehmon sifatida davom etish',
                              onTap: _handleGuest,
                            ),
                          ),

                          const SizedBox(height: 30),

                          _staggered(
                            start: 0.5,
                            end: 0.95,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Hisobingiz yo'qmi? ",
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14.5,
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minSize: 0,
                                  onPressed: () {},
                                  child: const Text(
                                    "Ro'yxatdan o'tish",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// Home-indicator style bar, matching reference
                          Container(
                            width: 90,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─── Circle icon button (top bar) ────────────────────────────────
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 19),
      ),
    );
  }
}

/// ─── Labeled input field (label above, placeholder inside) ──────
class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final Widget? suffix;
  final bool obscure;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool focused;

  const _LabeledField({
    required this.label,
    required this.hint,
    this.suffix,
    this.obscure = false,
    this.keyboardType,
    this.focusNode,
    this.focused = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(text: label),
              const TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: focused ? AppColors.surfaceFocused : AppColors.surface,
            border: Border.all(
              color: focused ? AppColors.borderFocused : AppColors.border,
              width: focused ? 1.4 : 1,
            ),
            boxShadow: focused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 14,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            focusNode: focusNode,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: AppColors.textMuted, fontSize: 14.5),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}

/// ─── Simple checkbox to match reference style ────────────────────
class _Checkbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Checkbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: value ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: value ? AppColors.primary : AppColors.border,
            width: 1.4,
          ),
        ),
        child: value
            ? const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 13)
            : null,
      ),
    );
  }
}

/// ─── Primary blue pill button ────────────────────────────────
class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            gradient: const LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(_pressed ? 0.25 : 0.45),
                blurRadius: _pressed ? 10 : 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.bolt_fill, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ─── Outlined pill social button ────────────────────────────────
class _SocialOutlineButton extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _SocialOutlineButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialOutlineButton> createState() => _SocialOutlineButtonState();
}

class _SocialOutlineButtonState extends State<_SocialOutlineButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.iconColor, size: 22),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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