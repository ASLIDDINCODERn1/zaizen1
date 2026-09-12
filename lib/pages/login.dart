import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/auth/password_rules.dart';
import 'package:zaizen/l10n/l10n_scope.dart';
import 'package:zaizen/pages/forgot_password.dart';

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
  static const error = Color(0xFFEF4444);
}

class LoginScreen extends StatefulWidget {
  final bool startOnSignUp;
  const LoginScreen({super.key, this.startOnSignUp = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late bool _isSignUp;
  bool _obscure = true;
  bool _obscure2 = true;
  bool _loading = false;
  bool _googleLoading = false;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.startOnSignUp;
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _passCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? const Color(0xFFEF4444) : AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleGoogle() async {
    HapticFeedback.selectionClick();
    setState(() => _googleLoading = true);
    try {
      await AuthService.instance.signInWithGoogle();
    } catch (e) {
      _toast(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _handleSubmit() async {
    HapticFeedback.mediumImpact();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final emailErr = PasswordRules.emailError(email);
    if (emailErr != null) {
      _toast(emailErr, error: true);
      return;
    }
    if (_isSignUp) {
      final nameErr = PasswordRules.nameError(_nameCtrl.text);
      if (nameErr != null) {
        _toast(nameErr, error: true);
        return;
      }
      final passErr = PasswordRules.passwordError(pass, email: email);
      if (passErr != null) {
        _toast(passErr, error: true);
        return;
      }
      final confirmErr = PasswordRules.confirmError(pass, _confirmCtrl.text);
      if (confirmErr != null) {
        _toast(confirmErr, error: true);
        return;
      }
    } else if (pass.isEmpty) {
      _toast(L.read(context).authEnterPassword, error: true);
      return;
    }

    setState(() => _loading = true);
    try {
      if (_isSignUp) {
        final res = await AuthService.instance.signUpWithEmail(
          email: email,
          password: pass,
          fullName: _nameCtrl.text.trim(),
        );
        if (!mounted) return;
        if (res.session == null) {
          _toast(L.read(context).authAccountCreated);
          setState(() => _isSignUp = false);
        }
      } else {
        await AuthService.instance.signInWithEmail(email, pass);
      }
    } catch (e) {
      _toast(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
            offset: Offset(0, (1 - curved.value) * 22),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final s = L.of(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.bgTop, AppColors.bgBottom],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SizedBox.expand(),
            ),
            Align(
              alignment: const Alignment(0, -0.86),
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.32),
                      AppColors.primary.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(22, 8, 22, 24 + bottom),
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      children: [
                        _staggered(
                          start: 0,
                          end: 0.45,
                          Column(
                            children: [
                              Container(
                                width: 78,
                                height: 78,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/logo.png',
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.bolt_rounded,
                                    color: AppColors.primary,
                                    size: 36,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'ZAIZEN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 280),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                transitionBuilder: (child, anim) {
                                  return FadeTransition(
                                    opacity: anim,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.12, 0),
                                        end: Offset.zero,
                                      ).animate(anim),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Text(
                                  _isSignUp ? s.createAccount : s.signInHint,
                                  key: ValueKey('${_isSignUp}_${s.languageCode}'),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _staggered(
                          start: 0.12,
                          end: 0.7,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xCC0E1420),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  children: [
                                    _ModeSwitch(
                                      isSignUp: _isSignUp,
                                      onChanged: (v) {
                                        if (v == _isSignUp) return;
                                        setState(() => _isSignUp = v);
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    AnimatedSize(
                                      duration: const Duration(milliseconds: 360),
                                      curve: Curves.easeOutCubic,
                                      child: Column(
                                        children: [
                                          if (_isSignUp) ...[
                                            _Field(
                                              label: s.nameLabel,
                                              hint: 'Asliddin',
                                              controller: _nameCtrl,
                                              icon: CupertinoIcons.person,
                                            ),
                                            const SizedBox(height: 14),
                                          ],
                                          _Field(
                                            label: s.email,
                                            hint: 'you@email.com',
                                            controller: _emailCtrl,
                                            keyboardType: TextInputType.emailAddress,
                                            icon: CupertinoIcons.mail,
                                          ),
                                          const SizedBox(height: 14),
                                          _Field(
                                            label: s.password,
                                            hint: '••••••••',
                                            controller: _passCtrl,
                                            obscure: _obscure,
                                            icon: CupertinoIcons.lock,
                                            suffix: _Eye(
                                              obscure: _obscure,
                                              onTap: () => setState(() => _obscure = !_obscure),
                                            ),
                                          ),
                                          if (_isSignUp) ...[
                                            const SizedBox(height: 10),
                                            _PasswordStrengthBar(password: _passCtrl.text),
                                            const SizedBox(height: 14),
                                            _Field(
                                              label: s.confirmPassword,
                                              hint: '••••••••',
                                              controller: _confirmCtrl,
                                              obscure: _obscure2,
                                              icon: CupertinoIcons.lock_shield,
                                              suffix: _Eye(
                                                obscure: _obscure2,
                                                onTap: () => setState(() => _obscure2 = !_obscure2),
                                              ),
                                            ),
                                          ],
                                          if (!_isSignUp) ...[
                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                minSize: 0,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      transitionDuration: const Duration(milliseconds: 380),
                                                      reverseTransitionDuration: const Duration(milliseconds: 280),
                                                      pageBuilder: (_, anim, __) => const ForgotPasswordScreen(),
                                                      transitionsBuilder: (_, anim, __, child) {
                                                        final curved = CurvedAnimation(
                                                          parent: anim,
                                                          curve: Curves.easeOutCubic,
                                                        );
                                                        return FadeTransition(
                                                          opacity: curved,
                                                          child: SlideTransition(
                                                            position: Tween<Offset>(
                                                              begin: const Offset(0.06, 0),
                                                              end: Offset.zero,
                                                            ).animate(curved),
                                                            child: child,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  s.forgotPassword,
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    _PrimaryButton(
                                      label: _isSignUp ? s.signUp : s.signIn,
                                      loading: _loading,
                                      onTap: _loading ? () {} : _handleSubmit,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        const Expanded(child: Divider(color: AppColors.border)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            s.orWord,
                                            style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        ),
                                        const Expanded(child: Divider(color: AppColors.border)),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _GoogleButton(
                                      loading: _googleLoading,
                                      onTap: _googleLoading ? () {} : _handleGoogle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _isSignUp ? s.dataSafe : s.continueNeedLogin,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  final bool isSignUp;
  final ValueChanged<bool> onChanged;
  const _ModeSwitch({required this.isSignUp, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = L.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _chip(s.signIn, !isSignUp, () => onChanged(false)),
          _chip(s.signUp, isSignUp, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: active
                ? const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  )
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderFocused, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  final String password;
  const _PasswordStrengthBar({required this.password});

  @override
  Widget build(BuildContext context) {
    final score = PasswordRules.strength(password);
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF97316),
      const Color(0xFFEAB308),
      const Color(0xFF22C55E),
      const Color(0xFF3B82F6),
    ];
    final color = colors[score.clamp(0, 4)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            final on = score > i;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                height: 4,
                margin: EdgeInsets.only(right: i == 3 ? 0 : 5),
                decoration: BoxDecoration(
                  color: on ? color : const Color(0xFF232838),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 220),
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          child: Text(
            password.isEmpty
                ? L.of(context).passwordHintShort
                : PasswordRules.strengthLabel(score),
          ),
        ),
      ],
    );
  }
}

class _Eye extends StatelessWidget {
  final bool obscure;
  final VoidCallback onTap;
  const _Eye({required this.obscure, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
        color: AppColors.textMuted,
        size: 18,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool loading;
  const _GoogleButton({required this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.g_mobiledata_rounded, color: AppColors.google, size: 28),
                  const SizedBox(width: 6),
                  Text(
                    L.of(context).googleContinue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
